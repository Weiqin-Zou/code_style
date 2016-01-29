#!/bin/bash

#example:./get_PR_22Metrics.sh newRepo_closedPR.res

cldPR=$1
clientAccount=$2

rm newRepo_pr_22metrics.res
clientCnt=$(cat $clientAccount | wc -l)
cnt=0
rm modi
rm patchFailed.res
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
        echo $patchURL>>patchFailed.res
    fi
    python get_modi_javaCodeOC.py patch > modi
    echo "modi" > patchList
    metrics21=$(java -jar Metrics22Driver.jar other patchList)
    stats=$(python ./statsPerLine.py modi | cut -f2,4 -d " " | 
            awk '{cnt+=$1;comaCnt+=$2}END{if(cnt==0){print 1}else{print comaCnt*1.0/cnt}}')
    if [ $? -ne 0 ];then
        stats="#"
    fi

    echo $stats,$metrics21 >> newRepo_pr_22metrics.res

done
