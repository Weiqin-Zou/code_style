import sys
import os

def rm21NArecord(prOrcb21_fin,NAnum=21):
    for line in prOrcb21_fin.xreadlines():
        if line.count("#") != int(NAnum):
            print line.strip('\n')


if __name__ == '__main__':
    prOrcb21_fin=sys.argv[1]
    NAnum=sys.argv[2] #default is 21
    rm21NArecord(file(prOrcb21_fin,'r'),NAnum)
