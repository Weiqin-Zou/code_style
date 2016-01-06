#!/bin/bash

#find all commit contains fix|fixed|fixing and maybe false contains
function findFixcontains(){
git log --pretty=oneline | grep -E -i 'fix[es|ed|ing]*' > fixContained

grep -E -iwv  'fix[es|ed|ing]*' fixContained > maybeFalse
}
findFixcontains
#first manually check the maybeFalse file, and select the true false fixContains
#use $1=falseFixContains to filter $2=fixContained file. and get the final fix commits's sha
function filterFalseFix(){
  
  #grep -vwf falseFixContains fixContained
  grep -vwf $1 $2 | cut -f1 -d ' ' | xargs -I {} git show {} | grep -E '^-[^-]' | 
  sed 's/^-\(.*\)/\1/g'
}
filterFalseFix $1 $2
