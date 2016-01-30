#!/bin/bash

#example:./download_patches.sh newRepo_closedPR.res 1 3 client_IDSecret
cldPR=$1
startNum=$2
endNum=$3
clientAccount=$4
patchDir=patch${startNum}-${endNum} #the patch downloaded dir ,such as patches_download

mkdir -p $patchDir 
clientCnt=$(cat $clientAccount | wc -l)
cnt=0

rm ${patchDir}/patchFailed.res
sed -n "$startNum,$endNum p" $cldPR > ./${patchDir}/cldPR

for pr in $(cat ./${patchDir}/cldPR)
do
    cnt=$((cnt+1))
    clientNum=$((cnt%clientCnt + 1))
    client=$(sed -n "${clientNum}p" $clientAccount)

    fn=$(echo $pr | cut -f1 -d ",")
    repo=$(echo $fn | cut -f2 -d "/")
    prID=$(echo $pr | cut -f2 -d ",")
    #url eg:https://patch-diff.githubusercontent.com/raw/Netflix/servo/pull/370.patch
    patchURL="https://patch-diff.githubusercontent.com/raw/"${fn}"/pull/"${prID}".patch"

    curl $patchURL -o ./${patchDir}/${repo}_${prID}.patch
    if [ $? -ne 0 ];then
        echo $patchURL>>${patchDir}/patchFailed.res
    fi
done
