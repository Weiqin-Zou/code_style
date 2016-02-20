library('plyr',lib.loc="~/myOwnRPackage")
argv<-commandArgs(TRUE)

pr17<-argv[1]
cb11_10<-argv[2]
csuse<-argv[3]
pr18_out<-argv[4]

get_pr18<-function(pr17,cb11_10,pr18_out){
    #get all pr18
    pr17_t<-read.csv(pr17,header=T,sep=",")
    cb_cs21_t<-read.csv(cb11_10,header=F,sep=",")
    loc_t<-cb_cs21_t[,c(1,2,7)]
    names(loc_t)<-c("fn","id","proj_loc")
    pr17_t$proj_loc<-NULL
    pr18_t<-merge(pr17_t,loc_t,by=c("fn","id"))
    write.table(pr18_t,pr18_out,sep=",",row.names=F)

}
get_CSusage_pr18<-function(pr18,csuse){
    #divide pr18 into two parts:one with using checkstyle tool, one without
    pr18_t<-read.csv(pr18,sep=",",header=T)
    csuse_t<-read.csv(csuse,header=F,sep=",")
    names(csuse_t)<-c("repo","csTimes")
    use<-csuse_t[csuse_t$csTimes>0,]$repo
    nouse<-csuse_t[csuse_t$csTimes==0,]$repo
    pr18_t$repo<-as.character(lapply(as.character(pr18_t$fn),function(x)strsplit(x,'/')[[1]][2]))
    use_t<-pr18_t[pr18_t$repo %in% use,]
    nouse_t<-pr18_t[pr18_t$repo %in% nouse,]
    write.table(use_t,paste("useCS_",pr18,sep=""),sep=",",col.names=T,row.names=F)
    write.table(nouse_t,paste("nouseCS_",pr18,sep=""),sep=",",col.names=T,row.names=F)
}

get_pr18(pr17,cb11_10,pr18_out)
get_CSusage_pr18(pr18_out,csuse)

