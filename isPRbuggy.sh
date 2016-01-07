#!/bin/bash

repoList=$1 
mergedPR=$2
rootDir=~/code_style
bugInduceDir=$rootDir/bugInduce
reposDir=$rootDir/repos

cd $rootDir
for fn in $(cat $repoList)
do
    fnpattern=$fn","
    grep -E ^$fnpattern $mergedPR > tmp_mpr

    repo=$(echo $fn | awk -F "/" '{print $2}')
    echo $repo
 
    cd $reposDir/$repo
    cut -f1 -d ' ' $bugInduceDir/${repo}_fixContained | xargs -I {} git show {} | 
    grep -E '^-[^-]' | sed 's/^-\(.*\)/\1/g' > buggyLines
    
    cd $rootDir
done
