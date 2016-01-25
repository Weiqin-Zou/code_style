#!/bin/bash

mongoIP=$1


#for PR's 18 metrics, actually only 17 from Yiming are obtained, the other one is from me.
#so this script is used to get the 17 metrics of PR from Yiming.
python get_pr_17metrics.py $mongoIP pr_17_metrics.res


#./run_codeStyle.sh "commit[s|ed|ing]*|fix[es|ed|ing]*" filteredRepo

#python retrieve_gitInfo.py repoList mergedPR $1 
#cut -f1 -d "," repoList > filteredRepo
#sed '1d' filteredRepo > tmpList 
#./findFixCommit.sh tmpList "fix[es|ed|ing]*"
#
#./isPRbuggy.sh tmpList mergedPR
#
#rm tmpList
#
#./get_loc.sh $mongoIP fini client_IDSecret > log
