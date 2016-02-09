import sys
import os
from numpy import *

#pr21 and cb21 are both vectors which contains a pr's 21 metrics of patch and cb
def get_sameDiff(pr21,cb21):

    mCnt=len(pr21)
    pr=[]
    cb=[]
    p=0
    c=0
    for i in range(0,mCnt):
        if pr21[i] == 'NA' and cb21[i] == 'NA':
            p=c=0
        else:
            if pr21[i] == 'NA':
                p=c=cb21[i]
            elif cb21[i] == 'NA':
                c=p=pr21[i]
            else:
                p=pr21[i]
                c=cb21[i]
        pr.append(float(p))
        cb.append(float(c))
    cosDist=dot(pr,cb)/(linalg.norm(pr)*linalg.norm(cb))
    return cosDist

def get_rmDiff(pr21,cb21):

    mCnt=len(pr21)
    pr=[]
    cb=[]
    for i in range(0,mCnt):
        if pr21[i] != 'NA' and cb21[i] != 'NA':
            pr.append(float(pr21[i]))
            cb.append(float(cb21[i]))

    cosDist=dot(pr,cb)/(linalg.norm(pr)*linalg.norm(cb))
    return cosDist

def get_cs_diff(cs21_fin,csdiff_fout):
    cnt=0;
    for line in cs21_fin.xreadlines():
        try:
            cnt+=1
            metric=line.strip('\n').split(',')
            if cnt != 1:
                (id,fn) = (metric[0],metric[1])
                pr21=metric[23:]
                cb21=metric[2:23]
                sameDiff=get_sameDiff(pr21,cb21)
                rmDiff=get_rmDiff(pr21,cb21)
                print>>csdiff_fout,"%s,%s,%s,%s" % (fn,id,sameDiff,rmDiff)

            #since cs21 file has a header line, we should skip this line
            else:
                head="fn,id,sameDiff,rmDiff"
                print>>csdiff_fout,head
        except:
            traceback.print_exc()

if __name__ == '__main__':
    cs21_fin=sys.argv[1]
    csdiff=sys.argv[2]
    get_cs_diff(file(cs21_fin,'r'),file(csdiff,'w'))
