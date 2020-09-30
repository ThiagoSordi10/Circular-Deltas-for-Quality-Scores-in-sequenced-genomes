#include <iostream>
#include <vector>
#include <fstream>
#include <list>
#include <sstream>
#include <string>

using namespace std;

//This code will transform a Normal Delta(ND) back to Quality Scores (QS)
//How this works: We get the first ND value and add it to the next value. This will
//be the value of the ascii char of the second value.
//EX: ND file -> # 0 0 0 0 0 0 0
//	  QS file -> #######

//Function to read a string and get just what we need:
//EX: file -> # 0 0 0 0 0 0
//Ignore the ' ' and gets #00000
const vector<string> explode(const string& s, const char& c){

	string buff{""};
	vector<string> v;

	for(auto n:s){
		if(n!=c){
			buff+=n;
		}
		else if(n == c && buff != ""){
			v.push_back(buff);
			buff = "";
		}
	}
	if(buff != ""){
		v.push_back(buff);
	}
	return v;
}


//Simple code to convert normal delta values to fastq values

int main(int argc, char *argv[]){
	//This is the file with normal delta data
	std::ifstream file(argv[1]);
	//This is the new fastq data
	std::ofstream fastq(argv[2]);

	
	if(file.is_open()){
		std::string line;
		int line_count = 0;
		while(getline(file, line)){
			line_count += 1;
			//If it is the fourth line that should be the fastq data, then...
			if(line_count == 4){
				//Creates a vector that each part is a string with the number. EX: v[i] == # 
				string linha = line;
				vector<string> v{explode(linha, ' ')};
				//we write the first char value in the file
				fastq << linha[0];
				//transform the first ascii char to it's respective ascii value. EX: '#' == 35
				int inicial = '0' + linha[0] - '0';
				int valor_anterior;
				int variavel_salva;
				for(auto i = 1; i <v.size(); i++){
					if(i == 1){
						//The first iteration will read the first value of the line 61
						valor_anterior = inicial;
					}else{
						//Before the first iteration, valor_anterior will receive the value
						//that is calculated on line 76
						valor_anterior = variavel_salva;
					}
					//transform the char readed in the text file to a int value.
					int valor = atoi(v[i].c_str());
					//Gets the sum of the value read and the last value
					int variavel = valor_anterior + valor;
					//Save the new value into a variable that will be used on line 71
					variavel_salva = variavel;
					//transform the int ascii value to it's respective char ascii value
					char c = '0' + variavel - '0';
					cout << c << '|';
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
