from final_22metrics import *

def useOnlyCodeMetrics(code_fin):
####!!!!need to call the function to remove comments!!!don't forget that
    #!!!!!!!!!!!!!removeCmt(code_fin,cmtRemove_fout)
    getIndentUsage(file(code_fin,"r"))
    getBraceUsage(file(code_fin,"r"))
    getCaseUsage(file(code_fin,"r"))
    countBlankWithinLine(file(code_fin,"r"))
    moreThan2Stats(file(code_fin,"r"))
    assignBlank(file(code_fin,'r'))
    complexCut(file(code_fin,'r'))

def useCodeAndCmtMetrics(code_fin):
####!!!!need to call the function to remove comments!!!don't forget that
    countBlankLine(file(code_fin,"r"))
    getLineLen(file(code_fin,"r"))

if __name__ == "__main__":
    code_fin=sys.argv[1]
    #useCodeAndCmtMetrics(code_fin)
    #useOnlyCodeMetrics(code_fin)
    getBracketUse(file(code_fin,'r'))
    getOpsNum(file(code_fin,'r'))
