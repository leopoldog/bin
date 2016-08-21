#!/bin/bash -f

unset LANG

unalias -a

function Decode ()
{
    FILENAME="$1"
    
    while read -r line
    do
	if [ "$line" = "end" ]
	then
	    break
	fi

	split=$(echo "$line" | sed "s;^\(.\).*;\1;g")
	count=$((4*(63&($(printf "%d" "'$split")-32))))
	data=$(echo "$line" | sed "s/^.\(.*\)/\1/g;\
s/\([\` -/]\)/a\1/g;\
s/\([0-?]\)/b\1/g;\
s/\([@-O]\)/c\1/g;\
s/\([P-_]\)/d\1/g;\
s/\([\` -#0-3@-CP-S]\)/a\1/g;\
s/\([\$-'4-7D-GT-W]\)/b\1/g;\
s/\([(-+8-;H-KX-[]\)/c\1/g;\
s/\([,-/<-?L-O\\-_]\)/d\1/g;\
s}\` !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_}aabcdabcdabcdabcdabcdabcdabcdabcdabcdabcdabcdabcdabcdabcdabcdabcd};\
s/\(..\)\(..\)/\\\\x\1 \2/g;\
s/aa/0/g;\
s/ab/1/g;\
s/ac/2/g;\
s/ad/3/g;\
s/ba/4/g;\
s/bb/5/g;\
s/bc/6/g;\
s/bd/7/g;\
s/ca/8/g;\
s/cb/9/g;\
s/cc/A/g;\
s/cd/B/g;\
s/da/C/g;\
s/db/D/g;\
s/dc/E/g;\
s/dd/F/g;\
s/ //g")

	printf "${data:0:$count}" >> "$FILENAME"
    done
    return 0
}

if [ "$1" = "" ]
then
    echo
    echo "Usage: $0 <filename>"
    echo
    echo "<filename> : A file on the disk or - for the standard input"
    echo
    exit 1
fi

if [ "$1" != "-" ]
then
    if [ -f "$1" ]
    then
	exec < "$1"
    else
	echo "Please specify the filename"
    fi
fi

while read -r line
do
    split=( $line )
    if [ "${split[0]}" = "begin" ]
    then
	echo -n > ${split[2]}
	chmod ${split[1]} ${split[2]}
	echo "Decoding: ${split[2]}"
	Decode "${split[2]}"
	echo "done."
    fi
done

exit 0

