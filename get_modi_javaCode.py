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
    print(code,end="\n")
    for line in code:
        s=re.sub(strp,'',line)
        if not multiCmtStart:
            if not multiCmtStartp.search(s):
                print("multiStart",end="\n")
                if multiCmtEndp.search(s):
                    '''a true */ without matched /*'''
                    if not re.compile(r'/\*').search(s):
                        if line[0]=='+':
                            normal='/*'+normal+line[1:]+'\n'
                        else:
                            if normal:
                                normal='/*'+normal+'*/\n'
                        if normal:
                            print(normal,end="")
                            #print(contbtwCmt,end="")
                            #multiCmtStart=False
                            normal=""
                            #contbtwCmt=""
                    else:
                        '''a false block end */'''
                        print(s,end="")
                        if line[0]=='+':
                            normal=normal+line[1:]+'\n'
                else:
                    try:
                        if line[0]=='+':
                            normal+=line[1:]+'\n'
                    except:
                        normal+='\n'
            #this line contains a multiCmt start
            else:
                if not doubleCmtp.search(s):#a true multi cmt begin
                    #print s
                    if line[0]=='+':
                        contbtwCmt+=line[1:]+'\n'
                    else:
                        contbtwCmt+='/*'
                    multiCmtStart=True
                    print("firstline"+s,end="\n")
                    print("begin cont",end="\n")
                    print(contbtwCmt,end="\n")
                    print("end of first line",end="\n")
                else:
                    try:
                        if line[0]=='+':
                            normal+=line[1:]+'\n'
                    except:
                        normal+='\n'
        ##########already has multiCmtStart
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
    if multiCmtStart:
        contbtwCmt+='*/'
        print("cont:",end="\n")
        print(contbtwCmt,end="\n")

#we only extract the modi java code(new added + modi) from the patch file
def get_modi_javaCode(patch_fin):
    try:
        diffFlag=0
        indexFlag=0
        linesFlag=0
        laterVer=''

        for line in patch_fin.readlines():
            try:
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
                        cmtMakeup(laterVer)
                        laterVer=''
                    continue

                if diffFlag and indexFlag and linesFlag:
                    if chgLinep.match(line):
                        laterVer+=line
            except:
                traceback.print_exc()
        if laterVer:
            cmtMakeup(laterVer)
    except:
        traceback.print_exc()


if __name__ == '__main__':
    try:
        patch_fin=sys.argv[1]
        get_modi_javaCode(file(patch_fin))
    except:
        traceback.print_exc()

