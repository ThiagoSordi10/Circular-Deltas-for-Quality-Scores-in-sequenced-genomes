#!/bin/bash
if [ "$#" -ne "3" ]; then
    echo "Error. Not enough arguments."
	echo "EXAMPLE: ./entry_fetching.sh [file]input.txt [file]output.txt [file]failed_entries_output.txt"
    exit 1
fi
echo "Enough arguments supplied. Ready to go."
echo

# input file
INPUT=$1
# and the output file
OUTPUT=$2
# and a file specifically for failed entries
FAILED_ENTRIES_OUTPUT=$3

# this remove duplicate files, so that all the reads we do are not appended to old read files
remove_duplicate_files () {
	if test -f $1; then
		rm $1
	fi
}

# this fetches an entry from an accession
fetch_entries() {
    for LINE in `cat $INPUT`
    do

        ACCESSION=`echo $LINE | awk '{print $1}'`
        ENTRY=`echo $LINE | awk '{print $2}'`
        # disable_connections "2"

        # get the FASTQ entry number $ENTRY from the genome $ACCESSION and store it in the output file
        ACCESSION_RESULT=`fastq-dump.2.10.8 -N $ENTRY -X $ENTRY --skip-technical -Z $ACCESSION`
        if [[ "$ACCESSION_RESULT" == *"$ACCESSION"* ]]; then
            entry_fetched_successfully
        else
            entry_failed_to_be_fetched
        fi

        # enable_connections
    done
}

# if an entry is successfully fetched, it is written to the output
entry_fetched_successfully() {
	echo "fastq_dump successful for accession number $ACCESSION with entry $ENTRY." 
	echo "The entry $ENTRY for accession $ACCESSION will be written to $OUTPUT."
	echo

	echo "$ACCESSION_RESULT" >> $OUTPUT
}

# if an entry fails to be fetched, it is written to the failed entries output
entry_failed_to_be_fetched() {
	echo "fastq_dump unsuccessful for accession $ACCESSION with entry $ENTRY." 
	echo "The entry $ENTRY for accession $ACCESSION could not be fetched."
	echo

	echo "$ACCESSION.$ENTRY" >> $FAILED_ENTRIES_OUTPUT
}

remove_duplicate_files $OUTPUT
remove_duplicate_files $FAILED_ENTRIES_OUTPUT

fetch_entries