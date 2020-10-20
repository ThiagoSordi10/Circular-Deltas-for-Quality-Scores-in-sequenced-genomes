import pickle

def read_serialized_object():
	#get the file
	pickle_in = open("serialized_list.pickle", "rb")
	#load the seriealized data and returns
	serialized = pickle.load(pickle_in)
	return(serialized)

def main():
	#read the serialized object
	data =read_serialized_object()
	#create new file
	file = open("Output_list", "w")

	#print and save the data into a txt file
	for i in range(0,len(data),1):
		if data[i]:
			print("posicao: ", i)
			print(data[i], "\n")
			file.write("posicao: "+str(i)+"\n")
			file.write(str(data[i]))
			file.write("\n\n")

	file.close()

main()