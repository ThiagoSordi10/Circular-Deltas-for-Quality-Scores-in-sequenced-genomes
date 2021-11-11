#include "conversion.h"

const std::vector<char> explode(const std::string& s, const char& c){

	std::vector<char> v;

	for(auto n:s){
		if(n!=c){
			v.push_back(n);
		}
	}
	return v;
}

int circular_distance(int theNormalDelta, int theLen){
	//this is the same as the function Math.floorMod from Java
	int value = (theNormalDelta % theLen + theLen) % theLen;
	if (value < (theLen/2)){
			return value;
		}
	return value - theLen;
}

int qs_nd(std::string fastq_file, std::string nd_file){
	//This is the file with fastq data
	std::ifstream file(fastq_file);
	//This is the file that should contains the normal delta values
	//OBS: we only change the line that have fastq data, the other lines are the same
	std::ofstream normal(nd_file);
	//We open the fastq file
	if(file.is_open()){
		std::string line;
		int line_count = 0;
		//read line by line the file
		while(getline(file, line)){
			line_count += 1;
			//If it is the fourth line that should be the fastq data, then...
			if(line_count == 4){
				//We create a vector that receives a line of the fastq file
				std::vector<char> vetor_qs(line.begin(), line.end());
				//we write the first value of the 
				normal << vetor_qs[0];

				for(auto i = 1; i <vetor_qs.size(); i++){
					//Get the difference betwen the actual QS value and the last one
					int aux = ((int)vetor_qs[i] - (int)vetor_qs[i-1])+75;
					//Write to the new file 
					normal << char(aux);
				}
				//write the break line and reset the counter line
				normal << "\n";
				line_count = 0;
			}
			//If it is the other lines, just write the same line at the normal delta file
			else{
				normal << line;
				normal << "\n";
			}
		}	
	}
	file.close();
	normal.close();
	return 0;
}

int qs_cd(std::string fastq_file, std::string cd_file){
	//This is the fastq data file
	std::ifstream file(fastq_file);
	//This is the new circular delta file
	std::ofstream circular(cd_file);

	if(file.is_open()){
		std::string line;
		//this is the CD interval [-20,20] == 41 values
		// int interval = 41;
		int line_count = 0;
		//read line by line the file
		while(getline(file, line)){
			line_count += 1;
			//If it is the fourth line that should be the fastq data, then...
			if(line_count == 4){
				//We create a vector that receives a line of the fastq file
				std::vector<char> vetor_qs(line.begin(), line.end());
				//we write the first byte
				circular << vetor_qs[0];

				for(auto i = 1; i <vetor_qs.size(); i++){
					//Get the difference betwen the actual QS value and the last one
					int NDvalue = ((int)vetor_qs[i] - (int)vetor_qs[i-1]);
					//Aux is the ND value, now we transform it to CD value
					int aux = circular_distance(NDvalue, interval)+75;
					circular << char(aux);
				}
				//write the break line and reset the counter line
				circular << "\n";
				line_count = 0;
			}
			//If it is the other lines, just write the same line at the normal delta file
			else{
				circular << line;
				circular << "\n";
			}
		}	
	}
	file.close();
	circular.close();
	return 0;
}

int nd_qs(std::string nd_file, std::string fastq_file){
	//This is the file with normal delta data
	std::ifstream file(nd_file);
	//This is the new fastq data
	std::ofstream fastq(fastq_file);

	
	if(file.is_open()){
		std::string line;
		int line_count = 0;
		while(getline(file, line)){
			line_count += 1;
			//If it is the fourth line that should be the fastq data, then...
			if(line_count == 4){
				//Creates a vector that each part is a string with the number. EX: v[i] == # 
				std::string linha = line;
				std::vector<char> v(line.begin(), line.end());
				//vector<string> v{explode(linha, ' ')};
				//we write the first char value in the file
				fastq << linha[0];
				//transform the first ascii char to it's respective ascii value. EX: '#' == 35
				int inicial = '0' + linha[0] - '0';
				int valor_anterior;
				int variavel_salva;
				for(auto i = 1; i <v.size(); i++){
					if(i == 1){
						//The first iteration will read the first value of the line 61
						valor_anterior = (int)inicial;
					}else{
						//Before the first iteration, valor_anterior will receive the value
						//that is calculated on line 76
						valor_anterior = variavel_salva;
					}
					//transform the char readed in the text file to a int value.
					int valor = int(v[i]);
					//Gets the sum of the value read and the last value
					int variavel = (valor_anterior + valor)-75;
					//Save the new value into a variable that will be used on line 71
					variavel_salva = variavel;
					//transform the int ascii value to it's respective char ascii value
					char c = '0' + variavel - '0';
					std::cout << c << '|';
					//writes the value to the file
					fastq << c;
				}					
				//write the break line and reset the counter line
				fastq << "\n";
				line_count = 0;
			}
			//If it is the other lines, just write the same line at the normal delta file
			else{
				fastq << line;
				fastq << "\n";
			}
		}
	}
	file.close();
	fastq.close();
	return 0;
}

int cd_qs(std::string cd_file, std::string fastq_file){
	//This is the circular delta file
	std::ifstream file(cd_file);
	//This is the new fastq data
	std::ofstream fastq(fastq_file);
	
	if(file.is_open()){
		std::string line;
		int line_count = 0;
		while(getline(file, line)){
			line_count += 1;
			//If it is the fourth line that should be the fastq data, then...
			if(line_count == 4){
				//Creates a vector that each part is a string with the number. EX: v[i] == # 
				std::string linha = line;
				std::vector<char> v{explode(linha, ' ')};
				//we write the first char value in the file
				fastq << linha[0];
				//transform the first ascii char to it's respective ascii value. EX: '#' == 35
				int inicial = '0' + linha[0] - '0';
				int valor_anterior;
				int variavel_salva;
				for(auto i = 1; i < v.size(); i++){
					if(i == 1){
						//The first iteration will read the first value of the line 61
						valor_anterior = inicial;
					}else{
						//Before the first iteration, valor_anterior will receive the value
						//that is calculated on line 76
						valor_anterior = variavel_salva;
					}
					//transform the char readed in the text file to a int value.
					int valor = v[i]-75;
          
          if(valor_anterior - 33 + valor > interval){
            valor -= interval;
          }else if(valor_anterior - 33 + valor < 0){
            valor += interval;
          }

					//Gets the sum of the value read and the last value
					int variavel = valor_anterior + valor;
					//Save the new value into a variable that will be used on line 71
					variavel_salva = variavel;
					//transform the int ascii value to it's respective char ascii value
					char c = '0' + variavel - '0';
					//cout << c << '|';
					//writes the value to the file
					fastq << c;
				}					
				//write the break line and reset the counter line
				fastq << "\n";
				line_count = 0;
			}
			//If it is the other lines, just write the same line at the normal delta file
			else{
				fastq << line;
				fastq << "\n";
			}
		}
	}
	file.close();
	fastq.close();
	return 0;
}