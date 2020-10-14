#!/bin/bash

# get the file with the accession list from the arguments
INPUT=$1

# number of fastq entries to fetch from each genome
NUM_READS_PER_GENOME=$2

# and the output file
OUTPUT=$3

if [ "$#" -ne "3" ]; then
    echo "Error. Not enough arguments."
    exit 1
fi
echo "OK."

rm ./$OUTPUT

# for each accession id in the list
for ACCESSION in `cat $INPUT`
do
	# get the number of FASTQ entries on that file
	NUM_ENTRIES=`vdb-dump --id_range $ACCESSION | awk '{print $7}' | tr -d ","`
	# calculate a hash (int) based on the id to use as a seed of a random number generator
	HASH=`cksum <<< $ACCESSION | cut -f 1 -d ' '`
	# print the info about the genome (accession id, hash, and number of entries available)
	echo "### The accession $ACCESSION (with hash/seed $HASH) contains $NUM_ENTRIES FASTQ entries."
	# use the hash as the seed of the RANDOM bash variable
	RANDOM=$HASH
	# fetch $NUM_READS_PER_GENOME entries from each genome
	for (( i=0; i<$NUM_READS_PER_GENOME; i++ ))
	do
		# calculate a random entry number (smaller than the total number of entries available in the genome)
		ENTRY=$(($RANDOM%$NUM_ENTRIES))
		echo $ENTRY
		# get the FASTQ entry number $ENTRY from the genome $ACCESSION and store it in the output file
		fastq-dump.2.10.8 -N $ENTRY -X $ENTRY --skip-technical -Z $ACCESSION >> $OUTPUT 2>/dev/null
	done
done

while read comment1; read dna; read comment2; read qs
do
  # IF ERROR
  sed -i "/$comment1/d" $OUTPUT
  sed -i "/$dna/d" $OUTPUT
  sed -i "/$comment2/d" $OUTPUT
  sed -i "/$qs/d" $OUTPUT
done < "$OUTPUT"