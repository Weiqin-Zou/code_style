#!/bin/bash

#example:./get_PR_22Metrics.sh newRepo_closedPR.res

cldPR=$1
clientAccount=$2

rm newRepo_pr_22metrics.res
clientCnt=$(cat $clientAccount | wc -l)
cnt=0
echo $clientCnt
rm modi
for pr in $(cat $cldPR)
do
    cnt=$((cnt+1))
    clientNum=$((cnt%clientCnt + 1))
    client=$(sed -n "${clientNum}p" $clientAccount)

    fn=$(echo $pr | cut -f1 -d ",")
    prID=$(echo $pr | cut -f2 -d ",")
    #url eg:https://patch-diff.githubusercontent.com/raw/Netflix/servo/pull/370.patch
    patchURL="https://patch-diff.githubusercontent.com/raw/"${fn}"/pull/"${prID}".patch"

    curl $patchURL -o patch
    if [ $? -ne 0 ];then
        echo $patchURL
    fi
    python get_modi_javaCodeOC.py patch > modi
    echo "modi" > patchList
    java -jar Metrics22Driver.jar other patchList 
    if [ $cnt -eq 3 ];then
        exit
    fi
done
