#!/bin/bash

# number of fastq entries to fetch from each genome
NUM_READS_PER_GENOME=1

# get the file with the accession list from the arguments
ACCESSION_LIST=$1
# and the output file
OUT_FILE=$2

# for each accession id in the list
for ACCESSION in `cat $ACCESSION_LIST`
do
	# get the number of FASTQ entries on that file
	NUM_ENTRIES=`vdb-dump --id_range $ACCESSION | awk '{print $7}' | tr -d ","`
	# calculate a hash (int) based on the id to use as a seed of a random number generator
	HASH=`cksum <<< $ACCESSION | cut -f 1 -d ' '`
	# print the info abou the genome (accession id, hash, and number of entries available)
	echo "### The accession $ACCESSION (with hash/seed $HASH) contains $NUM_ENTRIES FASTQ entries."
	# use the hash as the seed of the RANDOM bash variable
	RANDOM=$HASH
	# fetch $NUM_READS_PER_GENOME entries from each genome
	for (( i=0; i<$NUM_READS_PER_GENOME; i++ ))
	do
		# calculate a random entry number (smaller than the total number of entries available in the genome)
		RANDOM_ENTRY=$(($RANDOM%$NUM_ENTRIES))
		echo $RANDOM_ENTRY
		# get the FASTQ entry number $RANDOM_ENTRY from the genome $ACCESSION and store it in the output file
		fastq-dump.2.10.8 -N $RANDOM_ENTRY -X $RANDOM_ENTRY --skip-technical -Z $ACCESSION >> $OUT_FILE 2>/dev/null
	done
done
