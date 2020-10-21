#!/bin/bash

if [ "$#" -ne "6" ]; then
    echo "Error. Not enough arguments."
	echo "EXAMPLE: ./methodology_script.sh [integer]<number of reads per genome> [boolean]<random accessions> [boolean]<integrity protection> [file]input.txt [file]output.txt [file]failed_accessions.txt"
    exit 1
fi
echo "Enough arguments supplied. Ready to go."
echo

# number of fastq entries to fetch from each genome
NUM_READS_PER_GENOME=$1
# if the accession reads are >really< random
RANDOM_ACCESSIONS=$2
# integrity protection revises the output to check if some accessions contain wrong information
# maybe unnecessary? just didnt want to throw this out.
INTEGRITY_PROTECTION=$3
# get the file with the accession list from the arguments
INPUT=$4
# and the output file
OUTPUT=$5
# and a file specifically for failed accessions
FAILED_ACCESSIONS=$6

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
	
	# echo "Recreating ERROR 1, disabling all connections..."
	# nmcli networking off
	# sleep 5s

	if [ -z  "$NUM_ENTRIES" ]; then
		echo "vdb_dump unsuccessful on accession number $NUM_ACCESSIONS." 
		echo "The accession $ACCESSION could not be fetched."
		echo

		echo "$ACCESSION" >> $FAILED_ACCESSIONS
	else
		# calculate a hash (int) based on the id to use as a seed of a random number generator
		HASH=`cksum <<< $ACCESSION | cut -f 1 -d ' '`
		# print the info about the genome (accession id, hash, and number of entries available)
		echo "vdb_dump successful on accession number $NUM_ACCESSIONS." 
		echo "The accession $ACCESSION (with hash/seed $HASH) contains $NUM_ENTRIES FASTQ entries."

		if [ $RANDOM_ACCESSIONS = false ]; then
			RANDOM=$HASH
		fi

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
			if [[ "$ACCESSION_RESULT" == *"$ACCESSION"* ]]; then
				echo "fastq_dump successful for accession number $NUM_ACCESSIONS with entry $ENTRY." 
				echo "The entry $ENTRY accession $ACCESSION will be written to $OUTPUT."
				echo

				echo "$ACCESSION_RESULT" >> $OUTPUT
				echo >> $OUTPUT
			else
				echo "fastq_dump unsuccessful for accession number $NUM_ACCESSIONS with entry $ENTRY." 
				echo "The entry $ENTRY accession $ACCESSION could not be fetched."
				echo

				echo "$ACCESSION" >> $FAILED_ACCESSIONS
			fi

			# echo "Reenabling connections..."
			# nmcli networking on
			# sleep 10s
		done
	fi

	# echo "Reenabling connections..."
	# nmcli networking on
	# sleep 5s

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