# -*- encoding:utf-8 -*-
import io
import sys
import traceback
import re

#we only extract the modi java code(new added + modi) from the patch file
def get_modi_javaCode(patch_fin):
    try:
        chgLinePattern='^\+'
        diffFlag=0
        indexFlag=0
        linesFlag=0

        for line in patch_fin.readlines():
            try:
                line=line.strip('\n')
                javaDiffp=re.compile(r'^diff.*.java')
                allDiffp=re.compile(r'^diff')
                indexp=re.compile(r'^index ')
                linesp=re.compile(r'^@@ -[0-9]+,[0-9]+ \+[0-9]+,[0-9]+ @@')
                chgLinep=re.compile(chgLinePattern)

                if allDiffp.match(line):
                    indexFlag=0
                    linesFlag=0
                    diffFlag=0
                    if javaDiffp.match(line):
                        diffFlag=1
                    continue

                if diffFlag==0:
                    continue

                if indexp.match(line):
                    indexFlag=1
                    continue

                if linesp.match(line):
                    linesFlag=1
                    continue

                if diffFlag and indexFlag and linesFlag:
                    if chgLinep.match(line):
                        print line[1:]
            except:
                traceback.print_exc()
    except:
        traceback.print_exc()


if __name__ == '__main__':
    try:
        patch_fin=sys.argv[1]
        get_modi_javaCode(file(patch_fin))
    except:
        traceback.print_exc()

