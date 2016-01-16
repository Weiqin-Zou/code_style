#!/bin/bash

#example:./get_loc.sh finished_repolist

mongoIP=$1
finishedRepoList=$2

if [ ! -f "$finishedRepoList" ]; then
    touch $finishedRepoList
fi

python get_newRepo_closedPR.py $mongoIP $finishedRepoList full_repoList newRepo_closedPR.res

