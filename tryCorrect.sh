#!/bin/bash
#
# Correct a text file with a mix of UTF-8 and ISO-8859-15 values.
# Only the accents on letters are converted (mostly Italian and French accents).
# To correct other characters, this script should be adapted.

FILE="$1"

if [ -z "$FILE" ]
then
  echo "Specify the file to correct"
  exit -1
fi

LC_ALL=C

(
  SUBST=$(IFS=$'\t\t\t'
          while read a b
          do
            eval echo \$"'s:\\x${b// /\\x}:\\x${a// /\\x}:g;'"
          done)
  sed "$SUBST" "$FILE"
) <<-!
c3 a1	c3 83 c2 a1
c3 81	c3 83 c2 81
c3 a0	c3 83 c2 a0
c3 80	c3 83 c2 80
c3 a2	c3 83 c2 a2
c3 82	c3 83 c2 82
c3 a4	c3 83 c2 a4
c3 84	c3 83 c2 84
c3 a3	c3 83 c2 a3
c3 83	c3 83 c2 83
c3 a7	c3 83 c2 a7
c3 87	c3 83 c2 87
c3 a9	c3 83 c2 a9
c3 89	c3 83 c2 89
c3 a8	c3 83 c2 a8
c3 88	c3 83 c2 88
c3 aa	c3 83 c2 aa
c3 8a	c3 83 c2 8a
c3 ab	c3 83 c2 ab
c3 8b	c3 83 c2 8b
e1 ba bd	c3 a1 c2 ba c2 bd
e1 ba bc	c3 a1 c2 ba c2 bc
c3 ad	c3 83 c2 ad
c3 8d	c3 83 c2 8d
c3 ac	c3 83 c2 ac
c3 8c	c3 83 c2 8c
c3 ae	c3 83 c2 ae
c3 8e	c3 83 c2 8e
c3 af	c3 83 c2 af
c3 8f	c3 83 c2 8f
c4 a9	c3 84 c2 a9
c4 a8	c3 84 c2 a8
c3 b3	c3 83 c2 b3
c3 93	c3 83 c2 93
c3 b2	c3 83 c2 b2
c3 92	c3 83 c2 92
c3 b4	c3 83 c2 b4
c3 94	c3 83 c2 94
c3 b6	c3 83 c2 b6
c3 96	c3 83 c2 96
c3 b5	c3 83 c2 b5
c3 95	c3 83 c2 95
c3 ba	c3 83 c2 ba
c3 9a	c3 83 c2 9a
c3 b9	c3 83 c2 b9
c3 99	c3 83 c2 99
c3 bb	c3 83 c2 bb
c3 9b	c3 83 c2 9b
c3 bc	c3 83 c2 bc
c3 9c	c3 83 c2 9c
c5 a9	c3 85 c2 a9
c5 a8	c3 85 c2 a8
!
