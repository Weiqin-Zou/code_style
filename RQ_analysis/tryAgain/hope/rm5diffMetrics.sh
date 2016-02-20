#!/bin/bash
pr18in=$1
cs21in=$2

function rm5diffMetrics(){
pr18=$1
cs21=$2
cut -f1-2,4,6-12,14-21,25,27-33,35-42 -d "," $cs21 > cs16.res

#cal each pr's cs diff btw its patch and its code base
python get_cs_diff_sele.py cs16.res cs16Diff.res > cs16diff.log 2>&1 

#merge pr's 18 metric and code style diff
Rscript --slave get_expData.R $pr18 cs16Diff.res expData > exp.log 2>&1 
Rscript --slave noInOutSider_corr.R expData_nor.res > exp_corr.res 2>corr.log 
}

rm5diffMetrics $pr18in $cs21in

