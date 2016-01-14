#!/bin/bash

#example:./except_handle.sh FWM_event_res . > log
#正常的filter_hist.sh跑完后，可能还有一些特殊情况无法处理，这个时候就用这个脚本再跑一下。
#如果还有无法处理的，就自己去看那log文件，人工补充进去吧。不想再搞了。

abnorDir=$1 #the dir of XXX.abnormal.log files
errDir=$2 #the dir of the err.log file

function abnormalHandle(){

    for abnor in ${abnorDir}/*.abnormal.log
    do
        python filter_FWM_event.py ${abnor} abnor.res abnor.err
    done
}
abnormalHandle 

function errLogHandle(){
    
    grep -E "ForkEvent|WatchEvent|MemberEvent" ${errDir}/err.log > errFWM
    sed -i 's/}{/}\n{/g' errFWM
    sed -i '/^$/d' errFWM
    python filter_FWM_event.py errFWM errFile.res errFile.err
}
errLogHandle

##在这2种异常处理后，如果还有异常点，那就自己人工再看下吧，就不写代码搞了。
##另外，除了abnormal和err 这2种file外，这里还有centos无法解压的json.gz文件。
##对于这种，自己在121那台机子上再自己弄下吧。
##github的数据接口中途变那么多就是坑啊
