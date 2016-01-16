# -*- encoding:utf-8 -*-
import io
import sys
import traceback
reload(sys)
sys.setdefaultencoding('utf-8')

from pymongo import *

def get_fullRepoList(db,repoList_fout=None):
    try:
        if not repoList_fout:
            repoList_fout=file("fullrepoList.res",'w')

        '''print repo body '''
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
                    newRepo.append(compRepo)
            except:
                traceback.print_exc()

        for pr in db.Experiment.pulls.find{}:
            try:
                repoName=pr["fn"]
                if repoName in newRepo:
                    try:

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

