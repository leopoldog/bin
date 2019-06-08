#!/bin/bash

RED="\e[01;31m"
GREEN="\e[01;32m"
YELLOW="\e[01;33m"
WHITE="\e[0m"

# Check dependencies and defines environment variables with the same name as the specified command (in uppercase)
# It's possible to define a variable name followed by a list of commands, the first found is used, ex.:
#   terminal:mate-terminal,gnome-terminal,xterm
#   The variable $TERMINAL will refer to mate-terminal if present or gnome-terminal and in last resort to xterm.
#
# If one of the variables can't be defined an error is written and the function returns -1.
checkDependencies() {
  local MISSING=""
  local def
  local cmd
  local VAR_NAME
  local TEMP

  for def in "$@"
  do
    VAR_NAME=$(echo ${def/:*/} | sed "s/-//g" | tr "[:lower:]" "[:upper:]")

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
  done

  if [ ! -z "$MISSING" ]
  then
    echo -e "${MISSING}" | sed "s/,/\", \"/g" | sort -u | sed "s/^$/Missing commands:/" >&2
    echo -e "\nPlease install the corresponding packages." >&2
    return -1
  fi

  return 0
}
