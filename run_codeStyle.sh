#!/bin/bash

fixPattern=$1 #"fix[es|ed|ing]*" "commit|fix" "commit[s|ed|ing]*|fix[es|ed|ing]*"
projs=$2 #repo list 
rm -rf bugInduce
mkdir bugInduce
for repo in $(cat $projName)
do
    repoDir=$(echo $repo | awk -F "/" '{print $2}')
    rm -rf $repoDir
    repoUrl="git@github.com:""$repo"".git"
    git clone $repoUrl
    cd $repoDir
    git log --pretty=oneline | grep -E -i $fixPattern > ../bugInduce/${repoDir}_fixContained
    grep -E -iwv  $fixPattern ../bugInduce/${repoDir}_fixContained > ../bugInduce/${repoDir}_maybeFalse
    #!!!!!!!!!then should mannually check the maybeFalse file to identify the real false fix commits
    #grep -vwf $1 $2 | cut -f1 -d ' ' | xargs -I {} git show {} | grep -E '^-[^-]' | 
    #sed 's/^-\(.*\)/\1/g'

    ####using merged pr to find the bug inducing pr
    ####todo!!!
    cd ..
    rm -rf $repoDir
done
