#include <stdio.h>
#include <stdlib.h>
#include <vector>
#include <fstream>
#include <iostream>
#include <string>

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
					//Get the difference betwen the actual QS value and the last one.
					int aux = (vetor_qs[i] - vetor_qs[i-1]);
					//Aux is the ND value, now we transform it to CD value
					if(aux >= 21 || aux <= -21){
						switch(aux){
							case 21:
								circular << -20;
								break;
							case 22:
								circular << -19;
								break;
							case 23:
								circular << -18;
								break;
							case 24:
								circular << -17;
								break;
							case 25:
								circular << -16;
								break;
							case 26:
								circular << -15;
								break;
							case 27:
								circular << -14;
								break;
							case 28:
								circular << -13;
								break;
							case 29:
								circular << -12;
								break;
							case 30:
								circular << -11;
								break;
							case 31:
								circular << -10;
								break;
							case 32:
								circular << -9;
								break;
							case 33:
								circular << -8;
								break;
							case 34:
								circular << -7;
								break;
							case 35:
								circular << -6;
								break;
							case 36:
								circular << -5;
								break;
							case 37:
								circular << -4;
								break;
							case 38:
								circular << -3;
								break;
							case 39:
								circular << -2;
								break;
							case 40:
								circular << -1;
								break;
							case -40:
								circular << 1;
								break;
							case -39:
								circular << 2;
								break;
							case -38:
								circular << 3;
								break;
							case -37:
								circular << 4;
								break;
							case -36:
								circular << 5;
								break;
							case -35:
								circular << 6;
								break;
							case -34:
								circular << 7;
								break;
							case -33:
								circular << 8;
								break;
							case -32:
								circular << 9;
								break;
							case -31:
								circular << 10;
								break;
							case -30:
								circular << 11;
								break;
							case -29:
								circular << 12;
								break;
							case -28:
								circular << 13;
								break;
							case -27:
								circular << 14;
								break;
							case -26:
								circular << 15;
								break;
							case -25:
								circular << 16;
								break;
							case -24:
								circular << 17;
								break;
							case -23:
								circular << 18;
								break;
							case -22:
								circular << 19;
								break;
							case -21:
								circular << 20;
								break;
						}
						//circular << (aux % 20) * -1;
						//circular << ' ';
					}
					else{
						//Write to the new file values between [-20,20]
						circular << aux;
						//circular << ' ';
					}
					circular << ' ';
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
