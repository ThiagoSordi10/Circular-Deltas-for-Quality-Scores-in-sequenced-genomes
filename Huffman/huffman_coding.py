import fileinput
import huffman
import csv
import pickle
import sys

dictionary ={}

#done: modified the script to include all characters of each line, it was consi>


#done: include \n symbol because lines have different sizes. After each line, w>


def main():
        #to-do: include all symbols in the dictionary at the beginning, even if>
        key = chr(10) #LF NL newline, linefeed
        dictionary.update({key:1})
        for i in range(33,127):
                key = chr(i)
                dictionary.update({key:1})

	#For each row in the input file
        for rows in fileinput.input():
                for key in rows:
			#increment the value of occurrences
                        if key in dictionary:
                                dictionary[key] +=1
                        else:
                                print(ord(key))
                                print('error not in dict')
                                sys.exit(1)
	
	#Create the huffman tree with the dictionary items and also the dict with huffman values
        huff_dict = huffman.codebook(dictionary.items())
	print(huffman.codebook(dictionary.items()))

	#get the Byte array with huffman dictionary
        bitArrayStr=''
        for rows in fileinput.input():
                for key in rows:
                        if(key in huff_dict):
                                bitArrayStr = bitArrayStr+huff_dict[key]

#done: write the string s
        buffer = bytearray()
        i=0
	while i < len(bitArrayStr):
            buffer.append( int(bitArrayStr[i:i+8], 2) )
            i += 8

        # now write your buffer to a file
        with open(fileinput.filename()+".huffman", "bw") as f:
            f.write(buffer)

        f.close()


main()



