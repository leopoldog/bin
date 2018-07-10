#!/bin/bash

ECLIPSE_DEFAULT="${0/.sh/.csv}"

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

LIST=$(sed "s/ *#.*//g" ${ECLIPSE_DEFAULT} | cut -d$'\t' -f1 | sort -u)

find . -name "org.eclipse.core.runtime" -type d | grep "/.metadata/.plugins/org.eclipse.core.runtime" \
| while read location
  do
    echo -e "\e[38;5;245mChanging: \e[01;33m$location\e[00m"

    sed "s/ *#.*//g" ${ECLIPSE_DEFAULT} \
    | grep -v "^$" \
    | sed "s/\\\\/\\\\\\\\/g" \
    | while read file key value
    do
      $CRUDINI --verbose --set "$location/.settings/$file" "" "$key" "$value" 2>&1 | grep -wv "^unchanged:"
    done

    for file in $LIST
    do
      sed -i "s/  *= */=/" "$location/.settings/$file"
    done
  done
