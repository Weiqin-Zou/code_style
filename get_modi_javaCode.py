# -*- encoding:utf-8 -*-
from __future__ import print_function
import io
import sys
import traceback
import re

#use this function to make the comment display rationally
def cmtMakeup(code_piece):
    normal=''
    contbtwCmt=''
    strp=re.compile(r"\".*?\"")
    multiCmtStartp=re.compile(r"/\*(\w|\s)*$")
    multiCmtEndp=re.compile(r"\*/(\w|\s)*$")
    doubleCmtp=re.compile(r"//")
    code=code_piece.split('\n')
    multiCmtStart=False
    multiCmtEnd=False
    for line in code:
        s=re.sub(strp,'',line)
        if not multiCmtStart:
            if not multiCmtStartp.search(s):
                if multiCmtEndp.search(s):
                    normal='/*'+normal
                    if line[0]=='+':
                        normal+=line[1:]+'\n'
                    else:
                        normal+='*/\n'
                    print("hahahaha",end="")
                    print(normal,end="")
                    normal=""
                    contbtwCmt=""
                else:
                    try:
                        if line[0]=='+':
                            normal+=line[1:]+'\n'
                    except:
                        normal+='\n'
            elif multiCmtStartp.search(s):
                if not doubleCmtp.search(s):#a true multi cmt begin
                    try:
                        if line[0]=='+':
                            contbtwCmt+=line[1:]+'\n'
                    except:
                        contbtwCmt+='\n'
                    else:
                        contbtwCmt+='/*'
                    multiCmtStart=True
                else:
                    try:
                        if line[0]=='+':
                            normal+=line[1:]+'\n'
                    except:
                        normal+='\n'
        else:
            if not multiCmtEndp.search(s):
                try:
                    if line[0]=='+':
                        contbtwCmt+=line[1:]+'\n'
                except:
                    contbtwCmt+='\n'
            else:
                print(normal,end="")
                print(contbtwCmt,end="")
                normal=''
                contbtwCmt=''
                multiCmtStart=False
                multiCmtEnd=True

    if normal or contbtwCmt:
        print(normal,end="")
        print(contbtwCmt+'*/',end="")


#we only extract the modi java code(new added + modi) from the patch file
def get_modi_javaCode(patch_fin):
    try:
        diffFlag=0
        indexFlag=0
        linesFlag=0
        laterVer=''

        for line in patch_fin.readlines():
            try:
                #line=line.strip('\n')
                fromp=re.compile(r'^From ')
                javaDiffp=re.compile(r'^diff.*.java')
                allDiffp=re.compile(r'^diff')
                indexp=re.compile(r'^index ')
                linesp=re.compile(r'^@@ -[0-9]+,[0-9]+ \+[0-9]+,[0-9]+ @@')
                chgLinep=re.compile(r'^[ +]')

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
                    if laterVer:
                        print(laterVer,end="")
                        cmtMakeup(laterVer)
                        return
                        laterVer=''
                    continue

                if diffFlag and indexFlag and linesFlag:
                    if chgLinep.match(line):
                        laterVer+=line
            except:
                traceback.print_exc()
        if laterVer:
            #print(laterVer,end="")
            cmtMakeup(laterVer)
    except:
        traceback.print_exc()


if __name__ == '__main__':
    try:
        patch_fin=sys.argv[1]
        get_modi_javaCode(file(patch_fin))
    except:
        traceback.print_exc()

