#include "conversion.h"

int main(int argc, char *argv[]){
  int opt = atoi(argv[1]);
  std::string file_1 = argv[2];
  std::string file_2 = argv[3];
	switch(opt){
    case 1:
      cd_qs(file_1, file_2);
      break;
    case 2:
      nd_qs(file_1, file_2);
      break;
    case 3:
      qs_cd(file_1, file_2);
      break;
    case 4:
      qs_nd(file_1, file_2);
      break;
  }
	return 0;
}