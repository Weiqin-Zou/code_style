#!/bin/bash

#example:./filter_hist.sh 2011 2011 histD res > err.log 2>&1

startYear=$1
endYear=$2
histPath=$3 #the historay data path
resPath=$4
histStat=${startYear}to${endYear}_jsonCnt
mkdir -p $resPath
if [ -f "$histStat" ]; then
    rm $histStat
fi

for year in `seq $startYear $endYear`
do
    for hist in ${histPath}/$year/*.json.gz
    do
        timeHist=$(echo ${hist} | awk -F "/" '{print $NF}')
        cp $hist $timeHist

        ungzipTimeHist=$(echo ${timeHist} | cut -f1-2 -d ".")
        if [ -f "$ungzipTimeHist" ]; then
        rm $ungzipTimeHist
        fi

        gzip -d $timeHist
        histCnt=$(echo `wc -l $ungzipTimeHist` | cut -f1 -d " ")
        if [ $histCnt -eq 0 ]
        then
            sed -i 's/}{/}\n{/g' $ungzipTimeHist
        fi
        histCnt=$(wc -l $ungzipTimeHist)
        echo $histCnt >>$histStat
        echo "totalCnt of Fork,Watch,Member Event:" \
            `grep -E "ForkEvent|WatchEvent|MemberEvent" $ungzipTimeHist | wc -l` >>$histStat
        echo ${ungzipTimeHist}
        python filter_FWM_event.py $ungzipTimeHist ${year}.res ${year}.abnormal.log
        
        rm $ungzipTimeHist
    done
    mv ${year}.res ${year}.abnormal.log ${resPath} 
done
