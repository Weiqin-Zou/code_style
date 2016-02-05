#!/bin/bash

#example:./final_run_pr21metrics.sh patchDir
patchDir=$1
rm ${patchDir}_pr_21metrics.res
cd $patchDir
for patch in *.patch
do
    fn_pr=$(echo $patch | awk -F "[_.]" '{print $1","$2}')
    python ../get_modi_javaCode.py $patch > modi
    echo "modi" > codelist
    m1and7=$(python ../oriModi_metrics.py codelist)
    m12to21=$(java -jar ../Metrics22Driver.jar other codelist) 
    echo $m1and7,$m12to21
    exit
    stats=$(python ./statsPerLine.py modi | cut -f2,4 -d " " | 
            awk '{cnt+=$1;comaCnt+=$2}END{if(cnt==0){print 1}else{print comaCnt*1.0/cnt}}')
    if [ $? -ne 0 ];then
        stats="#"
    fi

    echo $pr,$stats,$metrics21 >> newRepo_pr_22metrics.res

done
