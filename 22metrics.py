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

'''this function is to cal the length of a string line stripped with blanks'''
def getLineLen(str_line):
    '''we remove the such kinds of lines which only contains { or }'''
    rm=re.compile(r'^\s*[\{\}]*\s*$')
    if rm.match(str_line):
        return -1
    else:
        return len(str_line.strip())

#the control function for all the metrics cal with both comment and code
def useCodeAndCmtMetrics(code_fin):
    '''blank line cal'''
    lineCnt=0
    blankLineCnt=0

    '''line length cal'''
    totalLen=0
    lenCnt=0
    for line in code_fin.xreadlines():
        try:
            #blank line count
            lineCnt+=1
            if isBlankLine(line):
                blankLineCnt+=1

            #line length count
            length=getLineLen(line)
            if length != -1:
                totalLen+=length
                lenCnt+=1
        except:
            traceback.print_exc()
    print lineCnt,blankLineCnt,blankLineCnt*1.0/lineCnt
    print lenCnt,totalLen

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

'''this function is used to cal how many blanks within a code line'''
def blankWithinLine(str_line):
    if not isBlankLine(str_line):
        return str_line.strip().count(" ")
    else:
        return -1

'''for statsPerLine, we consider consider lines which states more than 2 statements.
we output the lines num and the total statements stated by these lines
we use ";" to identify the statements.'''
def moreThan2Stats(str_line):
    strp=re.compile(r"\".*?\"")
    coma=re.compile(r";")
    str_line=str_line.strip("\n")
    s=re.sub(strp,'',str_line)
    if coma.search(s):
        lenM=len(coma.findall(s))
        if lenM > 1:
            lineCnt=1
            comaCnt=lenM
            return (lineCnt,comaCnt)
    return(-1,-1)
