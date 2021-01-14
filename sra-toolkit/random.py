import random2
import sys

def main():
    random2.seed(int(sys.argv[3]))

    for i in range(int(sys.argv[4])):
        if(int(sys.argv[2]) != 0):
            print(sys.argv[1] + "," + str(random2.randint(0, int(sys.argv[2]))))

if __name__ == "__main__":
    main()