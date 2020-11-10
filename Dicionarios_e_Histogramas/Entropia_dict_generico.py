import fileinput
import matplotlib.pyplot as plot
import pickle
import numpy as np
import pandas as pd
from scipy.stats import entropy

from math import log, e

#The dictionary with all the QS values [33, 74]
dictionary = {}

#--------------------
#funcao teste para entropia encontrada em: https://stackoverflow.com/questions/15450192/fastest-way-to-compute-entropy-in-python
def entropia(labels):
	n_labels = len(labels)

	if n_labels <= 1:
		return 0

	counts = np.bincount(labels)
	probs = counts[np.nonzero(counts)] / n_labels
	n_classes = len(probs)

	if n_classes <=1:
		return 0

	return - np.sum(probs * np.log(probs) / np.log(n_classes))
#------------------------------

#Funtion to serialize the list of dictionaries
def serialize_dict(dictionary):
	pickle_out = open("serialized_dict.pickle", "wb")
	pickle.dump(dictionary, pickle_out)
	pickle_out.close()

def main():
	#start the line counter
	line_count = 0
	#--------------------
	lista = []
	#--------------------
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

	#-------------------------------------
	#le a lista de caracteres totais
	test_series = pd.Series(lista)
	contador = test_series.value_counts()
	test_ent = entropy(contador)
	#print(contador)

	print("entropy (function):", entropia(contador))


	#tentativa de entropia encontrada em: https://www.kite.com/python/answers/how-to-calculate-shannon-entropy-in-python
	pd_series = pd.Series(sorted_dictionary)
	counts = pd_series.value_counts()
	entropy_values = entropy(counts)
	print("entropy (pd_series and scipy.stats):", entropy_values)
	#---------------------------------------

	#print(dictionary)
	serialize_dict(dictionary)
	#plot the graphic
	#plot.bar(range(len(dictionary)), list(dictionary.values()), align='center')
	#plot.xticks(range(len(dictionary)), list(dictionary.keys()))
	#plot.show()

	pos_0 = list(zip(*sorted_dictionary))[0]
	pos_1 = list(zip(*sorted_dictionary))[1]
	x_pos = np.arange(len(pos_0))

	plot.bar(x_pos,pos_1,align='center')
	plot.xticks(x_pos,pos_0)
	plot.show()


main()
