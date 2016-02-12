#!/bin/bash
awk -F "," '{if(NF==23)print $0}' pr21_all_0212.res > pr21ok_all0212.res

#rm pr or cb record which has 21 # value metrics
python rmAllNArecord.py pr21ok_all0212.res 21 > pr21ok_all_final0212.res  
cp pr21ok_all_final0212.res pr21ok_all_final.res
 
#vim pr21ok_all0212.res file,replace # with NA
#!!!!do this mannually
