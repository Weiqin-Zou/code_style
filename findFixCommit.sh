#!/bin/bash

repoList=$1 
fixPattern=$2 #"fix[es|ed|ing]*" "commit|fix" "commit[s|ed|ing]*|fix[es|ed|ing]*"

rootDir=~/code_style
bugInduceDir=$rootDir/bugInduce
reposDir=$rootDir/repos
mkdir -p $bugInduceDir
mkdir -p $reposDir

cd $rootDir
for fn in $(cat $repoList)
do
    repo=$(echo $fn | awk -F "/" '{print $2}')
    rm -rf $reposDir/$repo
    cd $reposDir
    repoUrl="git@github.com:""$fn"".git"
    git clone $repoUrl

    cd $repo
    git log --pretty=oneline | grep -E -i $fixPattern > fixContained
    grep -E -iwv  $fixPattern fixContained > maybeFalse

    mv fixContained $bugInduceDir/${repo}_fixContained
    mv maybeFalse $bugInduceDir/${repo}_maybeFalse
    
    cd $rootDir
done
