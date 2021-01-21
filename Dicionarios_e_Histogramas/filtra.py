import fileinput
import sys


QS_permitidos = {'!', '"', '#', '$', '%', '&', "'", '(', ')', '*', '+', ',', '-', '.', '/', '0', '1', '2', '3',
			  '4', '5', '6', '7', '8', '9', ':', ';', '<', '=', '>', '?', '@', 'A', 'B', 'C', 'D', 'E', 'F',
			  'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y',
			  'Z', '[', '\\', ']', '^', '_', '`', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l',
			  'm', 'n', 'o', 'p', 'q', 'r', 's', 't', ' ', \n'}

Genomas_permitidos = {'A', 'C', 'G', 'N', 'T', '\n'}

def main():
	line_count = 0

	linha1 = "x"
	linha2 = "x"
	linha3 = "x"
	linha4 = "x"
	erro = False
	genoma = True

	lido = sys.argv[1]
	file = open(lido+"_filtrado", "w")

	for line in fileinput.input():
		line_count +=1
		erro = False
		genoma = True

		if line[0] == '@' and (line[1] == 'S' or line[1] == 'E') and (line[2] == 'R') and line[3] == 'R':
			#if line[1] == 'S' or line[1] == 'E':
				#if line[2] == 'R':
					#if line[3] == 'R':
						#Se a primeira linha for @SRR, ou @ERR, ta correto
						linha1 = line
						#print(linha1)

					
				

		elif line[0] == '+' and (line[1] == "\n" or (line[1] == 'S' or line[1] == 'E') and (line[2] == 'R')):
			#if line[1] == 'S' or line[1] == 'E':
				#if line[2] == 'R':
					#Se a terceira linha começa com +SR ou +ER, ta correto
						linha3 = line
						#print(linha3)

			#elif line[1] == "\n":
				#linha3 = line
				#print(linha3)


		else:
			for i in range (0, len(line), 1):
				#if line[i] in Genomas_permitidos:
				#significa que é a segunda linha

				if line[i] in QS_permitidos:
					if line[i] not in Genomas_permitidos:
						#significa que é a quarta linha
						genoma = False

					erro = False

				else:
					print("\nDeu erro:"+line[i]+"\n"+line)
					erro = True

			#Se os valores estão contidos dentro do intervalo pertimitido:
			if erro == False:
				#Se a linha lida foi uma linha referente a sequencia de genomas:
				if genoma == True:
					linha2 = line
					#print(linha2)

				#Se a linha lida foi uma linha QS:
				else:
					if line_count == 4:
						linha4 = line
					elif line_count != 4:
						line_count = 0
					#print(linha4)

		if (linha1 != "x" and linha2 != "x" and linha3 != "x" and linha4 != "x"):
			file.write(linha1)
			file.write(linha2)
			file.write(linha3)
			file.write(linha4)
			linha1 = "x"
			linha2 = "x"
			linha3 = "x"
			linha4 = "x"

		if line_count == 4:
			line_count = 0
			linha1 = "x"
			linha2 = "x"
			linha3 = "x"
			linha4 = "x"

		erro = False

	file.close()

main()
