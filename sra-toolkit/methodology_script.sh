#!/bin/bash

if [ "$#" -ne "5" ]; then
    echo "Error. Not enough arguments."
    exit 1
fi
echo "Enough arguments supplied. Ready to go."
echo

# get the file with the accession list from the arguments
INPUT=$1
# number of fastq entries to fetch from each genome
NUM_READS_PER_GENOME=$2
# and the output file
OUTPUT=$3
# and a file specifically for failed accessions
FAILED_ACCESSIONS=$4
# integrity protection revises the output to check if some accessions contain wrong information
# maybe unnecessary? just didnt want to throw this out.
INTEGRITY_PROTECTION=$5

if test -f $OUTPUT; then
	rm $OUTPUT
fi

if test -f $FAILED_ACCESSIONS; then
	rm $FAILED_ACCESSIONS
fi

NUM_ACCESSIONS=1
# for each accession id in the list
for ACCESSION in `cat $INPUT`
do
	# get the number of FASTQ entries on that file
	NUM_ENTRIES=`vdb-dump --id_range $ACCESSION | awk '{print $7}' | tr -d ","`
	
	if [ -z  "$NUM_ENTRIES" ]; then
		echo "vdb_dump unsuccessful on accession number $NUM_ACCESSIONS." 
		echo "The accession $ACCESSION could not be fetched."
		echo

		$ACCESSION >> $FAILED_ACCESSIONS 2>/dev/null
	else
		# calculate a hash (int) based on the id to use as a seed of a random number generator
		HASH=`cksum <<< $ACCESSION | cut -f 1 -d ' '`
		# print the info about the genome (accession id, hash, and number of entries available)
		echo "vdb_dump successful on accession number $NUM_ACCESSIONS." 
		echo "The accession $ACCESSION (with hash/seed $HASH) contains $NUM_ENTRIES FASTQ entries."

		# fetch $NUM_READS_PER_GENOME entries from each genome
		for (( i=0; i<$NUM_READS_PER_GENOME; i++ ))
		do
			# calculate a random entry number (smaller than the total number of entries available in the genome)
			ENTRY=$(($RANDOM%$NUM_ENTRIES))
			echo "The entry $ENTRY will be requested for accession $ACCESSION."

			# echo "Recreating ERROR 2, disabling all connections..."
			# nmcli networking off
			# sleep 10s

			# get the FASTQ entry number $ENTRY from the genome $ACCESSION and store it in the output file
			ACCESSION_RESULT=`fastq-dump.2.10.8 -N $ENTRY -X $ENTRY --skip-technical -Z $ACCESSION`
			if [[ $ACCESSION_RESULT = "Failed to call external services." ]]; then
				echo "fastq_dump unsuccessful for accession number $NUM_ACCESSIONS with entry $ENTRY." 
				echo "The entry $ENTRY accession $ACCESSION could not be fetched."
				echo

				$ACCESSION >> $FAILED_ACCESSIONS 2>/dev/null
			else
				echo "fastq_dump successful for accession number $NUM_ACCESSIONS with entry $ENTRY." 
				echo "The entry $ENTRY accession $ACCESSION will be written to $OUTPUT."
				echo

				$ACCESSION_RESULT >> $OUTPUT 2>/dev/null
			fi

			# echo "Reenabling connections..."
			# nmcli networking on
			# sleep 10s
		done
	fi

	((NUM_ACCESSIONS=NUM_ACCESSIONS+1))
done

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
			echo "$comment1" | awk '{print $1}' | tr -d "@" | cut -f1 -d "." >> $FAILED_ACCESSIONS 2>/dev/null

			# deletes all the lines from this accession
			sed -i "/$comment1/d" $OUTPUT
			sed -i "/$dna/d" $OUTPUT
			sed -i "/$comment2/d" $OUTPUT
			sed -i "/$qs/d" $OUTPUT
		fi
	done < "$OUTPUT"
fi