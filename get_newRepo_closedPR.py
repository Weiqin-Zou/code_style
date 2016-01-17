# -*- encoding:utf-8 -*-
import io
import sys
import traceback
reload(sys)
sys.setdefaultencoding('utf-8')
import os
import json
from pymongo import *

'''we use the complete collection to find all the download complete repos'''
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

'''we have a finished repo list, now we have a new full repo list
   what we should do is to find out the new repos which have not been
   analyzed by the LOC program
'''
def get_newRepoList(finished_list_fin,full_list_fin,newRepo_list_fout):
    finished=[]
    for repo in finished_list_fin.xreadlines():
        try:
            finished.append(repo.strip("\n"))
        except:
            traceback.print_exc()

    for compRepo in full_list_fin.xreadlines():
        try:
            compRepo=compRepo.strip("\n")
            if compRepo not in finished:
                print>>newRepo_list_fout,compRepo
        except:
            traceback.print_exc()

def get_newRepo_closedPR(db,newRepo_list_fin,newRepo_closedPR_fout,clientAccount):
    newRepo=[]
    for repo in newRepo_list_fin.xreadlines():
        try:
            newRepo.append(repo.strip("\n"))
        except:
            traceback.print_exc()

    '''the following code is used to find the created time for a closed PR
       and the first commit sha for a merged pr
       for the unmerged closed pr, we try to use the created time to calculate
       the loc of the code base. while for merged pr, we use the first commits sha
       to calculate the loc of the code base. for specific, the parent of the first commit
    '''
    cnt=1
    failedCnt=0
    for pr in db.pulls.find({}):
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
        if cnt>=2:
            return
        cnt=cnt+1
    print>>file("curlFailedPR.list","w"), "total failedPRCnt:",failedCnt

if __name__ == '__main__':
    try:
        ip=sys.argv[1]
        client=MongoClient(ip,27017)
        db=client.Experiment
        finished_list_fin=sys.argv[2]
        full_list_fout=sys.argv[3]
        new_list_fout=sys.argv[4]
        newRepo_closedPR_fout=sys.argv[5]
        clientAccount=sys.argv[6]

        get_fullRepoList(db,file(full_list_fout,'w'))
        get_newRepoList(file(finished_list_fin,'r'), \
                file(full_list_fout,'r'),file(new_list_fout,"w"))
        get_newRepo_closedPR(db, file(new_list_fout,"r") \
                ,file(newRepo_closedPR_fout,'w'),clientAccount)

        client.close()
    except:
        traceback.print_exc()
