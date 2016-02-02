import os
import sys
import traceback
import re
###########match and search, check it for each metric !!!!!!!!!
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

def countBlankLine(code_fin):
    '''blank line cal'''
    lineCnt=0
    blankLineCnt=0
    for line in code_fin.xreadlines():
        try:
            #blank line count
            lineCnt+=1
            if isBlankLine(line):
                blankLineCnt+=1
        except:
            traceback.print_exc()
    print "total lines cnt:",lineCnt,"blank lines cnt:",blankLineCnt,blankLineCnt*1.0/lineCnt


'''this function is to cal the length of a string line stripped with blanks'''
def lineLen(str_line):
    '''we remove the such kinds of lines which only contains { or }'''
    rm=re.compile(r'^\s*[\{\}]*\s*$')
    if rm.match(str_line):
        return -1
    else:
        return len(str_line.strip())

def getLineLen(code_fin):
    '''line length cal'''
    totalLen=0
    lenCnt=0
    for line in code_fin.xreadlines():
        try:
            #line length count
            length=lineLen(line)
            if length != -1:
                totalLen+=length
                lenCnt+=1
        except:
            traceback.print_exc()
    print "lenCnt:",lenCnt,"totalLen:",totalLen


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

def getIndentUsage(code_fin):
####!!!!need to call the function to remove comments!!!don't forget that
    '''indentation use cal'''
    tabIndentCnt=0
    blankIndentCnt=0
    for line in code_fin.xreadlines():
        try:
            #cal indentation
            (tabIndent,blankIndent)=indentation(line)
            tabIndentCnt+=tabIndent
            blankIndentCnt+=blankIndent
        except:
            traceback.print_exc()
    print "tabCnt:",tabIndentCnt,"blankCnt:",\
            blankIndentCnt,tabIndentCnt*1.0/(tabIndentCnt+blankIndentCnt)


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

def getBracketUsage(code_fin):
####!!!!need to call the function to remove comments!!!don't forget that
    '''bracket use cal'''
    withInBracket=0
    nextLineBracket=0
    for line in code_fin.xreadlines():
        try:
            #cal bracketUsage
            (within,nextLine)=bracketUsage(line)
            withInBracket+=within
            nextLineBracket+=nextLine
        except:
            traceback.print_exc()
    print "withInBracket:",withInBracket,"nextLineBracket:",nextLineBracket

'''this function is used to cal how does someone use case:[\n]XXX, XXX in the same
   code line or in the next line?'''
def caseUsage(str_line):
    withInp=re.compile(r'case +\w+\s*:\s*\S+')
    nextp=re.compile(r'case +\w+\s*:\s*$')
    withInLine=0
    nextLine=0
    if withInp.search(str_line):
        withInLine=1
    elif nextp.search(str_line):
        nextLine=1
    return(withInLine,nextLine)

def getCaseUsage(code_fin):
    '''case use cal'''
    withInCase=0
    nextLineCase=0
    for line in code_fin.xreadlines():
        try:
            #cal caseUsage
            (within,nextLine)=caseUsage(line)
            withInCase+=within
            nextLineCase+=nextLine
        except:
            traceback.print_exc()
    print "withInCase:",withInCase,"nextLineCase:",nextLineCase

'''this function is used to cal how many blanks within a code line'''
def blankWithinLine(str_line):
    if not isBlankLine(str_line):
        return str_line.strip().count(" ")
    else:
        return -1
def countBlankWithinLine(code_fin):
    '''blanks within code line cal'''
    blankWithin=0
    blankWithinCnt=0
    for line in code_fin.xreadlines():
        try:
            #cal blanks within code lines
            blanks=blankWithinLine(line)
            if blanks != -1:
                blankWithin+=blanks
                blankWithinCnt+=1
        except:
            traceback.print_exc()
    print "blanksWithinLine:",blankWithin,"lines:",blankWithinCnt

'''for statsPerLine, we consider consider lines which states more than 2 statements.
we output the lines num and the total statements stated by these lines
we use ";" to identify the statements. since string and // comments will most likely
increase the false indentification of states. we first remove them before calculation'''
def moreThan2Stats(code_fin):
    strp=re.compile(r"\".*?\"")
    coma=re.compile(r";")
    cmt=re.compile(r"//.*")
    lineCnt=0
    comaCnt=0
    for line in code_fin.xreadlines():
        line=line.strip("\n")
        s=re.sub(strp,'',line)
        s=re.sub(cmt,'',s)
        if coma.search(s):
            lenM=len(coma.findall(s))
            if lenM != 1:
                lineCnt+=1
                comaCnt+=lenM
    print "lineCnt:",lineCnt,"comaCnt:",comaCnt

def assignBlank(code_fin):
    assignp=re.compile(r"(\s|\w)=(\s|\w)")
    assignBlankp=re.compile(r"\s=\s")
    calp=re.compile(r"[\+\-\*\/\%\&\|\^]=")
    calBlankp=re.compile(r"\s[\+\-\*\/\%\&\|\^]=\s")
    bitp=re.compile(r"(<<|>>|>>>)=")
    bitBlankp=re.compile(r" (<<|>>|>>>)= ")
    totalAssign=0
    assignBlank=0
    for line in code_fin.xreadlines():
        if calp.search(line):
            totalAssign+=len(calp.findall(line))
            assignBlank+=len(calBlankp.findall(line))
        if bitp.search(line):
            totalAssign+=len(bitp.findall(line))
            assignBlank+=len(bitBlankp.findall(line))
        if assignp.search(line):
            totalAssign+=len(assignp.findall(line))
            assignBlank+=len(assignBlankp.findall(line))
    print "totall assign:",totalAssign,"assign with blank:",assignBlank

'''whether the complex stat(len>80) cut in multi lines'''
def complexCut(code_fin):
    cutp=re.compile(r'[){;]\s*$')
    cutCnt=0
    complexCnt=0
    for line in code_fin.xreadlines():
        if not isBlankLine(line):
            line=line.rstrip()
            lineLen=len(line)
            if lineLen>80:
                complexCnt+=1
                if not cutp.search(line):
                    cutCnt+=1
    print "complexCnt:",complexCnt,"cutCnt:",cutCnt

