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
    inLineCmtp=re.compile(r'^\s*\w+(//|/\*.*\*/|/\*\*.*\*/)')
    oneLineCmtp=re.compile(r'^\s*//|^\s*/\*.*\*/\s*$|^\s*/\*\*.*\*/\s*$')
    multiCmtEndp=re.compile(r'.*\*/\s*$')
    for line in fp_src.readlines():
        printEnter=True
        blockEnd=False
        if oneLineCmtp.search(line):
            continue
        elif inLineCmtp.search(line):
            printEnter=True
        elif multiCmtEndp.search(line):
            printEnter=False
        for c in line:
            if state == S_INIT:
                if c == '/':
                    state = S_SLASH;
                elif c == '"':
                    state = S_STR;
                    fp_dst.write(c);
                elif c == '\n':
                    if printEnter:
                        fp_dst.write(c);
                    blockEnd=False
                else:
                    if blockEnd:
                        if printEnter:
                            fp_dst.write(c)
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
                     blockEnd = True
                else:
                     state = S_BLOCK_COMMENT;
            elif state == S_LINE_COMMENT:
                if c == '\n':
                    state = S_INIT;
                    if printEnter:
                        fp_dst.write(c)

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


if __name__ == '__main__':
    try:
        codeFile = sys.argv[1]
        tmpFile = sys.argv[2]
        trim_file(codeFile,tmpFile)
    except:
        traceback.print_exc()
