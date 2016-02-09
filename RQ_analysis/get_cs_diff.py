import sys
import os
from numpy import *

#pr21 and cb21 are both vectors which contains a pr's 21 metrics of patch and cb
def get_sameDiff(pr21,cb21):

    mCnt=len(pr21)
    #pr=[]
    #cb=[]
    for i in range(0,mCnt):
        if pr21[i] == 'NA' and cb21[i] == 'NA':
            pr21[i]=cb21[i]=0
        else:
            if pr21[i] == 'NA':
                pr21[i]=cb21[i]
            if cb21[i] == 'NA':
                cb21[i]=pr21[i]
    cosDist=dot(pr21,cb21)/(linalg.norm(pr21)*linalg.norm(cb21))
    return cosDist
def get_rmDiff(pr21,cb21):

    mCnt=len(pr21)
    pr=[]
    cb=[]
    for i in range(0,mCnt):
        if pr21[i] != 'NA' and cb21[i] != 'NA':
            pr.append(float(pr21[i]))
            cb.append(float(cb21[i]))

    cosDist=dot(pr21,cb21)/(linalg.norm(pr21)*linalg.norm(cb21))
    return cosDist

def get_cs_diff(cs21_fin):
    cnt=0;
    for line in cs21_fin.xreadlines():
        cnt+=1
        metric=line.strip('\n').split(',')
        if cnt != 1:
            (id,fn) = (metric[0],metric[1])
            pr21=metric[23:]
            cb21=metric[2:23]
            sameDiff=get_sameDiff(pr21,cb21)
            rmDiff=get_rmDiff(pr21,cb21)
            print fn,id,sameDiff,rmDiff
            break
        #since cs21 file has a header line, we should skip this line
        else:
            continue

if __name__ == '__main__':
    cs21_fin=sys.argv[1]
    get_cs_diff(file(cs21_fin,'r'))
