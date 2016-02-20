library("plyr",lib.loc="~/myOwnRPackage")

argv<-commandArgs(TRUE)
pr17<-argv[1]

t<-read.table(pr17,sep=",",header=T)

tt<-ddply(t,.(fn),summarize,mergeRate=length(is_merged[is_merged=="True"])/length(is_merged),totalPR=length(is_merged),timecost=mean(time_close))
write.table(tt,"mergedRate_timecost.res",sep=",",col.names=T,row.names=F)
