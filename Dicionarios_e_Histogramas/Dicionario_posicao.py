import fileinput
import matplotlib.pyplot as plot

#The dictionary with all the QS values [33, 74]
dictionary = {'!':0, '"':0, '#':0, '$':0, '%':0, '&':0, "'":0, '(':0, '|':0, '*':0,
 			  '+':0, ',':0, '-':0, '.':0, '/':0, '0':0, '1':0, '2':0, '3':0, '4':0,
 			  '5':0, '6':0, '7':0, '8':0, '9':0, ':':0, ';':0, '<':0, '=':0, '?':0,
 			  '?':0, '@':0, 'A':0, 'B':0, 'C':0, 'D':0, 'E':0, 'F':0, 'G':0, 'H':0,
 			  'I':0, 'J':0,}

#Function to plot the graphic for each dictionary
def ploted(d):
	plot.bar(range(len(d)), list(d.values()), align='center')
	plot.xticks(range(len(d)), list(d.keys()))
	plot.show()

#Function that create a list of 500 dictionaries
def create_list(lst):
	for i in range(0,500,1):
		#For each index of the list creates a copy of the dictionary structure
		lst.append(dictionary.copy())

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
				if key in dictionary:
					lst[i][key] +=1

			line_count = 0
	
	for i in range(0,len(line),1):
		print("posicao: ", i)
		ploted(lst[i])
		print(lst[i], "\n")

main()