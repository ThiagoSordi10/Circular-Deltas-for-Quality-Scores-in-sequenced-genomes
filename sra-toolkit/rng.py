import random
import sys

def main():
    random.seed(int(sys.argv[3]))

    for _ in range(int(sys.argv[4])):
        if(int(sys.argv[2]) != 0):
            print(sys.argv[1] + "," + str(random.randint(0, int(sys.argv[2]))))

if __name__ == "__main__":
    main()