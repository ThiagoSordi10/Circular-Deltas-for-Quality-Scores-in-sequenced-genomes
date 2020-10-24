import fileinput
import matplotlib.pyplot as plot
import pickle
import numpy as np

#The dictionary with all the QS values [33, 74]
dictionary = {}

#Funtion to serialize the list of dictionaries
def serialize_dict(dictionary):
	pickle_out = open("serialized_dict.pickle", "wb")
	pickle.dump(dictionary, pickle_out)
	pickle_out.close()

def main():
	#start the line counter
	line_count = 0
	#get every line from the file readed
	for line in fileinput.input():
		#increment the line counter
		line_count += 1
		#if the line is the QS line, then
		if line_count == 4:
			#get every character from that line
			for i in range(0,len(line),1):
				key = line[i]
				#if the character is a key from the dictionary, then increment it value
				if key in dictionary:
					dictionary[key] +=1
				else:
					if(key != '\n'):
						dictionary.update({key:1})

			line_count = 0


	sorted_dictionary = sorted(dictionary.items())
	print(sorted_dictionary)
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