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

        getCaseUsage(file("noCmtFile","r"))
        countBlankWithinLine(file("noCmtFile","r"))
        moreThan2Stats(file("noCmtFile","r"))
        assignBlank(file("noCmtFile",'r'))
        complexCut(file("noCmtFile",'r'))


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
