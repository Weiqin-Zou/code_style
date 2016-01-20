#!/bin/bash

#example:./get_newRepo_cldpr.sh mongoIP finished_repolist clientAccount

mongoIP=$1
finishedRepoList=$2
clientFile=$3 #the file contains client id and secret

if [ ! -f "$finishedRepoList" ]; then
    touch $finishedRepoList
fi

python get_newRepo_closedPR.py $mongoIP $finishedRepoList full_repoList newRepo_list newRepo_closedPR.res $clientFile

#mv full_repoList $finishedRepoList

