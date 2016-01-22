#!/bin/bash

fixPattern="fix[es|ed|ing]*" #"commit|fix" "commit[s|ed|ing]*|fix[es|ed|ing]*"
falseFixPattern="prefix|suffix|surffix"

bugInduceDir=./bugInduce2
reposDir=./repos
mkdir -p $bugInduceDir

for fn in $(ls $reposDir)
do
    cd $reposDir/$fn
    git log --pretty=oneline | grep -E -i $fixPattern > fixContained
    grep -E -iv $falseFixPattern fixContained > trueContained
    mv trueContained fixContained
    mv fixContained ../../$bugInduceDir/${fn}_fixContained
    
    cd ../../
done

