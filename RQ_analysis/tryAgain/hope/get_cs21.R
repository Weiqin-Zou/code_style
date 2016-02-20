library('plyr',lib.loc="~/myOwnRPackage")
argv<-commandArgs(TRUE)

pr11_10<-argv[1]
cb11_10<-argv[2]
csuse<-argv[3]
cs21_out<-argv[4]

#before cal code style diff, we need to normalize the cb and pr metrics values 
#and then use cosine distance to represent the cs diff
normalize_merge<-function(pr11_10,cb11_10,cs21_out,type){
    
    #only retrieve the 21metrics
    pr21<-pr11_10[,c(-1:-2)]
    pr_repoID<-pr11_10[,c(1,2)]
    #for cb metrics, we remove the needless {} metric
    cb21<-cb11_10[,c(-1:-7)]
    cb_fnID<-cb11_10[,c(1,2)]
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
    write.table(cb_pr,paste(type,cs21_out,sep="_"),sep=",",row.names=F)
}

get_nor_csusage_cs21<-function(pr11_10_fin,cb11_10_fin,csuse_fin,cs21_out){
    pr11_10<-read.csv(pr11_10_fin,header=F,sep=",")
    cb11_10<-read.csv(cb11_10_fin,header=F,sep=",")
    #V1 is the fn col
    cb11_10$repo<-as.character(lapply(as.character(cb11_10$V1),function(x)strsplit(x,'/')[[1]][2]))

    csuse_t<-read.csv(csuse_fin,header=F,sep=",")
    names(csuse_t)<-c("repo","csTimes")
    use<-csuse_t[csuse_t$csTimes>0,]$repo
    nouse<-csuse_t[csuse_t$csTimes==0,]$repo

    #V1 is the repo col
    usepr11_10<-pr11_10[pr11_10$V1 %in% use,]
    nousepr11_10<-pr11_10[pr11_10$V1 %in% nouse,]
    usecb11_10<-cb11_10[cb11_10$repo %in% use,]
    nousecb11_10<-cb11_10[cb11_10$repo %in% nouse,]
    usecb11_10$repo<-NULL
    nousecb11_10$repo<-NULL

    normalize_merge(usepr11_10,usecb11_10,cs21_out,"useCS")   
    normalize_merge(nousepr11_10,nousecb11_10,cs21_out,"nouseCS")
}
get_nor_csusage_cs21(pr11_10,cb11_10,csuse,cs21_out)
