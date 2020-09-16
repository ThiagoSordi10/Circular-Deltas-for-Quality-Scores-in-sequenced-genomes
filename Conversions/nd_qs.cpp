#include <iostream>
#include <vector>
#include <fstream>
#include <list>
#include <sstream>

using namespace std;

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

int main(){
	//This is the file with normal delta data
	std::ifstream file("normal.txt");
	//This is the new fastq data
	std::ofstream fastq("fast.txt");

	
	if(file.is_open()){
		std::string line;
		int line_count = 0;
		while(getline(file, line)){
			line_count += 1;
			//If it is the fourth line that should be the fastq data, then...
			if(line_count == 4){
				//cria um vetor onde cada espaco eh uma 
				string linha = line;
				vector<string> v{explode(linha, ' ')};
				//for(auto n:v){
				//	cout << n << '|';
				//}
				//cout << endl;

				//we write the first value of the 
				fastq << linha[0];
				fastq << ' ';
				int inicial = '0' + linha[0];
				cout << linha[0] << '|';
				int valor_anterior;
				for(auto i = 1; i <v.size(); i++){
					if(i == 1){
						valor_anterior = inicial;
					}else{
						valor_anterior = atoi(v[i-1].c_str());
					}
					int valor = atoi(v[i].c_str());
					//cout << valor_anterior << '|';
					int variavel = valor_anterior + valor;
					char c = static_cast<char>(variavel);
					//cout << c << "|";
					//Write to the new file 
					//fastq << (char)variavel;
					fastq << c;
					fastq << ' ';
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
