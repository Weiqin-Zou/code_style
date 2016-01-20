argv<-commandArgs(TRUE)
ct<-argv[1]
cmtLog<-argv[2]

findMostRecentSha<-function(createdTime,cmitTimeLog){
   
   t<-read.csv(cmitTimeLog,header=F,sep=",")
   names(t)<-c("commitSha","commitTime")
   ct<-t$commitTime
   idx<-which(ct>createdTime)
   shaTime<-ct[idx[1]-1]
   print(as.vector(t[t$commitTime==shaTime,]$commitSha))

}

findMostRecentSha(ct,cmtLog)
