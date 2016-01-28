#!/bin/bash

#./cldPR_omission.sh $mongoIP pr_17_metrics.res final_newRepo_closedPR.res > ommit.log 2>&1&
mongoIP=$1
prAll=$2
gotPR=$3

#prAll has a head, we need not to print it, so we have FNR!=1 condition
awk -F "," '{if(FNR!=1)print $19","int($14)}' $prAll > prAll
awk -F "," '{print $1","int($2)}' $gotPR > gotPR

python get_omission_cldPR.py $mongoIP prAll gotPR ommision ommision_cldPR.res client_IDSecret

