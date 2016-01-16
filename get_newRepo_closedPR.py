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

def get_newRepo_closedPR(db,finished_list_fin,full_list_fin,newRepo_closedPR_fout):
    try:
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

        for pr in db.pulls.find({}):
            try:
                repoName=pr["fn"]
                if repoName in newRepo:
                    try:
                        if pr["state"]=="closed":
                            createdTime=pr["created_at"]
                            firstCommit=None
                            if pr["merged"]:
                                if os.path.exists("commits"):
                                    os.system("rm commits")
                                try:
                                    if not os.system("wget "+pr["commits_url"]):
                                        cmts=''
                                        for line in file("commits",'r').readlines():
                                            cmts=cmts+line.strip('\n')
                                        firstCommit=json.loads(cmts)[0]["sha"]
                                        print pr["fn"],pr["number"],firstCommit
                                        return(0)
                                except:
                                    traceback.print_exc()
                                    print >>"wgetFailedPR.list" % (pr["number"],pr["fn"])
                                    return
                    except:
                        traceback.print_exc()

            except:
                traceback.print_exc()

    except:
        traceback.print_exc()

if __name__ == '__main__':
    try:
        ip=sys.argv[1]
        client=MongoClient(ip,27017)
        db=client.Experiment
        finished_list_fin=sys.argv[2]
        full_list_fout=sys.argv[3]
        newRepo_closedPR_fout=sys.argv[4]

        get_fullRepoList(db,file(full_list_fout,'w'))
        get_newRepo_closedPR(db,file(finished_list_fin,'r'),file(full_list_fout,'r') \
                ,(newRepo_closedPR_fout,'w'))

        client.close()
    except:
        traceback.print_exc()

