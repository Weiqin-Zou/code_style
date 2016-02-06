#!/bin/bash

#eg:./run_CB_21metrics_bat.sh newRepo_list 6

repoList=$1 #newRepo_list
runsNum=$2 #this para tells how many parts you want to divide the newRepo_list 

cnt=0
for i in `seq 1 $runsNum`
do
    rm newRepo_list_${i}
done

for fn in $(cat $repoList)
do
    runNum=$((cnt%runsNum +1 ))
    cnt=$((cnt+1))
    echo $fn >> newRepo_list_${runNum}
done

for i in `seq 1 $runsNum`
do
    ./final_run_cb21metrics.sh newRepo_list_${i} repos mostRecentSha > cb21_${i}.log 2>&1&
done

