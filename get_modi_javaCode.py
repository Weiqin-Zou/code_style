# -*- encoding:utf-8 -*-
from __future__ import print_function
import io
import sys
import traceback
import re

#use this function to make the comment display rationally
def cmtMakeup(Version,modiLines):
    strp=re.compile(r"\".*?\"")
    s=re.sub(strp,'',modiLines)
    print(s,end="")
    return
    modi=modiLines.split('\n')
    cmtp=re.compile("/\*")
    #for line in modi:
        #if

#we only extract the modi java code(new added + modi) from the patch file
def get_modi_javaCode(patch_fin):
    try:
        chgLinePattern='^\+'
        diffFlag=0
        indexFlag=0
        linesFlag=0
        laterVer=''
        modi=''

        for line in patch_fin.readlines():
            try:
                #line=line.strip('\n')
                fromp=re.compile(r'^From ')
                javaDiffp=re.compile(r'^diff.*.java')
                allDiffp=re.compile(r'^diff')
                indexp=re.compile(r'^index ')
                linesp=re.compile(r'^@@ -[0-9]+,[0-9]+ \+[0-9]+,[0-9]+ @@')
                chgLinep=re.compile(chgLinePattern)
                laterVersp=re.compile(r'^[ +]')

                if fromp.match(line):
                    indexFlag=0
                    linesFlag=0
                    diffFlag=0
                    continue
                if allDiffp.match(line):
                    indexFlag=0
                    linesFlag=0
                    diffFlag=0
                    if javaDiffp.match(line):
                        diffFlag=1
                    continue

                if diffFlag==0:
                    continue

                if indexp.match(line):
                    indexFlag=1
                    continue

                if linesp.match(line):
                    linesFlag=1
                    if modi:
                        #print(laterVer,end="")
                        cmtMakeup(laterVer,modi)
                        return
                        modi=''
                        laterVer=''
                    continue

                if diffFlag and indexFlag and linesFlag:
                    if laterVersp.match(line):
                        laterVer+=line[1:]
                    if chgLinep.match(line):
                        modi+=line[1:]
            except:
                traceback.print_exc()
        if modi:
            print(laterVer,end="")
    except:
        traceback.print_exc()


if __name__ == '__main__':
    try:
        patch_fin=sys.argv[1]
        get_modi_javaCode(file(patch_fin))
    except:
        traceback.print_exc()

