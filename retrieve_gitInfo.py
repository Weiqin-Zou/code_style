# -*- encoding:utf-8 -*-
import io
import sys
import traceback
reload(sys)
sys.setdefaultencoding('utf-8')

from pymongo import *

def get_gitInfo(db,repo_fout=None,pr_fout=None):
    try:
        if not repo_fout:
            repo_fout=file("repo.res",'a')

        '''print repo header'''
        items=["repoName","javaRatio","closedPR","closedIssue","mergedPR",\
                "outsider","insider","contributor"]
        header=items[0]
        for i in items[1:]:
            header=header+","+i
        repo_fout.write(header+'\n')


        '''print bug body and history body using mongodb 's bug collection'''
        for bug in db.bug.find({}):
            try:
                '''print bug body'''
                bbody=bug[items[0]]
                for i in items[1:]:
                    bbody=bbody+","+bug[i]
                rpt_fout.write(bbody+'\n')
            except:
                traceback.print_exc()
                continue
    except:
        traceback.print_exc()

if __name__ == '__main__':
    try:
        client=MongoClient('XXX',27017)
        db=client.Experiment
        a=db.repocondition.find({}).limit()
        print a
        '''return 0
        repo_fout=sys.argv[1]
        pr_fout=sys.argv[2]
        get_rptHistinfo(db,file(rpt_fout,'a'))'''
        client.close()
    except:
        traceback.print_exc()

