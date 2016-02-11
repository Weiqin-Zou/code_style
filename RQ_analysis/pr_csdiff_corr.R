library('plyr',lib.loc="~/myOwnRPackage")
argv<-commandArgs(TRUE)

pr18<-argv[1]
csdiff<-argv[2]

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

get_prLevel_corr<-function(prL){
##here, we also can use rmDiff to repalce of sameDiff.##
    prInsider<-tt[prL$is_insider==1,]
    prOutsider<-tt[prL$is_insider==0,]
    print("pr level multi logi of is_merged for insider:")
    prIn_lm<-lm(as.numeric(is_merged)~commit_num+churn_total_size+churn_final_size+churn_max_size+churn_file_num+final_churn_file_num+sameDiff,prInsider)
    print(summary(prIn_lm))

    print("pr level multi logi of is_merged for outsider:")
    prOut_lm<-lm(as.numeric(is_merged)~commit_num+churn_total_size+churn_final_size+churn_max_size+churn_file_num+final_churn_file_num+sameDiff,prOutsider)
    print(summary(prOut_lm))

    print("pr level multi logi of closed_time for insider:")
    prIn_lm<-lm(as.numeric(time_close)~commit_num+churn_total_size+churn_final_size+churn_max_size+churn_file_num+final_churn_file_num+sameDiff,prInsider)
    print(summary(prIn_lm))

    print("pr level multi logi of closed_time for outsider:")
    prOut_lm<-lm(as.numeric(time_close)~commit_num+churn_total_size+churn_final_size+churn_max_size+churn_file_num+final_churn_file_num+sameDiff,prOutsider)
    print(summary(prOut_lm))
}
get_projLevel_corr<-function(projL){
    projL$is_merged<-as.numeric(projL$is_merged)
    projIn<-tt[projL$is_insider==1,]
    projOut<-tt[projL$is_insider==0,]

    projInsider<-ddply(projIn,.(proj_loc,proj_age,proj_star,proj_fork,proj_insider,proj_open_pr),summarize,sameDiffave=mean(sameDiff),rmDiffave=mean(rmDiff),isMerge=length(is_merged[is_merged==1])/length(is_merged),closeTimeave=mean(time_close))
    print(head(projInsider,20))
    projOutsider<-ddply(projOut,.(proj_loc,proj_age,proj_star,proj_fork,proj_insider,proj_open_pr),summarize,sameDiffave=mean(sameDiff),rmDiffave=mean(rmDiff),isMerge=length(is_merged[is_merged==1])/length(is_merged),closeTimeave=mean(time_close))
    write.table(projOutsider,file='out.tmp',sep=',')
    print("proj level multi logi of is_merged for insider:")
    projIn_lm<-lm(isMerge~proj_loc+proj_age+proj_star+proj_fork+proj_open_pr+proj_insider+sameDiffave,projInsider)
    print(summary(projIn_lm))

    print("proj level multi logi of is_merged for outsider:")
    projOut_lm<-lm(isMerge~proj_loc+proj_age+proj_star+proj_fork+proj_open_pr+proj_insider+sameDiffave,projOutsider)
    print(summary(projOut_lm))

    print("proj level multi logi of closed_time for insider:")
    summary(projIn_lm)
    projIn_lm<-lm(closeTimeave~proj_loc+proj_age+proj_star+proj_fork+proj_open_pr+proj_insider+sameDiffave,projInsider)
    print(summary(projIn_lm))
    print("proj level multi logi of closed_time for outsider:")
    projOut_lm<-lm(closeTimeave~proj_loc+proj_age+proj_star+proj_fork+proj_open_pr+proj_insider+sameDiffave,projOutsider)
    print(summary(projOut_lm))
}
###todo tommorrow
corr_cal<-function(tt,corrRes){
    prAttr<-c("commit_num","churn_total_size","churn_final_size","churn_max_size","churn_file_num","final_churn_file_num","sameDiff","rmDiff")
    projAttr<-c("proj_loc","proj_age","proj_star","proj_fork","proj_open_pr","proj_insider","sameDiff","rmDiff")
    sAttr<-c("schurn_num","sclosedPR_num","scommit_num","sissue_num","smergedPR_num","sclosedPR_avgtime","sameDiff","rmDiff")
    y<-c("time_close","is_merged","is_insider")

    tt$is_merged<-ifelse(tt$is_merged=="True",1,0)
    tt$is_insider<-ifelse(tt$is_insider=="True",1,0)

    prL<-tt[,c(prAttr,y)]
    projL<-tt[,c(projAttr,y)]
    submitterL<-tt[,c(sAttr,y)]

    #get_prLevel_corr(prL)
    get_projLevel_corr(projL)
    #get_submitterLevel_corr(submitterL)

}

t<-merge_csdiff(pr18,csdiff)
tt<-prepare_expData(t)
corr_cal(tt,corrRes)
