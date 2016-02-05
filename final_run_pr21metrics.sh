#!/bin/bash

#example:./final_run_pr21metrics.sh patchDir
patchDir=$1
cd $patchDir
rm ${patchDir}_pr_21metrics.res
for patch in *.patch
do
    fn_pr=$(echo $patch | awk -F "[_.]" '{print $1","$2}')
    python ../get_modi_javaCode.py $patch > modi
    echo "modi" > codelist
    m1to11=$(python ../run_21metrics.py codelist)
    m12to21=$(java -jar ../Metrics22Driver.jar other codelist) 
    #m12to21=$(java -jar ../Driver.jar other codelist) 

    echo $fn_pr,$m1to11,$m12to21>>${patchDir}_pr_21metrics.res
done
