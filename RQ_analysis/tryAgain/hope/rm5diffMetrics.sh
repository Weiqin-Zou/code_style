#!/bin/bash
cs21in=$1
pr18in=$2

function rm5diffMetrics(){
cs21=$1
pr18=$2
cut -f1-2,4,6-12,14-21,25,27-33,35-42 -d "," $cs21 > cs16.res

#cal each pr's cs diff btw its patch and its code base
python get_cs_diff_sele.py cs16.res cs16Diff.res > cs16diff.log 2>&1 

#merge pr's 18 metric and code style diff
Rscript --slave get_expData.R $pr18 cs16Diff.res expData > exp.log 2>&1 
Rscript --slave pr_csdiff_corr_sameDiff.R expData_nor.res > exp_sameDiff_corr.res 2>corr.log 
Rscript --slave pr_csdiff_corr_rmDiff.R expData_nor.res > exp_rmDiff_corr.res 2>>corr.log 
}

rm5diffMetrics $cs21in $pr18in

