library('plyr',lib.loc="~/myOwnRPackage")
argv<-commandArgs(TRUE)

pr17<-argv[1]
pr_cs21<-argv[2]
cb_cs21<-argv[3]
pr18_out<-argv[4]
cs21_out<-argv[5]

#before cal code style diff, we need to normalize the cb and pr metrics values 
#and then use cosine distance to represent the cs diff
normalize_merge<-function(pr_cs21_fin,cb_cs21_fin,cs21_out){
    pr_cs21<-read.csv(pr_cs21_fin,header=F,sep=",")
    cb_cs21<-read.csv(cb_cs21_fin,header=F,sep=",")

    #only retrieve the 21metrics
    pr21<-pr_cs21[,c(-1:-2)]
    pr_repoID<-pr_cs21[,c(1,2)]
    #for cb metrics, we remove the needless {} metric
    cb21<-cb_cs21[,c(-1:-7)]
    cb_fnID<-cb_cs21[,c(1,2)]
    #find the max and min value of each metrics
    prmax<-as.vector(apply(pr21,2,max,na.rm=T))
    prmin<-as.vector(apply(pr21,2,min,na.rm=T))
    cbmax<-as.vector(apply(cb21,2,max,na.rm=T))
    cbmin<-as.vector(apply(cb21,2,min,na.rm=T))
    cs_max<-pmax(prmax,cbmax)
    cs_min<-pmin(prmin,cbmin)

    #using the max and min metric value to normalize each metric value
    pr21Nor<-t(apply(pr21,1,function(x)(x-cs_min)/(cs_max-cs_min)))
    pr21Nor<-cbind(pr_repoID,pr21Nor)
    names(pr21Nor)<-c("repo","id",paste("pr",1:21,sep=""))

    cb21Nor<-t(apply(cb21,1,function(x)(x-cs_min)/(cs_max-cs_min)))
    cb21Nor<-cbind(cb_fnID,cb21Nor)
    names(cb21Nor)<-c("fn","id",paste("cb",1:21,sep=""))

    cb21Nor$repo<-as.character(lapply(as.character(cb21Nor$fn),function(x)strsplit(x,'/')[[1]][2]))

    cb_pr<-merge(cb21Nor,pr21Nor,by=c("repo","id"))
    cb_pr$repo<-NULL
    write.table(cb_pr,file=cs21_out,sep=",",row.names=F)
}

get_pr18<-function(pr17,cb_cs21,pr18_out){
    pr17_t<-read.csv(pr17,header=T,sep=",")
    cb_cs21_t<-read.csv(cb_cs21,header=F,sep=",")
    loc_t<-cb_cs21_t[,c(1,2,7)]
    names(loc_t)<-c("fn","id","proj_loc")
    pr17_t$proj_loc<-NULL
    pr18_t<-merge(pr17_t,loc_t,by=c("fn","id"))
    write.table(pr18_t,file=pr18_out,sep=",",row.names=F)
}

get_pr18(pr17,cb_cs21,pr18_out)
normalize_merge(pr_cs21,cb_cs21,cs21_out)
