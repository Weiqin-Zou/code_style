import os
import re
import io
import sys
import traceback
import re

def stringMatch(codefile):
    strp=re.compile(r"\".*?\"")
    coma=re.compile(r";")
    cmt=re.compile(r"//.*")
    lineCnt=0
    comaCnt=0
    for line in codefile.xreadlines():
        line=line.strip("\n")
        s=re.sub(strp,'',line)
        s=re.sub(cmt,'',s)
        if coma.search(s):
            lenM=len(coma.findall(s))
            if lenM != 1:
                lineCnt+=1
                comaCnt+=lenM
    print "lineCnt:",lineCnt,"comaCnt:",comaCnt

if __name__ == '__main__':
    try:
        codeFile = sys.argv[1]
        stringMatch(file(codeFile,'r'))
    except:
        traceback.print_exc()
