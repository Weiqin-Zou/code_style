#!/bin/bash

#example:./get_loc.sh $reposDir newRepo_closedPR.res

#timezone related time chansform to unix timestamp
#date -d "2016-01-18T02:26:35Z" +%s
#date -d "2016-01-18T10:26:35+08:00" +%s ###run on unix system not mac
#use git log --date=iso-strict to get the just above 2016-01-18T10:26:35+08:00 time format

reposDir=$1 #the dir of many new repos's code base
newRepoList=$2 #this file contains all new repo' names
newRepo_cldPR=$3 #this file contains all new repos' closed pr

mostRecent=mostRecentSha #this dir is used to store all new repos' closed pr's most recent commit sha
mkdir -p $mostRecent

function get_mostRecentCommit(){

for fn in $(cat $newRepoList)
do
    repo=$(echo $fn | awk -F "/" '{print $2}')
    #get the closed(merged pr and unmerged) pr for a specific repo
    grep "^"$fn"," $newRepo_cldPR >closed

    cd ${reposDir}/${repo}
    #locate the most recent commit for each closed pr, as follows:
    #for merged pr, use the previous commit before the first commit sha of the pr
    #for closed pr without merged, use the commit time before the created time of the pr
    git log --pretty=format:"%H,%ct" --reverse >../../commitTime
    cd ../../
    for pr in $(cat closed)
    do
        cmtSha=$(echo $pr | cut -f4 -d ",")
        if [ $cmtSha -ne "" ]; #merged pr
        then
            mostRecentSha=$(git log --pretty=oneline $cmtSha"~2"..$cmtSha"~1" | cut -f1 -d " ")
            if [ $? -ne 0 ]; #cant find the cmtSha in the code base's master commit log 
            then
                echo "most recent commit location failed:",$pr
            fi
        else #ummerged pr
            cmtT=$(echo $pr | cut -f5 -d ",")
            cmtT=$(date -d $cmtT +%s)
            cmtSha=$(Rscript --slave mostRecentSha.R $cmtT commitTime | cut -f2 -d " ") 
            mostRecentSha=$(git log --pretty=oneline $cmtSha"~2"..$cmtSha"~1" | cut -f1 -d " ")
        fi
        echo $pr,$mostRecentSha >>${mostRecent}/${repo}_pr_recentSha
    done
done
}

get_mostRecentCommit $1 $2 $3
