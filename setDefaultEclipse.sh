#!/bin/bash

# check dependencies
for def in $PROGRAM_NAME crudini
do
  VAR_NAME=$(echo ${def/:*/} | sed "s/-//g" | tr "[:lower:]" "[:upper:]")

  for cmd in $(echo ${def/*:/} | tr "," " ")
  do
    TEMP=$(which $cmd)
    eval "$VAR_NAME=\"$TEMP\""
  done

  if [ ! -x "$TEMP" ]
  then
    echo -e "\e[01;31m${def/*:} missing! \e[00m" | sed "s/,/ and /g"
    exit -1
  fi
done


find . -name ".default.settings" -type l \
| sort -u \
| while read settings
  do
    location=$(dirname "$settings")
    LIST=$(sed "s/ *#.*//g" "$settings" | cut -d$'\t' -f1 | sort -u)
    echo -e "\e[38;5;245mChanging: \e[01;33m$location\e[00m"

    sed "s/ *#.*//g" "$settings" \
    | grep -v "^$" \
    | sed "s/\\\\/\\\\\\\\/g" \
    | while read file key value
    do
      $CRUDINI --verbose --set "$location/.metadata/.plugins/org.eclipse.core.runtime/.settings/$file" "" "$key" "$value" 2>&1 | grep -wv "^unchanged:"
    done

    for file in $LIST
    do
      sed -i "s/  *= */=/" "$location/.metadata/.plugins/org.eclipse.core.runtime/.settings/$file"
    done
  done
