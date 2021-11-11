#include <stdio.h>
#include <stdlib.h>
#include <vector>
#include <fstream>
#include <iostream>
#include <string>

const std::vector<char> explode(const std::string& s, const char& c);

int circular_distance(int theNormalDelta, int theLen);

int qs_nd(std::string fastq_file, std::string nd_file);

int qs_cd(std::string fastq_file, std::string cd_file);

int nd_qs(std::string nd_file, std::string fastq_file);

int cd_qs(std::string cd_file, std::string fastq_file);