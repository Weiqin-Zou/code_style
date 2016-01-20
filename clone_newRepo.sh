#!/bin/bash

#example:./clone_newRepo.sh newRepo_list
newRepoList=$1

reposDir="./repos"
mkdir -p $reposDir
for fn in $(cat $newRepoList)
do
    #clone the new repo
    repo=$(echo $fn | awk -F "/" '{print $2}')
    rm -rf $reposDir/$repo

    repoUrl="git@github.com:""$fn"".git"
    git clone $repoUrl $reposDir/$repo
done
