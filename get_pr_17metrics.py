import traceback
import os
import sys
from  pymongo import *

def get_prMetrics(db,pr_fout=None):
    try:
        if not pr_fout:
            pr_fout=file("pr_17metrics.res",'a')

        '''print pr header'''
        items=[]
        header=""
        for pr in db.result.find({}):
            try:
                del pr["_id"]
                items=pr.keys()
                for key in items:
                    if not header:
                        header=key
                    else:
                        header=header+","+key
                pr_fout.write(header+'\n')
                break
            except:
                traceback.print_exc()

        '''print pr body '''
        for pr in db.result.find({}):
            try:
                rbody=str(pr[items[0]])
                for i in items[1:]:
                    rbody=rbody+","+str(pr[i])
                pr_fout.write(rbody+'\n')
            except:
                traceback.print_exc()
                continue
    except:
        traceback.print_exc()


if __name__ == '__main__':
    try:
        ip=sys.argv[1]
        client=MongoClient(ip,27017)
        db=client.Experiment
        pr_fout=sys.argv[2]
        get_prMetrics(db,file(pr_fout,'w'))
        client.close()
    except:
        traceback.print_exc()

