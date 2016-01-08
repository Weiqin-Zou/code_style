# -*- encoding:utf-8 -*-
import io
import sys
import traceback
import re

def chgLineNum(patch_commit_fin,chgLineNum_fout,patchOrCommit):
    try:
        '''we define that if the value of patchOrCommit is 0, then
        we record the fix commit's file changed info, i.e. the a/XXX version.
        else, if the value is 1. then record merged PR's file changed info,
        i.e., the b/XXX version'''
        if patchOrCommit==0:


        diffflag=0
        indexflag=0
        filechgInfo={}
        for line in patch_commit_fin.readlines():
            try:
                diffp=re.compile(r'^diff ')
                indexp=re.compile(r'^index ')
                linesp=re.compile(r'@@ -[0-9]+,[0-9]+ \+[0-9]+,[0-9]+ @@')

                if diffp.match(line):
                    diffflag=1
                    filecngInfo["filepath"]=line.split(' ')[4][1:]

                if indexp.match(line):
                    indexflag=1
                    filecngInfo["fileindex"]=line.split(' ')[4][1:]


                if bug_id == 'bug_id':
                    continue
                d=re.split(r'\W+',desc)
                dlen=str(len(filter(lambda(x):x!='',d)))
                lf.write(bug_id+','+dlen+'\n')
            except:
                traceback.print_exc()
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

