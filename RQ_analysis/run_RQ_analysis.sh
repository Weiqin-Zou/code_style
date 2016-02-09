#!/bin/bash
pr17=$1
pr21=$2
cb21=$3
pr18out=$4
cs21out=$5

#$pr18out need to be normalized, don't forget that
Rscript --slave obtain_pr_all_metrics.R $pr17 $pr21 $cb21 $pr18out $cs21out

#cal each pr's cs diff btw its patch and its code base
python get_cs_diff.py $cs21out csDiff.res > csdiff.log 2>&1 

#merge pr's 18 metric and code style diff, and then cal corr
Rscript --slave pr_csdiff_corr.R $pr18out csDiff.res exp.res > corr.log 2>&1 
