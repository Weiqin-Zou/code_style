import os
import sys
import traceback
import re

#########################following metrics use both code and comments:
##blankLine,lineLength,commentRatio,cmtMethod,blankB4cmt,blankAfterCmt,cmtIndent
##1) blankLine
'''this function is to cal the blank lines number of
a whole of part of code file'''
def isBlankLine(str_line):
    blankp=re.compile(r'^\s*$')
    if blankp.match(str_line):
        return True
    else:
        return False

#the control function for all the metrics cal with both comment and code
def useCodeAndCmtMetrics(code_fin):
    lineCnt=0
    blankLineCnt=0
    for line in code_fin.xreadlines():
        try:
            lineCnt+=1
            if isBlankLine(line):
                blankLineCnt+=1
        except:
            traceback.print_exc()
    print lineCnt,blankLineCnt,blankLineCnt*1.0/lineCnt

#######################follwing metrics use only code:
##tabOrBlankIndent,bracketUse,braceMethod,singleBrace,complexCut,caseUse,
##blankPerLine,statsPerLine,assignBlank,
##1)tabOrBlankIndent
'''this function is to cal how much does tab or blank used to
as indentation in the code file,including code and comment indentation'''
def indentation(str_line):
    tab=0
    blank=0
    indentp=re.compile(r'^[\t| ]+')
    if not isBlankLine(str_line):
        if indentp.match(str_line):
            indent=indentp.findall(str_line)
            #has \t indentation
            if indent[0].find("\t") !=-1:
                tab=1
            #has " " indentation
            if indent[0].find(" ") !=-1:
                    blank=1
    return (tab,blank)

'''this function is used to cal how does someone use { of the {}, { in the same
   code line or in the next line?'''
def bracketUsage(str_line):
    withInp=re.compile(r'^.*\S+.*{')
    nextp=re.compile(r'^\s*{')
    withInLine=0
    nextLine=0
    if withInp.match(str_line):
        withInLine=1
    elif nextp.match(str_line):
        nextLine=1
    return(withInLine,nextLine)

'''this function is used to cal how does someone use case:[\n]XXX, XXX in the same
   code line or in the next line?'''
def caseUsage(str_line):
    withInp=re.compile(r'case +\w+\s*:\s*\S+')
    nextp=re.compile(r'case +\w+\s*:\s*$')
    withInLine=0
    nextLine=0
    if withInp.match(str_line):
        withInLine=1
    elif nextp.match(str_line):
        nextLine=1
    return(withInLine,nextLine)


def useOnlyCodeMetrics(code_fin):
####!!!!need to call the function to remove comments!!!don't forget that
    tabIndentCnt=0
    blankIndentCnt=0
    withInBracket=0
    nextLineBracket=0
    withInCase=0
    nextLineCase=0

    for line in code_fin.xreadlines():
        try:
            (tabIndent,blankIndent)=indentation(line)
            tabIndentCnt+=tabIndent
            blankIndentCnt+=blankIndent

            (within,nextLine)=bracketUsage(line)
            withInBracket+=within
            nextLineBracket+=nextLine

            (within,nextLine)=caseUsage(line)
            withInCase+=within
            nextLineCase+=nextLine

        except:
            traceback.print_exc()
    print tabIndentCnt,blankIndentCnt,tabIndentCnt*1.0/(tabIndentCnt+blankIndentCnt)
    print withInBracket,nextLineBracket
    print withInCase,nextLineCase


#def allMetrics(code_fin):

if __name__ == "__main__":
    code_fin=sys.argv[1]
    #useCodeAndCmtMetrics(file(code_fin,'r'))
    useOnlyCodeMetrics(file(code_fin,'r'))
