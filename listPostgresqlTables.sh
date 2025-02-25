#!/bin/bash

hostname="$1"
username="$2"
database="$3"

if [ -z "$hostname" -o -z "$username" -o -z "$database" ]
then
  echo "Usage: $0 <hostname> <username> <database>"
  exit -1
fi

psql -h "$hostname" -U "$username" "$database" <<-!
	select schemaname as table_schema,
	       relname as table_name,
	       pg_size_pretty(pg_relation_size(relid)) as data_size
	  from pg_catalog.pg_statio_user_tables
	 order by pg_relation_size(relid) desc;
!
