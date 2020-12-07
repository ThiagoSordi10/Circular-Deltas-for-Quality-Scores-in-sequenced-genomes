#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
    srand(atoi(argv[2]));
    printf("%d", rand() % atoi(argv[1]));
}