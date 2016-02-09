#!/bin/bash
pr17=$1
pr21=$2
cb21=$3
pr18out=$4
cs21out=$5

#$pr18out need to be normalized, don't forget that
Rscript --slave obtain_pr_all_metrics.R $pr17 $pr21 $cb21 $pr18out $cs21out

python get_cs_diff.py $cs21out
