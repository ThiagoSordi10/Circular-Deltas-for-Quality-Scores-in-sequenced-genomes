import pickle

def read_serialized_object():
	pickle_in = open("serialized_list.pickle", "rb")
	serialized = pickle.load(pickle_in)
	return(serialized)

def main():
	data =read_serialized_object()
	for i in range(0,len(data),1):
		print("posicao: ", i)
		print(data[i], "\n")


main()