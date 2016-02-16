# -*- encoding:utf-8 -*-
import io
import sys
import traceback
import re

#we only extract the modi java code(new added + modi) from the patch file
def get_modiJavaAmount(patch_fin):
    try:
        diffFlag=0
        javaFlag=0
        indexFlag=0
        linesFlag=0
        addedCnt=0
        addedJavaCnt=0

        fromp=re.compile(r'^From ')
        javaDiffp=re.compile(r'^diff.*\.java$')
        allDiffp=re.compile(r'^diff')
        indexp=re.compile(r'^index ')
        linesp=re.compile(r'^@@ -[0-9]+,[0-9]+ \+[0-9]+,[0-9]+ @@')
        chgLinep=re.compile(r'^\+')
        for line in patch_fin.readlines():
            try:
                if fromp.match(line):
                    indexFlag=0
                    linesFlag=0
                    diffFlag=0
                    javaFlag=0
                    continue
                if allDiffp.match(line):
                    indexFlag=0
                    linesFlag=0
                    diffFlag=1
                    javaFlag=0
                    if javaDiffp.match(line):
                        javaFlag=1
                    continue

                if diffFlag==0:
                    continue

                if indexp.match(line):
                    indexFlag=1
                    continue

                if linesp.match(line):
                    linesFlag=1
                    continue

                if diffFlag and indexFlag and linesFlag:
                    if chgLinep.match(line):
                        addedCnt+=1
                        if javaFlag:
                            addedJavaCnt+=1
            except:
                traceback.print_exc()
        print str(addedCnt)+","+str(addedJavaCnt)
    except:
        traceback.print_exc()


if __name__ == '__main__':
    try:
        #print(isMultiCmtStart("f*///dj/*jfkdf//sdf"))
        patch_fin=sys.argv[1]
        get_modiJavaAmount(file(patch_fin))
    except:
        traceback.print_exc()

