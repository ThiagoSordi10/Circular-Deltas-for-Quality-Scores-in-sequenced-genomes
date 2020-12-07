#!/bin/bash
if [ "$#" -ne "5" ]; then
    echo "Error. Not enough arguments."
	echo "EXAMPLE: ./accession_fetching.sh [integer]<number of reads per genome> [boolean]<prefetched> [file]input.txt [file]output.txt [file]failed_accessions_output.txt"
    exit 1
fi
echo "Enough arguments supplied. Ready to go."
echo

# number of fastq entries to fetch from each genome
NUM_READS_PER_QUERY=$1
# is it prefetched or not?
PREFETCHED=$2
# input file
INPUT=$3
# and the output file
OUTPUT=$4
# and a file specifically for failed accessions
FAILED_ACCESSIONS_OUTPUT=$5

# this remove duplicate files, so that all the reads we do are not appended to old read files
remove_duplicate_files () {
	if test -f $1; then
		rm $1
	fi
}

# this will fetch the number of entries of an accession
fetch_accession() {
	NUM_ACCESSIONS=1
	# for each accession id in the list
	for LINE in `cat $INPUT`
	do
		# disable_connections "1"
		if [ ! $PREFETCHED ] 
		then
			# get the number of FASTQ entries on that file
			ACCESSION=`echo $LINE`
			NUM_ENTRIES=`vdb-dump --id_range $ACCESSION | awk '{print $7}' | tr -d ","`
		else
			ACCESSION=`echo $LINE | tr "," " " | awk '{print $1}'`
        	NUM_ENTRIES=`echo $LINE | tr "," " " | awk '{print $2}'`
		fi
		
		if [ -z  "$NUM_ENTRIES" ]; then
			fetch_accession_failed
		else
			generate_entries_for_accession
		fi

		# enable_connections

		((NUM_ACCESSIONS=NUM_ACCESSIONS+1))
	done
}

# this function will run fetch_entry for every entry requested for each accession
generate_entries_for_accession() {
	# calculate a hash (int) based on the id to use as a seed of a random number generator
	HASH=`cksum <<< $ACCESSION | cut -f 1 -d ' '`
	
	if [ ! $PREFETCHED ]
	then
		# print the info about the genome (accession id, hash, and number of entries available)
		echo "vdb_dump successful on accession number $NUM_ACCESSIONS."
		echo "The accession $ACCESSION (with hash/seed $HASH) contains $NUM_ENTRIES FASTQ entries."
	fi

	# calculate a random entry number (smaller than the total number of entries available in the genome)
    ENTRIES=`./random $ACCESSION $NUM_ENTRIES $HASH $NUM_READS_PER_QUERY`
    echo "$ENTRIES" >> $OUTPUT
}

# if fetch_accession fails, it will write this accession to the failed_accessions output
fetch_accession_failed() {
	echo "vdb_dump unsuccessful on accession number $NUM_ACCESSIONS." 
	echo "The accession $ACCESSION could not be fetched."
	echo

	echo "$ACCESSION" >> $FAILED_ACCESSIONS_OUTPUT
}

# OUR CODE STARTS HERE
remove_duplicate_files $OUTPUT
remove_duplicate_files $FAILED_ACCESSIONS_OUTPUT

`gcc -o random random.c`

fetch_accession