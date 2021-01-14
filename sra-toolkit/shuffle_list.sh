#!/bin/bash
if [ "$#" -ne "1" ]; then
    echo "Error. Not enough arguments."
	echo "EXAMPLE: ./shuffle_list.sh [file]input.txt"
    exit 1
fi
echo "Enough arguments supplied. Ready to go."
echo

INPUT=$1

`python3 shuffle.py $INPUT`

IFS=. read FILENAME EXTENSION <<< $INPUT
echo "$INPUT shuffled into ${FILENAME}_shuffled.${EXTENSION}."