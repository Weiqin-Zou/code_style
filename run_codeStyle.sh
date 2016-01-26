#!/bin/bash

mongoIP=$1

#this script needs to cal the following metrics:
#1) the 22 code style metrics(20 metrics from Yiming et al.
#the other two are from Weiqin, i.e., statsPerLine and comment adjust)
#2) the proj_loc metric of 18 PR metrics(17 metrics have been cal by 
#Yiming, the remained one, i.e., proj_loc is from Weiqin)

#two steps to complete this task:
#1) find the most recent commit sha for the submitted pr. in details:
#   a) for merged pr, we use the commit just befor the pr's first commit sha
#   b) for unmerged pr, we use the commit just before the pr's created time
#   c) for a) and b), we first need to find the pr's first commit and created time
#2) reset code base to the most recent commit and perform 22 metrics calculation

#OK,let's go to the detailed programs and scripts to perfrom the above steps
#1) find the most recent commit sha for the submitted pr.
# find the pr's first commit and created time
./get_newRepo_cldpr.sh $mongoIP finished_repolist client_IDSecret > pr_cld.log 2>&1

#clone the git repos to get the code base
./clone_newRepo.sh newRepo_list > clone.log 2>&1
#find the most recent commit
./get_mostRecentSha.sh ./repos newRepo_list newRepo_closedPR.res > mostRecent.log 2>&1

#2) reset code base to the most recent commit and perform 22 metrics calculation
./get_loc_statsPerLine.sh ./repos newRepo_list ./mostRecentSha > locStats.log 2>&1

