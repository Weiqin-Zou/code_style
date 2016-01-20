#!/bin/bash

#example:./get_loc_statsPerLine.sh newRepo_list reposDir mostRecentShaDir

reposDir=$1 #the dir which contains new repos's code base
newRepoList=$2 #this file contains all new repo' names
mostRecent=$3 #the dir which contains new repos's all closed pr's most recent commit

function cal_loc(){
rm newRepo_loc.res
for fn in $(cat $newRepoList)
do
    repo=$(echo $fn | awk -F "/" '{print $2}')
    cd $reposDir/$repo
    for pr in $(cat ../../${mostRecent}/${repo}_pr_recentSha)
    do
        sha=$(echo $pr | cut -f6 -d ",")
        git reset --hard $sha
        loc=$(find ./ -name "*.java" | xargs -I {} wc -l {}| cut -f1 -d "." | awk '{sum+=$1}END{print sum}')
        echo $pr,$loc>>../../newRepo_loc.res
    done
    cd ../../
done
}

cal_loc $1 $2 $3
