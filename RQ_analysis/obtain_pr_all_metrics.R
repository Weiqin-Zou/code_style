library('plyr',lib.loc="~/myOwnRPackage")
argv<-commandArgs(TRUE)

pr17<-argv[1]
pr_cs21<-argv[2]
cb_cs21<-argv[3]

get_cs_diff<-function(pr_cs21,cb_cs21){

}
get_pr_allMetrics<-function(pr17,pr_cs21,cb_cs21){
    pr17_t<-read.csv(pr17,header=T,sep=",")
    cb_cs21_t<-read.csv(cb_cs21,header=F,sep=",")
    pr_cs21_t<-read.csv(pr_cs21,header=F,sep=",")
    loc_t<-cb_cs21_t[,c(1,2,7)]
    names(loc_t)<-c("fn","id","proj_loc")
    pr17_t$proj_loc<-NULL
    pr18_t<-merge(pr17_t,loc_t,by=c("fn","id"))
    cs_diff_t<-get_cs_diff(pr_cs21,cb_cs21)
    pr_all_t<-merge(pr18_t,cs_diff_t,by=c("fn","id"))
}
get_pr_allMetrics(pr17,pr_cs21,cb_cs21)
