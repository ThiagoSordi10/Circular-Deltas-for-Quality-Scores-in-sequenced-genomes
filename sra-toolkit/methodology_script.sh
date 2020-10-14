#!/bin/bash

# get the file with the accession list from the arguments
INPUT=$1

# number of fastq entries to fetch from each genome
NUM_READS_PER_GENOME=$2

# and the output file
OUTPUT=$3

# and a file specifically for failed accessions
FAILED_ACCESSIONS=$4

if [ "$#" -ne "4" ]; then
    echo "Error. Not enough arguments."
    exit 1
fi
echo "OK."

rm ./$OUTPUT

NUM_ACCESSION=1
# for each accession id in the list
for ACCESSION in `cat $INPUT`
do
	# get the number of FASTQ entries on that file
	NUM_ENTRIES=`vdb-dump --id_range $ACCESSION | awk '{print $7}' | tr -d ","`
	# calculate a hash (int) based on the id to use as a seed of a random number generator
	HASH=`cksum <<< $ACCESSION | cut -f 1 -d ' '`
	# print the info about the genome (accession id, hash, and number of entries available)
	echo "$NUM_ACCESSION. The accession $ACCESSION (with hash/seed $HASH) contains $NUM_ENTRIES FASTQ entries."
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

	((NUM_ACCESSION=NUM_ACCESSION+1))
done

while read comment1; read dna; read comment2; read qs
do
	if [ `echo -n $dna | wc -c` -ne `echo "$comment1" | awk '{print $3}' | tr -d "length="` ] || 
	[ `echo -n $qs | wc -c` -ne `echo "$comment2" | awk '{print $3}' | tr -d "length="` ]; then

		echo "$comment1" | awk '{print $1}' | tr -d "@" | cut -f1 -d "." >> $FAILED_ACCESSIONS 2>/dev/null

		sed -i "/$comment1/d" $OUTPUT
		sed -i "/$dna/d" $OUTPUT
		sed -i "/$comment2/d" $OUTPUT
		sed -i "/$qs/d" $OUTPUT
	fi
done < "$OUTPUT"