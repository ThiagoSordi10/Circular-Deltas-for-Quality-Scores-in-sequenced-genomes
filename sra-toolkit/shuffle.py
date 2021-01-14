import random
import sys

filename,extension = sys.argv[1].split('.', 1)

with open((filename + "." + extension),'r') as source:
    data = [ (random.random(), line) for line in source ]
data.sort()

with open((filename + "_shuffled." + extension),'w') as target:
    for _, line in data:
        target.write( line )