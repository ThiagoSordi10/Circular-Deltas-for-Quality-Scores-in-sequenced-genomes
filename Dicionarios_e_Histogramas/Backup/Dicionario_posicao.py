import fileinput
import matplotlib.pyplot as plot
import matplotlib.image as mpimg
import os
import pickle

#The dictionary with all the QS values [33, 74]
dictionary = {}

#Function to plot the graphic for each dictionary
def ploted(d, i, path):
	plot.bar(range(len(d)), list(d.values()), align='center')
	plot.xticks(range(len(d)), list(d.keys()))
	#save the plot as .png images
	plot.savefig(path+'/'+'Line('+str(i)+').png')
	#both methods used to clear the current axes and plots
	#If we do not use this functions, the plot image will be a wrong plot
	plot.cla()
	plot.clf()


#Function that create a list of 500 dictionaries
def create_list(lst):
	for i in range(0,500,1):
		#For each index of the list creates a copy of the dictionary structure
		lst.append(dictionary.copy())

#Funtion to create the Images directory
def create_directory(file_name):
	#get the actual directory of the project
	parent_directory = os.getcwd()
	#get the name of the new directory (images_from_'data.fastq')
	new_directory = "Images_from_"+file_name
	#path contains the file path
	path = os.path.join(parent_directory, new_directory)
	#verify if the directory already exists
	if(os.path.isdir(path)):
		print("Saving into images file...")
	else:
		os.mkdir(path)

	return path

#Funtion to serialize the list of dictionaries
def serialize_list(lst):
	pickle_out = open("serialized_list.pickle", "wb")
	pickle.dump(lst, pickle_out)
	pickle_out.close()

def main():
	#start the line counter
	line_count = 0
	#Inicializes the list that will receive the dictionaries
	lst = []
	#Create the of dictionaries
	create_list(lst)

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
				if key in lst[i]:
					lst[i][key] +=1
				else:
					if(key != '\n'):
						lst[i].update({key:1})

			line_count = 0
	
	#Get the name of the file readed
	file_name = fileinput.filename()
	file_name = file_name.split('.')[0]

	#Create a new directory to save the plots
	path = create_directory(file_name)

	#Print and plot
	for i in range(0,len(line),1):
		print("posicao: ", i)
		ploted(lst[i], i, path)
		print(lst[i], "\n")

	#Save the List of dictionaries with pickle serialization
	serialize_list(lst)

main()