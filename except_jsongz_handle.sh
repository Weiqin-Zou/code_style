#!/bin/bash

exceptJsongz_List=$1 #file which contains a list of except json gz file names
histStat="exceptJsongzCnt"
for jsongz in $(cat ${exceptJsongz_List})
do
    wget http://data.githubarchive.org/${jsongz}
    year=$(echo ${jsongz} | cut -f1 -d "-")

    gzip -d ${jsongz}
    ungzipTimeHist=$(echo ${jsongz} | cut -f1-2 -d ".")
    histCnt=$(echo `wc -l $ungzipTimeHist` | cut -f1 -d " ")
    if [ $histCnt -eq 0 ]
    then
        sed -i 's/}{/}\n{/g' $ungzipTimeHist
    fi
    histCnt=$(wc -l $ungzipTimeHist)
    echo $histCnt >>$histStat
    echo "original totalCnt of Fork,Watch,Member Event:" \
         `grep -E "ForkEvent|WatchEvent|MemberEvent" $ungzipTimeHist | wc -l` >>$histStat
    echo ${ungzipTimeHist}

    python filter_FWM_event.py $ungzipTimeHist except_jsongz.res except_jsongz.abnormal.log
    rm ${ungzipTimeHist}
done
 
 
