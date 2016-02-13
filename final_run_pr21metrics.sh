#!/bin/bash

#example:./final_run_pr21metrics.sh patchDir
patchDir=$1
cd $patchDir
rm ${patchDir}_pr_21metrics.res

for patch in *.patch
do
    fn_pr=$(echo $patch | sed 's/\(.*\)\.patch$/\1/' | sed 's/\(.*\)_\(.*\)/\1,\2/')
    python ../get_modi_javaCode.py $patch > modi
    echo "modi" > codelist
    
    loc=$(cat modi | wc -l)
    if [ $loc -ne 0 ];
    then
        m1to11=$(python ../run_21metrics.py codelist)
        m12to21=$(java -jar ../Metrics22Driver.jar other codelist)     
    else 
        m1to11="#,#,#,#,#,#,#,#,#,#,#"
        m12to21="#,#,#,#,#,#,#,#,#,#"
    fi

    echo $fn_pr,$m1to11,$m12to21 >>${patchDir}_pr_21metrics.res
done
