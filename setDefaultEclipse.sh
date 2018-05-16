#!/bin/bash

ECLIPSE_DEFAULT=~/bin/setDefaultEclipse.csv

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
    echo "${def/*:} missing!" | sed "s/,/ and /g"
    exit -1
  fi
done

LIST=$(sed "s/ *#.*//g" ${ECLIPSE_DEFAULT} | cut -d$'\t' -f1 | sort -u)

find ~ -name "org.eclipse.core.runtime" -type d | grep ".metadata/.plugins/org.eclipse.core.runtime" \
| while read location
  do
    echo "Changing: $location"

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
