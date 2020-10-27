#include <stdio.h>
#include <stdlib.h>
#include <vector>
#include <fstream>
#include <iostream>
#include <string>

using namespace std;

int circular_distance(int theNormalDelta, int theLen){
	//this is the same as the function Math.floorMod from Java
	int value = (theNormalDelta % theLen + theLen) % theLen;
	if (value < (theLen/2)){
			return value;
		}
	return value - theLen;
}

int main(int argc, char *argv[]){
	//This is the fastq data file
	ifstream file(argv[1]);
	//This is the new circular delta file
	ofstream circular(argv[2]);

	if(file.is_open()){
		std::string line;
		//this is the CD interval [-20,20] == 41 values
		int interval = 41;
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