#!/bin/bash
if [ "$#" -ne "5" ]; then
    echo "Error. Not enough arguments."
	echo "EXAMPLE: ./methodology_script.sh [integer]<number of reads per genome> [file]input.txt [file]output.txt [file]failed_accessions_output.txt [file]failed_entries_output.txt"
    exit 1
fi
echo "Enough arguments supplied. Ready to go."
echo

# number of fastq entries to fetch from each genome
NUM_READS_PER_QUERY=$1
# input file
INPUT=$2
# and the output file
OUTPUT=$3
# and a file specifically for failed accessions
FAILED_ACCESSIONS_OUTPUT=$4
# and a file specifically for failed entries
FAILED_ENTRIES_OUTPUT=$5

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
	for ACCESSION in `cat $INPUT`
	do
		# disable_connections "1"

		# get the number of FASTQ entries on that file
		NUM_ENTRIES=`vdb-dump --id_range $ACCESSION | awk '{print $7}' | tr -d ","`
		
		if [ -z  "$NUM_ENTRIES" ]; then
			fetch_accession_failed
		else
			fetch_entries_from_accession
		fi

		# enable_connections

		((NUM_ACCESSIONS=NUM_ACCESSIONS+1))
	done
}

# if fetch_accession fails, it will write this accession to the failed_accessions output
fetch_accession_failed() {
	echo "vdb_dump unsuccessful on accession number $NUM_ACCESSIONS." 
	echo "The accession $ACCESSION could not be fetched."
	echo

	echo "$ACCESSION" >> $FAILED_ACCESSIONS_OUTPUT
}

# this function will run fetch_entry for every entry requested for each accession
fetch_entries_from_accession() {
	# calculate a hash (int) based on the id to use as a seed of a random number generator
	HASH=`cksum <<< $ACCESSION | cut -f 1 -d ' '`
	# print the info about the genome (accession id, hash, and number of entries available)
	echo "vdb_dump successful on accession number $NUM_ACCESSIONS." 
	echo "The accession $ACCESSION (with hash/seed $HASH) contains $NUM_ENTRIES FASTQ entries."

	if [ $HASH_ACCESSIONS = true ]; then
		RANDOM=$HASH
	fi

	# fetch $NUM_READS_PER_QUERY entries from each genome
	for (( i=0; i<$NUM_READS_PER_QUERY; i++ ))
	do
		fetch_entry
	done
}

# this fetches an entry from an accession
fetch_entry() {
	# calculate a random entry number (smaller than the total number of entries available in the genome)
	ENTRY=`gcc -o random random.c && ./random $NUM_ENTRIES $HASH`
	echo "The entry $ENTRY will be requested for accession $ACCESSION."

	# disable_connections "2"

	# get the FASTQ entry number $ENTRY from the genome $ACCESSION and store it in the output file
	ACCESSION_RESULT=`fastq-dump.2.10.8 -N $ENTRY -X $ENTRY --skip-technical -Z $ACCESSION`
	if [[ "$ACCESSION_RESULT" == *"$ACCESSION"* ]]; then
		entry_fetched_successfully
	else
		entry_failed_to_be_fetched
	fi

	# enable_connections
}

# if an entry is successfully fetched, it is written to the output
entry_fetched_successfully() {
	echo "fastq_dump successful for accession number $NUM_ACCESSIONS with entry $ENTRY." 
	echo "The entry $ENTRY for accession $ACCESSION will be written to $OUTPUT."
	echo

	echo "$ACCESSION_RESULT" >> $OUTPUT
}

# if an entry fails to be fetched, it is written to the failed entries output
entry_failed_to_be_fetched() {
	echo "fastq_dump unsuccessful for accession number $NUM_ACCESSIONS with entry $ENTRY." 
	echo "The entry $ENTRY for accession $ACCESSION could not be fetched."
	echo

	echo "$ACCESSION.$ENTRY" >> $FAILED_ENTRIES_OUTPUT
}

# TEST TOOL: disables connections before a request
disable_connections () {
	echo "Recreating ERROR $1, disabling all connections..."
	nmcli networking off
	sleep 10s
}

# TEST TOOL: reenables connections
enable_connections() {
	echo "Reenabling connections..."
	nmcli networking on
	sleep 10s
}

# OUR CODE STARTS HERE
remove_duplicate_files $OUTPUT
remove_duplicate_files $FAILED_ACCESSIONS_OUTPUT
remove_duplicate_files $FAILED_ENTRIES_OUTPUT

fetch_accession