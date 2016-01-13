#!/bin/bash

histStat="jsonCntFile"
if [ -f "$histStat" ]; then
    rm $histStat
fi

for year in `seq 2011 2015`
do
    for hist in ../$year/*.json.gz
    do
        timeHist=$(echo ${hist} | cut -f3 -d "/")
        cp $hist <imeHist

        ungzipTimeHist=$(echo ${timeHist} | cut -f1-2 -d ".")
        if [ -f "$ungzipTimeHist" ]; then
        rm $ungzipTimeHist
        fi
        gzip -d <imeHist
        histCnt=$(wc -l $ungzipTimeHist)
        if
        echo $histCnt >>$histStat
        rm $ungzipTimeHist
    done
done

function transJsonFormat(){
grep -E "^0 " $histStat > oneline_json
#translate all json on one line to one json one line format
}
#sed -i 's/}{/}\n{/g' 2012-04-05-23.json>>
