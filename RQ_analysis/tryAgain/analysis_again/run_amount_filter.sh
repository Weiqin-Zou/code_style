#!/bin/bash
#example:./run_amount_filter.sh pr_17_metrics.res pr11_10_rmallNA.res cb11_10_rmallNA.res pr_modiAmount.res pr18.res2 cs21.res2
pr17=$1
pr11_10=$2
cb11_10=$3
modiAmount=$4
pr18out=$5
cs21out=$6

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

function onlyOne(){
#onlyOne $cs21out $pr18out
cs21=$1
pr18=$2
for i in 4 #`seq 1 21`
do
    cbOrder=$((i+2))
    prOrder=$((cbOrder+21))
    cut -f1-2,$cbOrder,$prOrder -d "," $cs21 > one
    python onlyOneMetricDiff.py one > oneDiff
    Rscript --slave get_expData.R $pr18 oneDiff oneExpData > oneexp.log 2>&1 
    Rscript --slave pr_csdiff_corr_sameDiff.R oneExpData_nor.res > oneExp_sameDiff_corr.res 2>corr.log 
    Rscript --slave pr_csdiff_corr_rmDiff.R oneExpData_nor.res > oneExp_rmDiff_corr.res 2>>corr.log 

done
}

#the modi java code amount should be >=0.5,0.5-1.0 step by 0.1
for filter in `seq 0.5 0.1 1.0`
do
    Rscript --slave mergeAmount.R $pr11_10 $modiAmount $filter pr_${filter}
    cut -f1-23 -d "," pr_${filter} > prfiltered
    Rscript --slave obtain_pr_all_metrics.R $pr17 prfiltered $cb11_10 $pr18out $cs21out
    #rm5diffMetrics $cs21out $pr18out
    #mv exp_sameDiff_corr.res exp_sameDiff_corr_${filter}.res
    #mv exp_rmDiff_corr.res exp_rmDiff_corr_${filter}.res

    onlyOne $cs21out $pr18out
    break 
done
