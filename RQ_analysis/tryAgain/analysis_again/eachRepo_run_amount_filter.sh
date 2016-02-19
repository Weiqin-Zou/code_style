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
python get_cs_diff_sele.py cs16.res cs16Diff.res >> cs16diff.log 2>&1 

#merge pr's 18 metric and code style diff
Rscript --slave get_expData.R $pr18 cs16Diff.res expData >> exp.log 2>&1 
Rscript --slave pr_csdiff_corr_sameDiff.R expData_nor.res > exp_sameDiff_corr.res 2>>corr.log 
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
    Rscript --slave get_expData.R $pr18 oneDiff oneExpData >> oneexp.log 2>&1 
    Rscript --slave pr_csdiff_corr_sameDiff.R oneExpData_nor.res > oneExp_sameDiff_corr.res 2>>corr.log 
    Rscript --slave pr_csdiff_corr_rmDiff.R oneExpData_nor.res > oneExp_rmDiff_corr.res 2>>corr.log 

done
}

rm -r corr_res
mkdir corr_res
#the modi java code amount should be >=0.5,0.5-1.0 step by 0.1
for filter in `seq 0.5 0.1 1.0`
do
    Rscript --slave mergeAmount.R $pr11_10 $modiAmount $filter pr_${filter}
    cut -f1-23 -d "," pr_${filter} > prfiltered
    cut -f1 -d "," prfiltered | sort -u |xargs -I {} echo {} > repos
    rm expData_nor_one 
    rm expData_nor_all
    rm expData_ori_all_${filter}.res
    rm expData_nor_all_${filter}.res
    rm expData_ori_one_${filter}.res
    rm expData_nor_one_${filter}.res

    for repo in $(cat repos)
    do
        head -1 $pr17 > pr17
        grep $repo $pr17 >> pr17
        grep $repo $cb11_10>cb11_10
        grep $repo prfiltered>prfil
        Rscript --slave obtain_pr_all_metrics.R pr17 prfil cb11_10 $pr18out $cs21out
        rm5diffMetrics $cs21out $pr18out
        mv exp_sameDiff_corr.res ./corr_res/${repo}_sameDiff_corr_${filter}.res
        mv exp_rmDiff_corr.res ./corr_res/${repo}_rmDiff_corr_${filter}.res
        len=$(cat expData_ori.res | wc -l)
        len=$((len-1))
        tail -n $len expData_ori.res >> expData_ori_all
        tail -n $len expData_nor.res >> expData_nor_all

        onlyOne $cs21out $pr18out
        mv oneExp_sameDiff_corr.res ./corr_res/${repo}_oneSameDiff_corr_${filter}.res
        mv oneExp_rmDiff_corr.res ./corr_res/${repo}_oneRmDiff_corr_${filter}.res
        len=$(cat expData_ori.res | wc -l)
        len=$((len-1))
        tail -n $len expData_ori.res >> expData_ori_one
        tail -n $len expData_nor.res >> expData_nor_one
    #break
    done
    head -1 expData_ori.res > h 
    head -1 expData_nor.res > h2
    cat h expData_ori_all>>expData_ori_all_${filter}.res
    cat h2 expData_nor_all>>expData_nor_all_${filter}.res
    cat h expData_ori_one>>expData_ori_one_${filter}.res
    cat h2 expData_nor_one>>expData_nor_one_${filter}.res
    
    Rscript --slave pr_csdiff_corr_sameDiff.R expData_nor_all_${filter}.res >./corr_res/allSame_${filter}.res
    Rscript --slave pr_csdiff_corr_rmDiff.R expData_nor_all_${filter}.res >./corr_res/allrm_${filter}.res

    Rscript --slave pr_csdiff_corr_sameDiff.R expData_nor_one_${filter}.res >./corr_res/oneSame_${filter}.res
    Rscript --slave pr_csdiff_corr_rmDiff.R expData_nor_one_${filter}.res >./corr_res/onerm_${filter}.res

    #break
done
