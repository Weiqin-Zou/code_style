argv<-commandArgs(TRUE)

pr17<-argv[1]
cb11_10<-argv[2]
pr11_10<-argv[3]
modiAmount<-argv[4]
filter<-argv[5]

filterData<-function(pr17,cb11_10,pr11_10,modiAmount,filter){
    modi_t<-read.table(modiAmount,header=F,sep=",")
    names(modi_t)<-c("repo","id","totalModi","javaModi")
    modi_t<-modi_t[modi_t$javaModi/modi_t$totalModi>=filter,c("repo","id")]
    
    pr17_t<-read.csv(pr17,header=T,sep=",")
    pr17_t$repo<-as.character(lapply(as.character(pr17_t$fn),function(x)strsplit(x,'/')[[1]][2]))
    pr17_t<-merge(pr17_t,modi_t,by=c("repo","id"))
    fnid<-pr17_t[,c("fn","id")]
    repoid<-pr17_t[,c("repo","id")]
    pr17_t$repo<-NULL

    cb_cs21_t<-read.csv(cb11_10,header=F,sep=",")
    cb_cs21_t<-merge(fnid,cb_cs21_t,by.x=c("fn","id"),by.y=c("V1","V2"))

    pr_cs21_t<-read.csv(pr11_10,header=F,sep=",")
    pr_cs21_t<-merge(repoid,pr_cs21_t,by.x=c("repo","id"),by.y=c("V1","V2"))
    
    write.table(pr17_t,paste("pr17",filter,sep="_"),sep=",",col.names=T,row.names=F)
    write.table(cb_cs21_t,paste("cb11_10",filter,sep="_"),sep=",",col.names=F,row.names=F)
    write.table(pr_cs21_t,paste("pr11_10",filter,sep="_"),sep=",",col.names=F,row.names=F)
}

filterData(pr17,cb11_10,pr11_10,modiAmount,filter)

