import os
import re
import io
import sys
import traceback
import re

S_INIT              = 0;
S_SLASH             = 1;
S_BLOCK_COMMENT     = 2;
S_BLOCK_COMMENT_DOT = 3;
S_LINE_COMMENT      = 4;
S_STR               = 5;
S_STR_ESCAPE        = 6;

def trim_file(path,tmpFile):

    fp_src = open(path);
    fp_dst = open(tmpFile, 'w');
    state = S_INIT;
    for line in fp_src.readlines():
        for c in line:
            if state == S_INIT:
                if c == '/':
                    state = S_SLASH;
                elif c == '"':
                    state = S_STR;
                    fp_dst.write(c);
                else:
                    fp_dst.write(c);
            elif state == S_SLASH:
                if c == '*':
                    state = S_BLOCK_COMMENT;
                elif c == '/':
                    state = S_LINE_COMMENT;
                else:
                    fp_dst.write('/');
                    fp_dst.write(c);
            elif state == S_BLOCK_COMMENT:
                if c == '*':
                    state = S_BLOCK_COMMENT_DOT;
            elif state == S_BLOCK_COMMENT_DOT:
                if c == '/':
                     state = S_INIT;
                else:
                     state = S_BLOCK_COMMENT;
            elif state == S_LINE_COMMENT:
                if c == '\n':
                    state = S_INIT;
                    fp_dst.write(c);
            elif state == S_STR:
                if c == '\\':
                    state = S_STR_ESCAPE;
                elif c == '"':
                    state = S_INIT;
                fp_dst.write(c);
            elif state == S_STR_ESCAPE:
                state = S_STR;
                fp_dst.write(c);
    fp_src.close();
    fp_dst.close();

def stringMatch(codefile):
    strp=re.compile(r"\".*?\"")
    coma=re.compile(r";")
    lineCnt=0
    comaCnt=0
    for line in codefile.xreadlines():
        line=line.strip("\n")
        s=re.sub(strp,'',line)
        if coma.search(s):
            lenM=len(coma.findall(s))
            if lenM != 1:
                lineCnt+=1
                comaCnt+=lenM
    print "lineCnt:",lineCnt,"comaCnt:",comaCnt

if __name__ == '__main__':
    try:
        codeFile = sys.argv[1]
        tmpFile = sys.argv[2]
        trim_file(codeFile,tmpFile)
        stringMatch(file(tmpFile,'r'))
    except:
        traceback.print_exc()
