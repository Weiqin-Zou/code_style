#!/bin/bash

#example:./get_mostRecentSha.sh ./repos newRepo_list newRepo_closedPR.res

#timezone related time chansform to unix timestamp
#date -d "2016-01-18T02:26:35Z" +%s
#date -d "2016-01-18T10:26:35+08:00" +%s ###run on unix system not mac
#use git log --date=iso-strict to get the just above 2016-01-18T10:26:35+08:00 time format

reposDir=$1 #the dir of many new repos's code base
newRepoList=$2 #this file contains all new repo' names
newRepo_cldPR=$3 #this file contains all new repos' closed pr

mostRecent=mostRecentSha #this dir is used to store all new repos' closed pr's most recent commit sha
mkdir -p $mostRecent
rm ./${mostRecent}/mergedNotInCmitLog

function get_mostRecentCommit(){

for fn in $(cat $newRepoList)
do
    repo=$(echo $fn | awk -F "/" '{print $2}')
    #get the closed(merged pr and unmerged) pr for a specific repo
    grep "^"$fn"," $newRepo_cldPR >${reposDir}/${repo}/closed

    rm ${mostRecent}/${repo}_pr_recentSha
    cd ${reposDir}/${repo}
    #locate the most recent commit for each closed pr, as follows:
    #for merged pr, use the previous commit before the first commit sha of the pr
    #for closed pr without merged, use the commit time before the created time of the pr
    #first we need to reset to the newest commit revision, then get the whole commitTime
    newestCommit=$(git reflog | grep ": clone: " | cut -f1 -d " ") 
    git reset --hard $newestCommit
    git log --pretty=format:"%H,%ct" --reverse >commitTime

    for pr in $(cat closed)
    do
        cmtSha=$(echo $pr | cut -f4 -d ",")

        if [ "$cmtSha" ]; #merged pr
        then
            mostRecentSha=$(grep -B1 $cmtSha commitTime | head -1 | cut -f1 -d ",")
        else #ummerged pr
            #the date time format is not ok for date command, translate it to utc time format
            cmtT=$(echo $pr | cut -f5 -d "," | awk -F "T|Z" '{print $1" "$2}')
            mostRecentSha=$(Rscript --slave ../../mostRecentSha.R "$cmtT" commitTime | cut -f2 -d " " | xargs -I {} echo {}) 
        fi

        if [ "$mostRecentSha" ]; #pr merged but not in the commit log
        then
            echo $pr,$mostRecentSha >>../../${mostRecent}/${repo}_pr_recentSha      
        else
            echo $pr >> ../../${mostRecent}/mergedNotInCmitLog
        fi
    done
    cd ../../
done
}

get_mostRecentCommit $1 $2 $3
