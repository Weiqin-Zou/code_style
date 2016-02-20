library("ggplot2",lib.loc="~/myOwnRPackage")
library("labeling",lib.loc="~/myOwnRPackage")

argv<-commandArgs(TRUE)
mergedRate<-argv[1]
csuse<-argv[2]

mr<-read.table(mergedRate,sep=",",header=T)
use<-read.table(csuse,sep=",",header=F)
names(use)<-c("repo","csTimes")
use$usecs<-ifelse(use$csTimes>0,1,0)
mr$repo<-as.character(lapply(as.character(mr$fn),function(x)strsplit(x,'/')[[1]][2]))
mru<-merge(mr,use,by=c("repo"))

p<-ggplot(mru,aes(x=factor(usecs),y=mergeRate))+geom_boxplot()
print(p)

p<-ggplot(mru,aes(x=factor(usecs),y=timecost))+geom_boxplot()
print(p)

write.table(mru,"cs_mergedRate.res",sep=",",col.names=T,row.names=F)

