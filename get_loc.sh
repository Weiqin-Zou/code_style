#!/bin/bash

#example:./get_loc.sh mongoIP finished_repolist clientAccount

mongoIP=$1
finishedRepoList=$2
clientFile=$3 #the file contains client id and secret

if [ ! -f "$finishedRepoList" ]; then
    touch $finishedRepoList
fi

client=$(cat $clientFile)

python get_newRepo_closedPR.py $mongoIP $finishedRepoList full_repoList newRepo_closedPR.res $client
#mv full_repoList $finishedRepoList
