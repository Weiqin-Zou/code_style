import sys
import os
import traceback

def get_onlyOneMetric_diff(cs_fin):
    cnt=0;
    for line in cs_fin.xreadlines():
        try:
            cnt+=1
            metric=line.strip('\n').split(',')
            if cnt != 1:
                (id,fn) = (metric[0],metric[1])
                cb=metric[2]
                pr=metric[3]
                if cb!="NA" and pr!="NA":
                    sameDiff=rmDiff=abs(float(cb)-float(pr))
                if cb=="NA" or pr=="NA":
                    sameDiff=0
                    rmDiff="NA"
                print "%s,%s,%s,%s" % (fn,id,sameDiff,rmDiff)

            #since cs21 file has a header line, we should skip this line
            else:
                head="fn,id,sameDiff,rmDiff"
                print head
        except:
            traceback.print_exc()

if __name__ == '__main__':
    cs_fin=sys.argv[1]
    get_onlyOneMetric_diff(file(cs_fin,'r'))
