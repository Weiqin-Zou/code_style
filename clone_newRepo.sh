#!/bin/bash

#example:./clone_newRepo.sh newRepo_list reposDir
newRepoList=$1

reposDir=$2 #"./repos"
mkdir -p $reposDir
rm failedClone
for fn in $(cat $newRepoList)
do
    #clone the new repo
    repo=$(echo $fn | awk -F "/" '{print $2}')
    rm -rf $reposDir/$repo

    repoUrl="git@github.com:""$fn"".git"
    git clone $repoUrl $reposDir/$repo

    if [ $? -ne 0 ];then
        echo $repoUrl >> failedClone
    fi
done
