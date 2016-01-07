#!/bin/bash

fixPattern=$1 #"fix[es|ed|ing]*" "commit|fix" "commit[s|ed|ing]*|fix[es|ed|ing]*"
projs=$2 #repo list 
mkdir -p bugInduce
mkdir -p repos
for repo in $(cat $projs)
do
    #repoDir=$(echo $repo | awk -F "/" '{print $2}')
    rm -rf repos/$repoDir
    cd repos
    repoUrl="git@github.com:""$repo"".git"
    git clone $repoUrl
    cd $repoDir
    git log --pretty=oneline | grep -E -i $fixPattern > fixContained
    grep -E -iwv  $fixPattern fixContained > maybeFalse

    mv fixContained ../../bugInduce/${repoDir}_fixContained
    mv maybeFalse ../../bugInduce/${repoDir}_maybeFalse
    
done
