# -*- encoding:utf-8 -*-
import io
import sys
import traceback
reload(sys)
sys.setdefaultencoding('utf-8')
import os
import json
from pymongo import *

def get_fullRepoList(db,repoList_fout=None):
    try:
        if not repoList_fout:
            repoList_fout=file("fullrepoList.res",'w')

        for repo in db.complete.find({}):
            try:
                fn=repo["full_name"]
                repoList_fout.write(fn+'\n')
            except:
                traceback.print_exc()
    except:
        traceback.print_exc()

def get_newRepo_closedPR(db,finished_list_fin,full_list_fin,newRepo_closedPR_fout,clientAccount):
    finished=[]
    newRepo=[]
    for repo in finished_list_fin.xreadlines():
        try:
            finished.append(repo.strip("\n"))
        except:
            traceback.print_exc()
    for compRepo in full_list_fin.xreadlines():
        try:
            if compRepo not in finished:
                newRepo.append(compRepo.strip("\n"))
        except:
            traceback.print_exc()

    cnt=1
    failedCnt=0
    for pr in db.pulls.find({}):
        try:
            repoName=pr["fn"]
            if repoName in newRepo:
                try:
                    if pr["state"]=="closed":
                        createdTime=pr["created_at"]
                        firstCommit=""
                        mergeFlag="unmerged"
                        if pr["merged"]:
                            mergeFlag="merged"
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

                            print>>newRepo_closedPR_fout, "%s,%s,%s,%s,%s" % (pr["fn"],pr["number"] \
                                    ,mergeFlag,firstCommit,createdTime)
                except:
                    traceback.print_exc()
            if cnt>=10:
                return
            cnt=cnt+1
        except:
            traceback.print_exc()
    print>>file("curlFailedPR.list","w"), "total failedPRCnt:",failedCnt

if __name__ == '__main__':
    try:
        ip=sys.argv[1]
        client=MongoClient(ip,27017)
        db=client.Experiment
        finished_list_fin=sys.argv[2]
        full_list_fout=sys.argv[3]
        newRepo_closedPR_fout=sys.argv[4]
        clientAccount=sys.argv[5]

        get_fullRepoList(db,file(full_list_fout,'w'))
        get_newRepo_closedPR(db,file(finished_list_fin,'r'),file(full_list_fout,'r') \
                ,file(newRepo_closedPR_fout,'w'),clientAccount)

        client.close()
    except:
        traceback.print_exc()
