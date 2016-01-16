#!/bin/bash

#example:./get_loc.sh finished_repolist

mongoIP=$1
finishedRepoList=$2
clientFile=$3 #the file contains client id and secret

if [ ! -f "$finishedRepoList" ]; then
    touch $finishedRepoList
fi

client=$(cat $clientFile)

python get_newRepo_closedPR.py $mongoIP $finishedRepoList full_repoList newRepo_closedPR.res $client

