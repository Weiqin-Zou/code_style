#!/bin/bash

#example:./get_loc_statsPerLine.sh newRepo_list reposDir mostRecentShaDir

reposDir=$1 #the dir which contains new repos's code base
newRepoList=$2 #this file contains all new repo' names
mostRecent=$3 #the dir which contains new repos's all closed pr's most recent commit

function cal_loc_stats(){
rm newRepo_loc.res
for fn in $(cat $newRepoList)
do
    repo=$(echo $fn | awk -F "/" '{print $2}')
    cd $reposDir/$repo
    for pr in $(cat ../../${mostRecent}/${repo}_pr_recentSha)
    do
        sha=$(echo $pr | cut -f6 -d ",")
        git reset --hard $sha
        loc=$(find ./ -name "*.java" | xargs -I {} wc -l {}| cut -f1 -d "." | 
        awk '{sum+=$1}END{print sum}')

        if [ $loc ];
        then
            stats=$(find ./ -name "*.java" | xargs -I {} python statsPerLine.py {} zoutmpFile | 
            cut -f 2,5 -d " " | 
            awk '{cnt+=$1;comaCnt+=$2}END{if(cnt==0){print 1}else{print comaCnt*1.0/cnt}}')
        else 
            $stats="#"
        fi
        echo $pr,$loc,$stats>>../../newRepo_loc_stats.res

    done
    cd ../../
done
}

cal_loc_stats $1 $2 $3
