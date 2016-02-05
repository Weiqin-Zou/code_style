from final_21metrics import *
from trim_cmt.py import *

def useOnlyCodeMetrics(code_fin):
    for code_fin in file(codeFileList_fin,'r').xreadlines():
        code_fin=code_fin.strip('\n')
        trim_cmt(code_fin,"noCmtFile")

        '''tab or blank indent'''
        tab2=0;blank2=0;
        (tabCnt,blankCnt)=getIndentUsage(file("noCmtFile","r"))
        tab2+=tabCnt;blank2+=blankCnt

        '''if a stats has more than 3 operators, does it use ()?'''
        cnt3=0;bracketCnt3=0;
        (cnt,bracketCnt)=getBracketUse(file("noCmtFile","r"))
        cnt3+=cnt;bracketCnt3+=bracketCnt;

        ''' how does someone use { of the {},
        { in the same code line or in the next line?
        '''
        withIn4=0;nextLine4=0
        (withInBrace,nextLineBrace)=getBraceUsage(file("noCmtFile","r"))
        withIn4+=withInBrace;nextLine4+=nextLineBrace

        '''whether the complex stat(len>80) cut in multi lines'''
        compext5=0;cut5=0;
        (complexCnt,cutCnt)=complexCut(file("noCmtFile",'r'))
        complex5+=complexCnt;cut5+=cutCnt

        '''how does someone use case:[\n]XXX,
        XXX in the same code line or in the next line?
        '''
        withIn6=0;nextLine6=0;
        (withInCase,nextLineCase)=getCaseUsage(file("noCmtFile","r"))
        withIn6+=withInCase;nextLine6+=nextLineCase;

        '''how many blanks within a code line'''
        line8=0;blank8=0;
        (blankLine,blanks)=countBlankWithinLine(file("noCmtFile","r"))
        line8+=blankLine;blank8+=blanks;

        '''only consider lines which states more than 2 statements(;ended).
           we output the lines num and the total statements stated by these lines
        '''
        line9=0;stats9=0;
        (lineCnt,statsCnt)=moreThan2Stats(file("noCmtFile","r"))
        line9+=lineCnt;stats9+=statsCnt;

        '''for assign stats, do it use blanks on both sides of the ='''
        assign10=0;blank10=0
        (assignCnt,useBlankCnt)=assignBlank(file("noCmtFile",'r'))
        assign10+=assignCnt;blank10+=useBlankCnt;

        '''how many ops used in a stat'''
        line11=0;ops11=0;
        (statCnt,opsCnt)=getOpsNum(file("noCmtFile",'r'))
        line11+=statCnt;ops11+=opsCnt;


def use_oriModi_metrics(codeFileList_fin):
    oriRes={}
    line1=0
    blankLine1=0

    line7=0
    len7=0
    for code_fin in file(codeFileList_fin,'r').xreadlines():
        code_fin=code_fin.strip('\n')
        (lineCnt,blankLineCnt)=countBlankLine(file(code_fin,"r"))
        line1+=lineCnt
        blankLine1+=blankLineCnt

        (lineCnt,totalLen)=getLineLen(file(code_fin,"r"))
        line7+=lineCnt
        len7+=totalLen

    if line1==0:
        oriRes["blankLineRatio"]="#"
    else:
        oriRes["blankLineRatio"]=blankLine1*1.0/line1
    if line7==0:
        oriRes["lineLen"]="#"
    else:
        oriRes["lineLen"]=len7*1.0/line7
    print "%s,%s" % (oriRes["blankLineRatio"],oriRes["lineLen"])


if __name__ == "__main__":
    codeFileList_fin=sys.argv[1]
    use_oriModi_metrics(codeFileList_fin)
