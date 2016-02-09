library('plyr',lib.loc="~/myOwnRPackage")
argv<-commandArgs(TRUE)

pr18<-argv[1]
csdiff<-argv[2]
corrRes<-argv[3]

merge_csdiff<-function(pr18,csdiff){
    pr<-read.csv(pr18,sep=",",header=T)
    csdiff<-read.csv(csdiff,sep=",",header=T)
    all<-merge(pr,csdiff,by=c("fn","id"))
    write.table(all,file="final_dataset_csDiff_ori.res",sep=",",row.names=F)
    return(all)
}

prepare_expData<-function(t){
    ty<-t[,c(1:3,12,13)]
    tx<-t[,c(4,6:11,14:28)]

    tx$sclosedPR_avgtime<-ifelse(tx$sclosedPR_num==0,NA,tx$sclosedPR_avgtime)
    xmax<-apply(tx,2,max,na.rm=T)
    xmin<-apply(tx,2,min,na.rm=T)
    txNor<-t(apply(tx,1,function(x)(x-xmin)/(xmax-xmin)))
    
    txFinal<-cbind(ty,txNor)
    write.table(txFinal,file="final_dataset_csDiff_nor.res",sep=",",row.names=F)
    return(txFinal)

}

###todo tommorrow
corr_cal<-function(tt,corrRes){
    prAttr<-c("commit_num","churn_total_size","churn_final_size","churn_max_size","churn_file_num","final_churn_file_num","sameDiff","rmDiff")
    projAttr<-c("proj_loc","proj_age","proj_star","proj_fork","proj_open_pr","proj_insider","sameDiff","rmDiff")
    sAttr<-c("schurn_num","sclosedPR_num","scommit_num","sissue_num","smergedPR_num","sclosedPR_avgtime","sameDiff","rmDiff")
    y<-c("time_close","is_merged","is_insider")

    #print(tt)
    tt$is_merged<-ifelse(tt$is_merged=="True",1,0)
    tt$is_insider<-ifelse(tt$is_insider=="True",1,0)

    prL<-tt[,c(prAttr,y)]
    projL<-tt[,c(projAttr,y)]
    submitterL<-tt[,c(sAttr,y)]

    print(prL)
    print(projL)
    print(submitterL)
    #pr_res<-lm.test()
}

t<-merge_csdiff(pr18,csdiff)
tt<-prepare_expData(t)
corr_cal(tt,corrRes)
