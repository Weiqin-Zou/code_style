#!/bin/bash

mongoIP=$1
prAll=$2
gotPR=$3

#prAll has a head, we need not to print it, so we have FNR!=1 condition
awk -F "," '{if(FNR!=1)print $19","int($14)}' $prAll > prAll
awk -F "," '{print $1","int($2)}' $gotPR > gotPR

python get_omission_cldPR.py $mongoIP prAll gotPR ommision ommision_cldPR.res client_IDSecret
