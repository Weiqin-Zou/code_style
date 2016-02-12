library('plyr',lib.loc="~/myOwnRPackage")
argv<-commandArgs(TRUE)

pr18<-argv[1]
csdiff<-argv[2]
expData<-argv[3]

merge_csdiff<-function(pr18,csdiff,expData){
    pr<-read.csv(pr18,sep=",",header=T)
    csdiff<-read.csv(csdiff,sep=",",header=T)
    all<-merge(pr,csdiff,by=c("fn","id"))
    write.table(all,file=paste(expData,"_ori.res",sep=''),sep=",",row.names=F)
    return(all)
}

prepare_expData<-function(pr18,csdiff,expData){
    t<-merge_csdiff(pr18,csdiff,expData)
    ty<-t[,c(1:3,12,13)]
    tx<-t[,c(4,6:11,14:28)]
    tx$sclosedPR_avgtime<-ifelse(tx$sclosedPR_num==0,NA,tx$sclosedPR_avgtime)
    xmax<-apply(tx,2,max,na.rm=T)
    xmin<-apply(tx,2,min,na.rm=T)
    txNor<-t(apply(tx,1,function(x)(x-xmin)/(xmax-xmin)))
    
    txFinal<-cbind(ty,txNor)
    write.table(txFinal,file=paste(expData,"_nor.res",sep=''),sep=",",row.names=F)
}


prepare_expData(pr18,csdiff,expData)
