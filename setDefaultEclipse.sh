#!/bin/bash

. $(dirname "$0")/library.sh

if ! checkDependencies crudini
then
  exit -1
fi

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
      if [ -f "$location/.metadata/.plugins/org.eclipse.core.runtime/.settings/$file" ]
      then
        $CRUDINI --verbose --set "$location/.metadata/.plugins/org.eclipse.core.runtime/.settings/$file" "" "$key" "$value" 2>&1 | grep -wv "^unchanged:"
      fi
    done

    for file in $LIST
    do
      if [ -f "$location/.metadata/.plugins/org.eclipse.core.runtime/.settings/$file" ]
      then
        sed -i "s/  *= */=/" "$location/.metadata/.plugins/org.eclipse.core.runtime/.settings/$file"
      fi
    done
  done
