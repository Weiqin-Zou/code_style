library('plyr',lib.loc="~/myOwnRPackage")
argv<-commandArgs(TRUE)

pr17<-argv[1]
pr21<-argv[2]
cb21<-argv[3]

get_cs_diff<-function(pr21,cb21){

}
get_pr_allMetrics<-function(pr17,pr21,cb21){
    pr17_t<-read.csv(pr17,header=T,sep=",")
    cb21_t<-read.csv(cb21,header=F,sep=",")
    pr21_t<-read.csv(pr21,header=F,sep=",")
    loc_t<-cb21_t[,c(1,2,7)]
    names(loc)<-c("fn","id","proj_loc")
    pr18_t<-merge(pr17_t,loc,by=)

}
