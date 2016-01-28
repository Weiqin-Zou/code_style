# -*- encoding:utf-8 -*-
import io
import sys
import traceback
reload(sys)
sys.setdefaultencoding('utf-8')
import os
import json
from pymongo import *

def get_ommision_list(prAll_fin,gotPR_fin,ommit_cldPR_fout):
    gotpr={}
    for gpr in gotPR_fin.xreadlines():
        gotpr[gpr.strip("\n")]=1

    for apr in prAll_fin.xreadlines():
        apr=apr.strip("\n")
        if apr not in gotpr:
            print>>ommit_cldPR_fout,apr

def get_ommision_closedPR(db,ommission_cldPR_fin,ommit_cldPR_fout,clientAccount_fin):
    ommit={}
    for opr in ommission_cldPR_fin.xreadlines():
        try:
            opr=opr.strip("\n")
            fn,prID=opr.split(",")
            if fn not in ommit:
                ommit[fn]=[]
            ommit[fn].append(prID)
        except:
            traceback.print_exc()

    client=[]
    for account in clientAccount_fin.xreadlines():
        try:
            client.append(account.strip("\n"))
        except:
            traceback.print_exc()

    '''the following code is used to find the created time for a closed PR
       and the first commit sha for a merged pr
       for the unmerged closed pr, we try to use the created time to calculate
       the loc of the code base. while for merged pr, we use the first commits sha
       to calculate the loc of the code base. for specific, the parent of the first commit
    '''
    failedCnt=0
    cnt=0
    clientNum=len(client)

    for fn in ommit:
        for id in ommit[fn]:
            try:
                for pr in db.pulls.find({"fn":str(fn),"number":int(id)}):
                    createdTime=pr["created_at"]
                    firstCommit=""
                    mergeFlag="unmerged"
                    if pr["merged"]:
                        mergeFlag="merged"
                        cnt+=1
                        '''the github data access has a limitation with 5000 acess times perhour
                           with a specific account, so here we change within several account to
                           access the github data,i.e.change the client Account
                        '''
                        clientAccount=client[cnt%clientNum]
                        if os.path.exists("commits"):
                            os.system("rm commits")
                        try:
                            cmitUrl="curl "+pr["commits_url"]+"\?" +clientAccount + " -o commits"
                            if not os.system(cmitUrl):
                                cmts=''
                                cmtsFile=file("commits","r")
                                for line in cmtsFile.readlines():
                                    cmts=cmts+line.strip('\n')
                                firstCommit=json.loads(cmts)[0]["sha"]
                        except:
                            traceback.print_exc()
                            print >>file("curlFailedPR.list","a"), pr["number"],pr["fn"],cmitUrl
                            failedCnt+=1

                    print>>ommit_cldPR_fout, "%s,%s,%s,%s,%s" % (pr["fn"],pr["number"] \
                            ,mergeFlag,firstCommit,createdTime)
            except:
                traceback.print_exc()
    print>>file("curlFailedPR.list","a"), "total failedPRCnt:",failedCnt

if __name__ == '__main__':
    try:
        ip=sys.argv[1]
        client=MongoClient(ip,27017)
        db=client.Experiment

        prAll_fin=sys.argv[2]
        gotPR_fin=sys.argv[3]
        ommit_cldPR=sys.argv[4]
        ommit_cldPR_fout=sys.argv[5]
        clientAccount=sys.argv[6]
        get_ommision_list(file(prAll_fin,"r"),file(gotPR_fin,"r"),file(ommit_cldPR,"w"))
        get_ommision_closedPR(db, file(ommit_cldPR,"r") \
                ,file(ommit_cldPR_fout,'w'),file(clientAccount,"r"))

        client.close()
    except:
        traceback.print_exc()
