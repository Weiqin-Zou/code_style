from final_21metrics import *

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
