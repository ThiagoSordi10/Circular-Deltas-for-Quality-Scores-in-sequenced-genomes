#include <stdio.h>
#include <stdlib.h>
#include <vector>
#include <fstream>
#include <iostream>

/**
	How the Circular Delta (CD) conversion from Normal Delta (ND) works?
	ND are represented between the interval [-40,+40].
	For the CD, we should represent the bytes between [-20,+20].
	So every ND value inside this interval keeps the same, but the values between
	[-40,-21] must be represented by [1,20] and the interval [21,40] must be
	represented by [-20, -1].
**/

int main(){
	//This is the file with fastq data
	std::ifstream file("SRR618664_1_100.fastq");
	//This is the file that should contains the circular delta values
	//OBS: we only change the line that have fastq data, the other lines are the same
	std::ofstream circular("circular.txt");
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
				std::vector<int> vetor_qs(line.begin(), line.end());
				//we write the first byte
				circular << (char)vetor_qs[0];
				circular << ' ';

				for(auto i = 1; i <vetor_qs.size(); i++){
					//Get the difference betwen the actual QS value and the last one
					int aux = (vetor_qs[i] - vetor_qs[i-1]);
					//Aux is the ND value, now we transform it to CD value
					if(aux >= 21 || aux <= -21){
						circular << (aux % 20) * -1;
						circular << ' ';
					}
					else{
						//Write to the new file values between [-20,20]
						circular << aux;
						circular << ' ';
					}
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
