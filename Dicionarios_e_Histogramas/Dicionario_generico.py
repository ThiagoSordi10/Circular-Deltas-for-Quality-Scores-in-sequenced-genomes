import fileinput
import matplotlib.pyplot as plot
import pickle
import numpy as np
from math import log2


#The dictionary with all the QS values [33, 74]
dictionary = {}

def calculate_entropy(lista, somatorio):
	ent_total = 0
	for i in range (0,len(lista),1):
		ent_total = ent_total + ((lista[i]/somatorio) * log2(lista[i]/somatorio))

	return -ent_total


#Funtion to serialize the list of dictionaries
def serialize_dict(dictionary):
	pickle_out = open("serialized_dict.pickle", "wb")
	pickle.dump(dictionary, pickle_out)
	pickle_out.close()

def main():
	#start the line counter
	line_count = 0
	lista = []
	#get every line from the file readed
	for line in fileinput.input():
		#increment the line counter
		line_count += 1
		#if the line is the QS line, then
		if line_count == 4:
			#get every character from that line
			for i in range(0,len(line),1):
				key = line[i]
				#---------------------------------------
				if key != '\n':
					lista.append(line[i])
				#--------------------------------------
				#if the character is a key from the dictionary, then increment it value
				if key in dictionary:
					dictionary[key] +=1
				else:
					if(key != '\n'):
						dictionary.update({key:1})

			line_count = 0

	#organize the dictionary by ASCII value
	sorted_dictionary = sorted(dictionary.items())
	print(sorted_dictionary)

	#creates a new list with all the dictionary values to calculate the entropy
	entropy_list = []
	entropy_list = list(dictionary.values())
	#call the function that calculates the entropy
	print("Entropy:", calculate_entropy(entropy_list, sum(entropy_list)))

	#serialize the dictionary
	serialize_dict(dictionary)

	#plot the graphic
	pos_0 = list(zip(*sorted_dictionary))[0]
	pos_1 = list(zip(*sorted_dictionary))[1]
	x_pos = np.arange(len(pos_0))

	plot.bar(x_pos,pos_1,align='center')
	plot.xticks(x_pos,pos_0)
	plot.show()

	
main()
