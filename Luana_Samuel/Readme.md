

>Os primeiros passos para instalar o sra-toolkit estao neste link:
	https://github.com/Shurtugall/Circular-Deltas-for-Quality-Scores-in-sequenced-genomes/tree/master/sra-toolkit#instalar-e-configurar-uma-vers%C3%A3o-recente-do-sra-toolkit

>Proximos passos:

	1) Instalar a ferramenta curl:
	$ sudo apt-get install curl

	2) Instalar a ferramenta esearch, que está disponível no pacote eDirect através dos seguintes passos:
	$ sh -c "$(curl -fsSL ftp://ftp.ncbi.nlm.nih.gov/entrez/entrezdirect/install-edirect.sh)"
	$ export PATH=${PATH}:${HOME}/edirect
	Esses passos estão detalhados em https://www.ncbi.nlm.nih.gov/books/NBK179288/

	3) Testar se está funcionando bem:
	$ esearch -version

	4)Executar uma busca com o esearch para consultar o número de genomas disponíveis de acordo com a query que queremos:
	$ esearch -db sra -query '"wgs"[Strategy] AND "filetype fastq"[Properties] AND cluster_public[Properties] AND "biomol dna"[Properties]'  > SraRunInfo.log

	5)  Executar o esearch para buscar toda a lista de genomas disponíveis no SRA:
	$ esearch -db sra -query '"wgs"[Strategy] AND "filetype fastq"[Properties] AND cluster_public[Properties] AND "biomol dna"[Properties]' | efetch -format runinfo > SraRunInfo.csv

//faca o dowload do sra_script em   https://github.com/Shurtugall/Circular-Deltas-for-Quality-Scores-in-sequenced-genomes/tree/master/sra-toolkit/sra_script.py
 
>Para conseguir uma pasta com todos os resultados basta ter o "SraRunInfo.csv" e o "sra_script.py" na mesma pasta

>Para ter os resultados execute:
	$ python3 sra_script.py
 	Sem argumentos este script criara uma pasta "Results" separando por plataforma e maquina o "run" e "spots"

>Para apagar o resultado gerado execute :
	$ pyhton3 sra_script.py -r
 	A flag '-r' indica que os resultados devem ser apagados