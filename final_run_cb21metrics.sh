#!/bin/bash

#example:./final_run_cb21metrics.sh newRepo_list reposDir mostRecentShaDir

newRepoList=$1 #this file contains all new repo' names
reposDir=$2 #the dir which contains new repos's code base
mostRecent=$3 #the dir which contains new repos's all closed pr's most recent commit

function get_cb_loc21metrics(){
rm ${newRepoList}_CB_21.res
rm ${newRepoList}_CB_21_failedReset.res

for fn in $(cat $newRepoList)
do
    repo=$(echo $fn | awk -F "/" '{print $2}')
    cd $reposDir/$repo
    for pr in $(cat ../../${mostRecent}/${repo}_pr_recentSha)
    do
        sha=$(echo $pr | cut -f6 -d ",")
        git reset --hard $sha
        if [ $? -ne 0 ];then
          echo $pr >> ../../${newRepoList}_CB_21_failedReset.res
          echo "reset hard failed:" $sha >> ../../${newRepoList}_CB_21_failedReset.res
          continue
        fi
       
        find . -name "*.java" -type f > ${newRepoList}_codeFileList
        loc=$(find . -name "*.java" -type f | xargs -I {} wc -l {}| cut -f1 -d "." | 
        awk '{sum+=$1}END{print sum}')
        if [ $loc -ne 0 ];
        then
        m1to11=$(python ../../run_21metrics.py ${newRepoList}_codeFileList)
        m12to21=$(java -jar ../../Metrics22Driver.jar java ${newRepoList}_codeFileList) 
        else 
        m1to11="#,#,#,#,#,#,#,#,#,#,#"
        m12to21="#,#,#,#,#,#,#,#,#,#"
        fi
        echo $pr,$loc,$m1to11,$m12to21>>../../${newRepoList}_CB_21.res
    done
    cd ../../
done
}
#get_cb_loc21metrics $1 $2 $3
get_cb_loc21metrics $newRepoList $reposDir $mostRecent
