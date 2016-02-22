source('spearUtil.R')
argv<-commandArgs(TRUE)
cs21<-argv[1]
expDat<-argv[2]

exp<-read.csv(expDat,sep=",",header=T)
exp<-exp[,c(-3:-4,-13,-26,-27)]
exp$is_merged<-ifelse(exp$is_merged=="True",1,0)

cs21_t<-read.csv(cs21,sep=",",header=T)

csNum<-(length(names(cs21_t))-2)/2
for(i in 1:csNum){
    cb<-paste("cb",i,sep="")
    pr<-paste("pr",i,sep="")
    each<-cs21_t[,c("fn","id",cb,pr)]
    each<-na.omit(each)
    names(each)<-c("fn","id","cb","pr")
    each$rmDiff<-each$pr-each$cb
    each$pr<-NULL
    each$cb<-NULL
    all<-merge(exp,each,by=c("fn","id"))
    all$fn<-NULL
    all$id<-NULL

    print(paste(cb,pr,"rmDiff with other factors' spearman corr:"))
    csDiffSpear(all)
    
}

