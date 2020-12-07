#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
    srand(atoi(argv[3]));

    for(int i = 0; i < atoi(argv[4]); i++) {
        if(atoi(argv[2]) != 0)
            printf("%s,%d\n", argv[1], rand() % atoi(argv[2]));
    }
}