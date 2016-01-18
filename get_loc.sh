#!/bin/bash

#example:./get_loc.sh mongoIP finished_repolist clientAccount

#timezone related time chansform to unix timestamp
#date -d "2016-01-18T02:26:35Z" +%s
#date -d "2016-01-18T10:26:35+08:00" +%s ###run on unix system not mac
#use git log --date=iso-strict to get the just above 2016-01-18T10:26:35+08:00 time format

mongoIP=$1
finishedRepoList=$2
clientFile=$3 #the file contains client id and secret

function get_newRepo_closedPR(){
if [ ! -f "$finishedRepoList" ]; then
    touch $finishedRepoList
fi

client=$(cat $clientFile)

python get_newRepo_closedPR.py $mongoIP $finishedRepoList full_repoList newRepo_list newRepo_closedPR.res $client

#mv full_repoList $finishedRepoList
}
#get_newRepo_closedPR 

function clone_newRepo(){

reposDir=repos
mkdir -p $repoDir

for fn in $(cat newRepo_list)
do
    #clone the new repo
    repo=$(echo $fn | awk -F "/" '{print $2}')
    rm -rf $reposDir/$repo
    cd $reposDir
    repoUrl="git@github.com:""$fn"".git"
    git clone $repoUrl
done
}

function get_mostRecentCommit(){

reposDir=repos
mostRecent=mostRecentSha
mkdir -p $mostRecent
for fn in $(cat newRepo_list)
do
    #get the merged pr and unmerged pr
    grep "^"$fn"," newRepo_closedPR.res | grep ",merged," > ${repo}/merged
    grep "^"$fn"," newRepo_closedPR.res | grep ",unmerged," > ${repo}/unmerged

    cd ${repos}/${repo}
    #for merged pr, use the previous commit before the first commit sha of the pr
    rm mpr_recentSha
    rm upr_recentSha
    for mpr in $(cat merged)
    do
        cmtSha=$(echo $mpr | cut -f4 -d ",")
        mostRecentSha=$(git log --pretty=oneline $cmtSha"~2"..$cmtSha"~1" | cut -f1 -d " ")
        echo $mpr,$mostRecentSha >>mpr_recentSha
    done

    #for closed pr without merged, use the commit time before the created time of the pr
    git log --pretty=format:"%H,%ct" --reverse >commitTime
    for upr in $(cat unmerged)
    do
        cmtT=$(echo $upr | cut -f5 -d ",")
        cmtT=$(date -d $cmtT +%s)
        cmtSha=$(Rscript --slave mostRecentSha.R $cmtT commitTime | cut -f2 -d " ") 
        mostRecentSha=$(git log --pretty=oneline $cmtSha"~2"..$cmtSha"~1" | cut -f1 -d " ")
        echo $upr,$mostRecentSha >>upr_recentSha
    done
    cat mpr_recentSha upr_recentSha > ${mostRecent}/${repo}_recentSha
    cd ..
done
}

function cal_loc(){
reposDir=repos
mkdir -p $repoDir
for fn in $(cat newRepo_list)
do
    git reset $mostRecentSha
    loc=$(find ./ -name "*.java" | xargs -I {} wc -l {}| cut -f1 -d "." | awk '{sum+=$1}END{print sum}')
    done
}

