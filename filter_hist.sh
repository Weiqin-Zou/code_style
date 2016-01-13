#!/bin/bash

startYear=$1
endYear=$2
histStat=${startYear}to${endYear}_jsonCnt

if [ -f "$histStat" ]; then
    rm $histStat
fi

for year in `seq $startYear $endYear`
do
    for hist in ../$year/*.json.gz
    do
        timeHist=$(echo ${hist} | cut -f3 -d "/")
        cp $hist $timeHist

        ungzipTimeHist=$(echo ${timeHist} | cut -f1-2 -d ".")
        if [ -f "$ungzipTimeHist" ]; then
        rm $ungzipTimeHist
        fi
        gzip -d <imeHist
        histCnt=$(wc -l $ungzipTimeHist)
        if
        echo $histCnt >>$histStat
        if [ $histCnt -eq 0 ];then
            sed -i 's/}{/}\n{/g' $ungzipTimeHist
        fi
        
        python filter_FWM_event.py $ungzipTimeHist fwmEvent_${startYear}to${endYear}.res

        rm $ungzipTimeHist
    done
done
