#!/bin/bash

RED=$'\e[01;31m'
GREEN=$'\e[01;32m'
YELLOW=$'\e[01;33m'
WHITE=$'\e[0m'

# Check dependencies and defines environment variables with the same name as the specified command (in uppercase)
# It's possible to define a variable name followed by a list of commands, the first found is used, ex.:
#   terminal:mate-terminal,gnome-terminal,xterm
#   The variable $TERMINAL will refer to mate-terminal if present or gnome-terminal and in last resort to xterm.
#
# If a variable is already defined, it's skipped.
# If one of the variables can't be defined an error is written and the function returns -1.
function checkDependencies() {
  local MISSING=""
  local def
  local cmd
  local VAR_NAME
  local TEMP

  for def in "$@"
  do
    VAR_NAME=$(echo ${def/:*/} | sed "s/-//g" | tr "[:lower:]" "[:upper:]")

    if [ -z "${!VAR_NAME}" ]
    then
      for cmd in $(echo ${def/*:/} | tr "," " ")
      do
        TEMP=$(which $cmd)
        if [ ! -z "$TEMP" ]
        then
          eval "$VAR_NAME=\"$TEMP\""
          break;
        fi
      done

      if [ ! -x "$TEMP" ]
      then
        case "$def" in
          *:*) MISSING="${MISSING}  One of \"${def/*:}\"\n" ;;
          *)   MISSING="${MISSING}  The \"${def}\"\n" ;;
        esac
      fi
    fi
  done

  if [ ! -z "$MISSING" ]
  then
    echo -e "${MISSING}" | sed "s/,/\", \"/g" | sort -u | sed "s/^$/Missing commands:/" >&2
    echo -e "\nPlease install the corresponding packages." >&2
    return -1
  fi

  return 0
}

function getMacViaSSH()
{
  local CN="$1"
  local IP_ADDRESS="$2"
  local PASS="$3"
  local BUFFER

  if [ -z "$PASS" ]
  then
    checkDependencies ssh
    BUFFER="$($SSH -oBatchMode=yes -oUserKnownHostsFile=/dev/null -oStrictHostKeyChecking=no -nq ${CN} "/sbin/ip addr show primary || /bin/ip addr show primary || /sbin/esxcfg-info -n" 2>&1)"
  else
    checkDependencies ssh sshpass
    BUFFER="$($SSHPASS "$PASS" $SSH -oBatchMode=yes -oUserKnownHostsFile=/dev/null -oStrictHostKeyChecking=no -nq ${CN} "/sbin/ip addr show primary || /bin/ip addr show primary || /sbin/esxcfg-info -n" 2>&1)"
  fi

  if echo "$BUFFER" | grep -q "not found"
  then
    echo "$BUFFER" \
    | tr "\n" " " \
    | sed "s/VmKernel Nic/\nVmKernel Nic/g;s/\<\(${IP_ADDRESS}\)\>/\1\n/g" \
    | grep "\<${IP_ADDRESS}\>" \
    | sed "s/.*Mac Address\.*\([0-9a-f:]*\)[[:space:]].*/\1/g" \
    | sort -u \
    | head -n 1
  else
    echo "$BUFFER" \
    | sed "s/^\([^[:space:]]\)/+++\1/g" \
    | tr "\n" " " \
    | sed "s/+++/\n/g" \
    | sed -n "s;.*link/ether *\([^[:space:]]\+\) .*${IP_ADDRESS}.*;\1;p"
  fi
}

function checkMacViaSSH()
{
  local CN="$1"
  local MAC="$2"
  local PASS="$3"

  if [ -z "$PASS" ]
  then
    checkDependencies ssh
    $SSH -oBatchMode=yes -oUserKnownHostsFile=/dev/null -oStrictHostKeyChecking=no -nq ${CN} "/bin/ip addr show primary || /sbin/ip addr show primary || /sbin/esxcfg-nics -l" \
    | grep -q "\<\(${MAC}\)\>"
  else
    checkDependencies sshpass ssh
    $SSHPASS "$PASS" $SSH -oBatchMode=yes -oUserKnownHostsFile=/dev/null -oStrictHostKeyChecking=no -nq ${CN} "/bin/ip addr show primary || /sbin/ip addr show primary || /sbin/esxcfg-nics -l" \
    | grep -q "\<\(${MAC}\)\>"
  fi
}

function getGeometry()
{
  local display
  local position
  local winSize
  local panels
  local full=0
  local wide=0
  local optpos=$OPTIND

  checkDependencies xwininfo xrandr

  OPTIND=1
  while getopts "fwd:p:" opt "${@}"
  do
    case $opt in
      f) full=1 ;;
      w) wide=1 ;;
      d) display=$OPTARG
         if ! ${XRANDR} -q | grep -w "connected" | grep -q "^$display\s"
         then
           echo "getGeometry: ERROR: Invalid display specified: $OPTARG"
           return
         fi
         ;;
      p) position="$(echo "$OPTARG" | sed -n "s/^\([0-9]*\)$/\1/p")"
         if [ -z "$position" ]
         then
           echo "getGeometry: ERROR: Invalid position specified: $OPTARG"
           return
         fi
         ;;
      \?) echo "getGeometry: ERROR: Unknown option"
          return ;;
    esac
  done

  OPTIND=$optpos

  if [ $wide -eq 1 ]
  then
    winSize=$(echo $(${XWININFO} -root \
                     | sed -n "s/ *\(Width\|Height\): //p") 0 0)
  else
    winSize=$(${XRANDR} -q \
              | grep -w "connected" \
              | grep "^$display" \
              | sed -n "s/.*connected[[:space:]]*\(primary\)\?[[:space:]]\+\([0-9]*\)x\([0-9]*\)+\([0-9]*\)+\([0-9]*\)[[:space:]].*/\2 \3 \4 \5 \1/p" \
              | sort -rk5)
  fi

  if [ $full -eq 0 ]
  then
    panels="$(LC_ALL=C \
              ${XWININFO} -root -tree \
              | grep -i "\"\(\(top\|bottom\|left\|right\) panel\|pannello \(superiore\|inferiore\|destro\|sinistro\)\)\"" \
              | sed "s/ *\([^ ]*\) .*/\1/g" \
              | while read id; \
                do \
                  pos=$(${XWININFO} -id $id); \
                  echo $(echo "$pos" | sed -n "s/.*Absolute upper-left X: *\([0-9]*\)/\1/p"; \
                         echo "$pos" | sed -n "s/.*Absolute upper-left Y: *\([0-9]*\)/\1/p"; \
                         echo "$pos" | sed -n "s/.*Width: *\([0-9]*\)/\1/p"; \
                         echo "$pos" | sed -n "s/.*Height: *\([0-9]*\)/\1/p"); \
                done
              )"
  fi

  # This method gets the borders on the selected screen but it fails if the screens superposes
  # I've found a way to avoid the case where the two displays show exactly the same image, but if the screens displays just a subimage of the main screen
  # it still fails
  local borders=( $( (
                       echo "0 0 0"
                       echo "${winSize}" \
                       | while read a b c d e
                         do
                           Xs="${c:=0}"
                           Xe="$(( $c + ${a:=0} ))"
                           Xm="$(( ( $Xs + $Xe ) / 2 ))"
                           Ys="${d:=0}"
                           Ye="$(( $d + ${b:=0} ))"
                           Ym="$(( ( $Ys + $Ye ) / 2 ))"
                           echo "$panels" \
                           | grep -v "^$" \
                           | while read a1 b1 c1 d1
                             do
                               X=$(( $a1 + $c1 / 2 ))
                               Y=$(( $b1 + $d1 / 2 ))
                               if [ $X -lt $Xe -a $X -ge $Xs -a $Y -lt $Ye -a $Y -ge $Ys ]
                               then
                                 if [ $c1 -gt $d1 ]
                                 then
                                   if [ $b1 -gt $Ym ]
                                   then
                                     echo b 0 $d1 $a $b $c $d
                                   else
                                     echo t 0 $d1 $a $b $c $d
                                   fi
                                 else
                                   if [ $a1 -gt $Xm ]
                                   then
                                     echo r $c1 0 $a $b $c $d
                                   else
                                     echo l $c1 0 $a $b $c $d
                                   fi
                                 fi
                               fi
                             done
                           done \
                       | sort -u
                     ) | (
                          sumX=0
                          sumY=0
                          sumSX=0
                          sumSY=0
                          while read p x y a b c d
                          do
                            let sumX=sumX+x
                            let sumY=sumY+y
                            if [ "$p" == "l" -o "$p" == "t" ]
                            then
                              let sumSX=sumSX+x
                              let sumSY=sumSY+y
                            fi
                          done
                          echo "$sumX $sumY $sumSX $sumSY"
                        )
                   ) )

  echo "${winSize[*]}" | grep -qw primary
  with_primary=$?

  echo "$winSize" \
  | while read x y sx sy primary
    do
      let y=y-borders[1]
      let sy=sy+borders[3]
      let x=x-borders[0]-position
      let sx=sx+borders[2]+position
      echo ${x}x${y}+${sx}+${sy}
    done \
  | uniq \
  | head -n1
}
