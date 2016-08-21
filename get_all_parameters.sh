#!/bin/bash

if [ -z "$1" ]
then
  echo
  echo "Usage: $0 <connection> { <connection> }"
  echo
  echo "Retrieve all parameters for the given databases"
  echo
  exit -1
else
  list=( "$@" )
fi

unset SQLPATH

for x in "${list[@]}"
do
  CONNECTION="$x"
  SID="${CONNECTION//*@/}"
  OUTFILE="${SID}-params.txt"

  sqlplus -s ${CONNECTION} > /dev/null 2>&1 <<!
SET ECHO OFF
COLUMN NAME_COL_PLUS_SHOW_PARAM  FORMAT a40
COLUMN TYPE                      FORMAT a20
COLUMN VALUE_COL_PLUS_SHOW_PARAM FORMAT a1000
SET FEEDBACK     OFF
SET HEADING      OFF
SET PAGESIZE     0
SET LINESIZE     32767
SET TERM         OFF
SET TRIMOUT      ON
SET TRIMSPOOL    ON
SET VERIFY       OFF
SET SERVEROUTPUT OFF

spool '${OUTFILE}'
show parameters;
spool off;
exit;
!

  if [ -s "${OUTFILE}" ]
  then
    echo "$SID"
  else
    rm -f "${OUTFILE}"
  fi
done
