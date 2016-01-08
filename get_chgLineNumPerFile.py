# -*- encoding:utf-8 -*-
import io
import sys
import traceback
import re

#def chgLineNum(patch_commit_fin,chgLineNum_fout,patchOrCommit):
def chgLineNum(patch_commit_fin,patchOrCommit):
    try:
        '''we define that if the value of patchOrCommit is 0, then
        we record the fix commit's file changed info, i.e. the a/XXX version.
        else, if the value is 1. then record merged PR's file changed info,
        i.e., the b/XXX version'''
        if patchOrCommit==0:
            fileVersion=2
            fileIdx=1
            startLineIdx=1
            chgLinePattern='^-'
        elif patchOrCommit==1:
            fileVersion=3
            fileIdx=3
            startLineIdx=3
            chgLinePattern='^\+'
        else:
            return

        diffFlag=0
        indexFlag=0
        linesFlag=0
        cnt=-1
        chgLineNum=[]
        fileChgInfo={}
        startLineNum=0
        for line in patch_commit_fin.readlines():
            try:
                diffp=re.compile(r'^diff ')
                indexp=re.compile(r'^index ')
                linesp=re.compile(r'^@@ -[0-9]+,[0-9]+ \+[0-9]+,[0-9]+ @@')
                chgLinep=re.compile(chgLinePattern)

                if diffp.match(line):
                    diffFlag=1
                    indexFlag=0
                    linesFlag=0
                    if fileChgInfo:
                        fileChgInfo['chgLinesNum']=chgLineNum
                        print fileChgInfo
                        fileChgInfo={}
                        chgLineNum=[]
                        cnt=-1
                    fileChgInfo["filepath"]=line.split(' ')[fileVersion][1:]
                if diffFlag==0:
                    continue

                if indexp.match(line):
                    indexFlag=1
                    fileChgInfo["fileindex"]=re.split(r'[ .]',line)[fileIdx]
                    continue

                if linesp.match(line):
                    linesFlag=1
                    startLineNum=int(re.split(r'[ ,]',line)[startLineIdx][1:])
                    continue

                if diffFlag and indexFlag and linesFlag:
                        cnt+=1

                if chgLinep.match(line):
                    lineNum=startLineNum+cnt
                    chgLineNum.append(lineNum)
            except:
                traceback.print_exc()
    except:
        traceback.print_exc()


if __name__ == '__main__':
    try:
        patchOrCommit_fin=sys.argv[1]
        #fileChgInfo_fout=sys.argv[2]
        patchOrCommitType=int(sys.argv[2])
        #chgLineNum(file(patchOrCommit_fin),file(fileChgInfo_fout),patchOrCommitType)
        chgLineNum(file(patchOrCommit_fin),patchOrCommitType)
    except:
        traceback.print_exc()

