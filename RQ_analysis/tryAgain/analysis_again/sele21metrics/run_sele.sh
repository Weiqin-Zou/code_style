#!/bin/bash

cs21=$1 #the ori data set which contains fn+id+21 pr + 21 cb metrics. 
pr18=$2 #the data set contains 18 metrics of pr

function rm5diffMetrics(){
cut -f1-2,4,6-12,14-21,25,27-33,35-42 -d "," $cs21 > cs16.res

#cal each pr's cs diff btw its patch and its code base
python get_cs_diff_sele.py cs16.res cs16Diff.res > cs16diff.log 2>&1 

#merge pr's 18 metric and code style diff
Rscript --slave get_expData.R $pr18 cs16Diff.res expData > exp.log 2>&1 
Rscript --slave pr_csdiff_corr_sameDiff.R expData_nor.res > exp_sameDiff_corr.res 2>corr.log 
Rscript --slave pr_csdiff_corr_rmDiff.R expData_nor.res > exp_rmDiff_corr.res 2>>corr.log 
}

#rm5diffMetrics $cs21 $pr18


function eachCSmetric(){
    csRes=$1
    expDat=$2
    nf=$(head -1 $csRes|awk -F "," '{print (NF-2)/2}')
    rm eachSpear.res
    for m in `seq 1 $nf` 
    do
        cbOrder=$((m+2))
        prOrder=$((cbOrder+nf))
        echo $cbOrder,$prOrder
        cut -f1-2,$cbOrder,$prOrder -d "," $csRes > eachM
        Rscript --slave eachCSspearman.R eachM $expDat >> eachSpear.res
#        break
    done
}
#eachCSmetric cs16.res expData_nor.res

function typicalCSmetric(){
pr18=$1
cut -f1-2,4,7-9,12,14,20,23-25,28,30 -d "," cs16.res > csTypical

#cal each pr's cs diff btw its patch and its code base
python get_cs_diff_sele.py csTypical csTypicalDiff.res > csTypicaldiff.log 2>&1 

#merge pr's 18 metric and code style diff
Rscript --slave get_expData.R $pr18 csTypicalDiff.res expDataTyp > exp.log 2>&1 
exit
Rscript --slave pr_csdiff_corr_sameDiff.R expDataTyp_nor.res > exp_sameDiff_corr_typ.res 2>corr.log 
Rscript --slave pr_csdiff_corr_rmDiff.R expDataTyp_nor.res > exp_rmDiff_corr_typ.res 2>>corr.log    
}
typicalCSmetric $pr18
