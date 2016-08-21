#!/bin/bash

METANAME=( $(unzip -v "$1" | grep "\.opf$") )
METADATA=$(unzip -p "$1" ${METANAME[7]})

echo "$METADATA" | xml_grep "metadata/dc:title" --text_only
echo "$METADATA" | xml_grep "metadata/dc:creator" --text_only
echo "$METADATA" | xml_grep "metadata/dc:language" --text_only
