library('plyr',lib.loc="~/myOwnRPackage")
argv<-commandArgs(TRUE)
expData<-argv[1]

pr_corr<-function(pr_d){
    print("pr lm for is_merged:")
    pr_lm<-lm(is_merged~commit_num+churn_total_size+churn_final_size+churn_max_size+churn_file_num+final_churn_file_num+rmDiff,pr_d)
    print(summary(pr_lm))

    print("pr lm for time_close:")
    pr_lm<-lm(time_close~commit_num+churn_total_size+churn_final_size+churn_max_size+churn_file_num+final_churn_file_num+rmDiff,pr_d)
    print(summary(pr_lm))
}

get_prLevel_corr<-function(prL){
    print("pr level multi logi for all persion:")
    pr_corr(prL)
}

proj_corr<-function(proj_d){
    print("proj level multi logi for is_merged:")
    proj_lm<-lm(isMerge~proj_loc+proj_age+proj_star+proj_fork+proj_open_pr+proj_insider+rmDiffave,proj_d)
    print(summary(proj_lm))

    print("proj level multi logi for is_merged:")
    proj_lm<-lm(closeTimeave~proj_loc+proj_age+proj_star+proj_fork+proj_open_pr+proj_insider+rmDiffave,proj_d)
    print(summary(proj_lm))
}

get_projLevel_corr<-function(projL){
    proj<-ddply(projL,.(proj_loc,proj_age,proj_star,proj_fork,proj_insider,proj_open_pr),summarize,sameDiffave=mean(sameDiff),rmDiffave=mean(rmDiff),isMerge=length(is_merged[is_merged==1])/length(is_merged),closeTimeave=mean(time_close))

    print("proj level multi logi for all person:")
    proj_corr(proj)

}
submitter_corr<-function(sub_d){
    print("submitter level multi logi for is_merged:")
    sub_lm<-lm(isMerge~schurn_num+sclosedPR_num+scommit_num+sissue_num+smergedPR_num+sclosedPR_avgtime+rmDiffave,sub_d)
    print(summary(sub_lm))

    print("submitter level multi logi for time_close:")
    sub_lm<-lm(closeTimeave~schurn_num+sclosedPR_num+scommit_num+sissue_num+smergedPR_num+sclosedPR_avgtime+rmDiffave,sub_d)
    print(summary(sub_lm))
}
get_submitterLevel_corr<-function(submitterL){
    sub<-ddply(submitterL,.(schurn_num,sclosedPR_num,scommit_num,sissue_num,smergedPR_num,sclosedPR_avgtime),summarize,sameDiffave=mean(sameDiff),rmDiffave=mean(rmDiff),isMerge=length(is_merged[is_merged==1])/length(is_merged),closeTimeave=mean(time_close))
 
    print("sub level multi logi for all person:")
    submitter_corr(sub)
  
}

corr_cal<-function(expData_fin){
    tt<-read.csv(expData_fin,header=T,sep=",")
    prAttr<-c("commit_num","churn_total_size","churn_final_size","churn_max_size","churn_file_num","final_churn_file_num","sameDiff","rmDiff")
    projAttr<-c("proj_loc","proj_age","proj_star","proj_fork","proj_open_pr","proj_insider","sameDiff","rmDiff")
    sAttr<-c("schurn_num","sclosedPR_num","scommit_num","sissue_num","smergedPR_num","sclosedPR_avgtime","sameDiff","rmDiff")
    y<-c("time_close","is_merged")

    tt$is_merged<-as.numeric(ifelse(tt$is_merged=="True",1,0))
    prL<-tt[,c(prAttr,y)]
    projL<-tt[,c(projAttr,y)]
    submitterL<-tt[,c(sAttr,y)]

    get_prLevel_corr(prL)
    get_projLevel_corr(projL)
    get_submitterLevel_corr(submitterL)
}

corr_cal(expData)
