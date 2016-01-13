#!/bin/bash

startYear=$1
endYear=$2
histStat=${startYear}to${endYear}_jsonCnt

if [ -f "$histStat" ]; then
    rm $histStat
fi

for year in `seq $startYear $endYear`
do
    mkdir -p ./res/${year}

    for hist in ../$year/*.json.gz
    do
        timeHist=$(echo ${hist} | awk -F "/" '{print $NF}')
        cp $hist $timeHist

        ungzipTimeHist=$(echo ${timeHist} | cut -f1-2 -d ".")
        if [ -f "$ungzipTimeHist" ]; then
        rm $ungzipTimeHist
        fi
        gzip -d $timeHist
        histCnt=$(wc -l $ungzipTimeHist)
        echo $histCnt >>$histStat
        if [ $histCnt -eq 0 ];then
            sed -i 's/}{/}\n{/g' $ungzipTimeHist
        fi
        
        python filter_FWM_event.py $ungzipTimeHist ${year}.res ${year}.abnormal.log
        mv ${year}.res ${year}.abnormal.log ./res/${year}
        rm $ungzipTimeHist
    done
done
