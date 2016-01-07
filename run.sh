mongoIp=$1
#./run_codeStyle.sh "commit[s|ed|ing]*|fix[es|ed|ing]*" filteredRepo

#python retrieve_gitInfo.py repoList mergedPR $1 
#cut -f1 -d "," repoList > filteredRepo
sed '1d' filteredRepo > tmpList 
./run_codeStyle.sh tmpList "fix[es|ed|ing]*"
rm tmpList

