library('plyr',lib.loc="~/myOwnRPackage")
argv<-commandArgs(TRUE)

pr17<-argv[1]
pr_cs21<-argv[2]
cb_cs21<-argv[3]

#all the metrics with # value need to replace with NA.
#after that, we then can use the get_cs_diff function.
get_cs_diff<-function(pr_cs21_fin,cb_cs21_fin){
    pr_cs21<-read.csv(pr_cs21_fin,header=F,sep=",")
    cb_cs21<-read.csv(cb_cs21_fin,header=F,sep=",")
    pr21<-pr_cs21[,c(-1:-2)]
    cb21<-cb_cs21[,c(-1:-6)]
    prmax<-as.vector(apply(pr21,2,max,na.rm=T))
    prmin<-as.vector(apply(pr21,2,min,na.rm=T))
    cbmax<-as.vector(apply(cb21,2,max,na.rm=T))
    cbmin<-as.vector(apply(cb21,2,min,na.rm=T))
    cs_max<-pmax(prmax,cbmax)
    cs_min<-pmin(prmin,cbmin)
    pr21Nor<-t(apply(pr21,1,function(x)(x-cs_min)/(cs_max-cs_mmi)))
    #pr21Nor<-(pr21-cs_min)/(cs_max-cs_min)
    print(pr21Nor)
    cb21Nor<-t(apply(cb21,1,function(x)(x-cs_min)/(cs_max-cs_mmi)))

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
#get_pr_allMetrics(pr17,pr_cs21,cb_cs21)
get_cs_diff(pr_cs21,cb_cs21)
