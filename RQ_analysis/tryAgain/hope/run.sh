#!/bin/bash
filter=0.5 #filter those patches which contains less than 50% java code modification
Rscript --slave filter.R pr_17_metrics cb11_10_rmallNA.res pr11_10_rmallNA.res pr_modiAmount.res $filter 
#get all pr18 and divide into use or not use cs part's pr18
#out:pr18_0.5.res,useCS_pr18_0.5.res and nouseCS_pr18_0.5.res
Rscript --slave get_pr18.R pr17_${filter} cb11_10_${filter} useCSrepo.res pr18_${filter}.res

#get cs 21 metrics and divide into use or not use cs part's cs21
#out:useCS_cs21_0.5.res and nouseCS_cs21_0.5.res
Rscript --slave get_cs21.R pr11_10_${filter} cb11_10_${filter} useCSrepo.res cs21_${filter}.res

#to cal mulit linear regression
rm -r corr_res
mkdir -p corr_res
./rm5diffMetrics.sh useCS_pr18_0.5.res useCS_cs21_0.5.res
mv exp_sameDiff_corr.res ./corr_res/useCS_exp_sameDiff_corr_${filter}.res
mv exp_rmDiff_corr.res ./corr_res/useCS_exp_rmDiff_corr_${filter}.res

./rm5diffMetrics.sh nouseCS_pr18_0.5.res nouseCS_cs21_0.5.res
mv exp_sameDiff_corr.res ./corr_res/nouseCS_exp_sameDiff_corr_${filter}.res
mv exp_rmDiff_corr.res ./corr_res/nouseCS_exp_rmDiff_corr_${filter}.res

