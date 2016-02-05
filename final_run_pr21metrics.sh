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
    #m1and7=$(python ../oriModi_metrics.py codelist)
    m1and7=$(python ../run_21metrics.py codelist)
    m12to21=$(java -jar ../Metrics22Driver.jar other codelist) 
    echo $fn_pr,$m1and7,$m12to21
exit

done
