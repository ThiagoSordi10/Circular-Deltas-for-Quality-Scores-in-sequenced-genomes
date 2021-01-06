import fileinput
import huffman
import csv
import pickle

dictionary ={}

def main():

	with open('delta.csv', mode='r') as infile:
		reader = csv.reader(infile)
		for rows in reader:
			key = rows[0]
			if key in dictionary:
				dictionary[key] +=1
			else:
				dictionary.update({key:1})


	huff_dict = huffman.codebook(dictionary.items())
	print(huffman.codebook(dictionary.items()))

	outF = open("huffman", "wb")
	with open('delta.csv', mode='r') as infile:
		reader = csv.reader(infile)
		for rows in reader:
			key = rows[0]
			if(key in huff_dict):
				outF.write(str.encode(huff_dict[key]))

	

	outF.close()

	pickle_out = open("serialized_delta.pickle", "wb")
	pickle.dump(dictionary, pickle_out)
	pickle_out.close()

main()