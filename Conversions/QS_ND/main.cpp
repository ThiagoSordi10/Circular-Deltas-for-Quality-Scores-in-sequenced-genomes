#include <stdio.h>
#include <stdlib.h>
#include <vector>
#include <fstream>
#include <iostream>
#include <string>

/**
How the Normal delta(ND) conversion from Quality Scores(QS) works?
QS are represented by:

	!"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~

The byte representing the quality runs from lowest(!) to high quality(~)
The ideia is to Write the first Ascii char. The next ones will be 
calculated by the result of the subtraction of the actual char and last char
EX: 
 QS:F  C  B  A  A  G  L 
 ND:F -3 -1 -1  0  6  5

After that, we convert the ND to ND+75
**/

int main(int argc, char *argv[]){
	//This is the file with fastq data
	std::ifstream file(argv[1]);
	//This is the file that should contains the normal delta values
	//OBS: we only change the line that have fastq data, the other lines are the same
	std::ofstream normal(argv[2]);
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