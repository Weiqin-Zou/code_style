library('plyr',lib.loc="~/myOwnRPackage")
argv<-commandArgs(TRUE)
expData<-argv[1]

pr_corr<-function(pr_d){
    pr_glm<-glm(is_merged~commit_num+churn_total_size+churn_final_size+churn_max_size+churn_file_num+final_churn_file_num+rmDiff,data=pr_d,family=binomial(link="logit"))
    print("pr logi lm for is_merged:")
    print(summary(pr_glm))


    print("pr lm for is_merged:")
    pr_lm<-lm(is_merged~commit_num+churn_total_size+churn_final_size+churn_max_size+churn_file_num+final_churn_file_num+rmDiff,pr_d)
    print(summary(pr_lm))

    print("pr lm for time_close:")
    pr_lm<-lm(time_close~commit_num+churn_total_size+churn_final_size+churn_max_size+churn_file_num+final_churn_file_num+rmDiff,pr_d)
    print(summary(pr_lm))
}

get_prLevel_corr<-function(prL){
##here, we also can use rmDiff to repalce of sameDiff.##
    prInsider<-prL[prL$is_insider==1,]
    prOutsider<-prL[prL$is_insider==0,]

    print("pr level multi logi for insider:")
    pr_corr(prInsider)

    print("pr level multi logi for outsider:")
    pr_corr(prOutsider)
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
    projIn<-projL[projL$is_insider==1,]
    projOut<-projL[projL$is_insider==0,]

    projInsider<-ddply(projIn,.(proj_loc,proj_age,proj_star,proj_fork,proj_insider,proj_open_pr),summarize,sameDiffave=mean(sameDiff),rmDiffave=mean(rmDiff),isMerge=length(is_merged[is_merged==1])/length(is_merged),closeTimeave=mean(time_close))
    
    projOutsider<-ddply(projOut,.(proj_loc,proj_age,proj_star,proj_fork,proj_insider,proj_open_pr),summarize,sameDiffave=mean(sameDiff),rmDiffave=mean(rmDiff),isMerge=length(is_merged[is_merged==1])/length(is_merged),closeTimeave=mean(time_close))

    print("proj level multi logi for insider:")
    proj_corr(projInsider)

    print("proj level multi logi for outsider:")
    proj_corr(projOutsider)
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
    subIn<-submitterL[submitterL$is_insider==1,]
    subOut<-submitterL[submitterL$is_insider==0,]

    subInsider<-ddply(subIn,.(schurn_num,sclosedPR_num,scommit_num,sissue_num,smergedPR_num,sclosedPR_avgtime),summarize,sameDiffave=mean(sameDiff),rmDiffave=mean(rmDiff),isMerge=length(is_merged[is_merged==1])/length(is_merged),closeTimeave=mean(time_close))
    subOutsider<-ddply(subOut,.(schurn_num,sclosedPR_num,scommit_num,sissue_num,smergedPR_num,sclosedPR_avgtime),summarize,sameDiffave=mean(sameDiff),rmDiffave=mean(rmDiff),isMerge=length(is_merged[is_merged==1])/length(is_merged),closeTimeave=mean(time_close))
   
    print("sub level multi logi for insider:")
    submitter_corr(subInsider)

    print("sub level multi logi for outsider:")
    submitter_corr(subOutsider)
}
###todo tommorrow
corr_cal<-function(expData_fin){
    tt<-read.csv(expData_fin,header=T,sep=",")
    prAttr<-c("commit_num","churn_total_size","churn_final_size","churn_max_size","churn_file_num","final_churn_file_num","sameDiff","rmDiff")
    projAttr<-c("proj_loc","proj_age","proj_star","proj_fork","proj_open_pr","proj_insider","sameDiff","rmDiff")
    sAttr<-c("schurn_num","sclosedPR_num","scommit_num","sissue_num","smergedPR_num","sclosedPR_avgtime","sameDiff","rmDiff")
    y<-c("time_close","is_merged","is_insider")

    tt$is_merged<-as.numeric(ifelse(tt$is_merged=="True",1,0))
    tt$is_insider<-as.numeric(ifelse(tt$is_insider=="True",1,0))
    prL<-tt[,c(prAttr,y)]
    projL<-tt[,c(projAttr,y)]
    submitterL<-tt[,c(sAttr,y)]

    get_prLevel_corr(prL)
    get_projLevel_corr(projL)
    get_submitterLevel_corr(submitterL)
}

corr_cal(expData)
