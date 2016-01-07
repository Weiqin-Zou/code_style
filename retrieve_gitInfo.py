# -*- encoding:utf-8 -*-
import io
import sys
import traceback
reload(sys)
sys.setdefaultencoding('utf-8')

from pymongo import *

def get_repoInfo(db,repo_fout=None):
    try:
        if not repo_fout:
            repo_fout=file("repo.res",'a')

        '''print repo header'''
        items=["fn","java","closepull","closeissue","mpr",\
                "outsider","insider","contributor"]
        header=items[0]
        for i in items[1:]:
            header=header+","+i
        repo_fout.write(header+'\n')


        '''print repo body '''
        for repo in db.repocondition.find({}):
            try:
                rbody=repo[items[0]]
                for i in items[1:]:
                    rbody=rbody+","+str(repo[i])
                repo_fout.write(rbody+'\n')
            except:
                traceback.print_exc()
                continue
    except:
        traceback.print_exc()

def get_prInfo(db,pr_fout=None):
    try:
        if not pr_fout:
            pr_fout=file("pr.res",'a')

        '''print pr header'''
        items=["fn","pr_number","patch_url","diff_url"]
        ''',\ "first_commit_sha","is_merged","created_at"]'''
        header=items[0]
        for i in items[1:]:
            header=header+","+i
        pr_fout.write(header+'\n')


        '''print pr body '''
        for pr in db.mergedpr.find({}):
            try:
                rbody=pr[items[0]]
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
        ip=sys.argv[3]
        client=MongoClient(ip,27017)
        db=client.Experiment
        repo_fout=sys.argv[1]
        pr_fout=sys.argv[2]
        get_repoInfo(db,file(repo_fout,'w'))
        get_prInfo(db,file(pr_fout,'w'))
        client.close()
    except:
        traceback.print_exc()

