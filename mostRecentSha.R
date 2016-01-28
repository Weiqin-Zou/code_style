argv<-commandArgs(TRUE)
ct<-argv[1]
cmtLog<-argv[2]

findMostRecentSha<-function(createdTime,cmitTimeLog){
   
   createdTime<-as.numeric(as.POSIXct(strptime(createdTime,"%Y-%m-%d %H:%M:%S","UTC")))
   t<-read.csv(cmitTimeLog,header=F,sep=",")
   names(t)<-c("commitSha","commitTime")
   ct<-t$commitTime
   idx<-which(ct>createdTime)
   if (length(idx)!=0){
       shaTime<-ct[idx[1]-1]
       print(as.vector(tail(t[t$commitTime==shaTime,],1)$commitSha))
   }else{
       print(as.vector(tail(t,1)$commitSha))
   }
}

findMostRecentSha(ct,cmtLog)
