#!/bin/bash
if [ "$#" -ne "7" ]; then
    echo "Error. Not enough arguments."
	echo "EXAMPLE: ./methodology_script.sh [integer]<number of reads per genome> [boolean]<hash accessions> [boolean]<integrity protection> [file]input.txt [file]output.txt [file]failed_accessions_output.txt [file]failed_entries_output.txt"
    exit 1
fi
echo "Enough arguments supplied. Ready to go."
echo

# number of fastq entries to fetch from each genome
NUM_READS_PER_QUERY=$1
# if the random accessions are hashed
HASH_ACCESSIONS=$2
# integrity protection revises the output to check if some accessions contain wrong information
# maybe unnecessary? just didnt want to throw this out.
INTEGRITY_PROTECTION=$3
# get the file with the accession list from the arguments
INPUT=$4
# and the output file
OUTPUT=$5
# and a file specifically for failed accessions
FAILED_ACCESSIONS_OUTPUT=$6
# and a file specifically for failed entries
FAILED_ENTRIES_OUTPUT=$7

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
	ENTRY=$(($RANDOM%$NUM_ENTRIES))
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

# "integrity_protection" is a function that checks if the genome sequence came with right information
# regarding to length and the actual length of the dna and qs string.
integrity_protection () {
	if [ $INTEGRITY_PROTECTION = true ]; then
		echo "Integrity protection is on. It will delete all inconsistent reads."
		echo
		# reads the output file, accession by accession
		while read comment1; read dna; read comment2; read qs
		do
			# if the length displayed in the comments is not the same in the dna or the quality score, the line is deleted
			if [ `echo -n $dna | wc -c` -ne `echo "$comment1" | awk '{print $3}' | tr -d "length="` ] || 
			[ `echo -n $qs | wc -c` -ne `echo "$comment2" | awk '{print $3}' | tr -d "length="` ]; then

				# gets the accession id, the hardcoded way.
				echo "$comment1" | awk '{print $1}' | tr -d "@" | cut -f1 -d "." >> $FAILED_ACCESSIONS_OUTPUT 2>/dev/null

				# deletes all the lines from this accession
				sed -i "/$comment1/d" $OUTPUT
				sed -i "/$dna/d" $OUTPUT
				sed -i "/$comment2/d" $OUTPUT
				sed -i "/$qs/d" $OUTPUT
			fi
		done < "$OUTPUT"
	fi
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

integrity_protection