argv<-commandArgs(TRUE)
pr11_10<-argv[1]
modiAmount<-argv[2]
filter<-argv[3]
out<-argv[4]

pr<-read.table(pr11_10,sep=",",header=F)
amount<-read.table(modiAmount,sep=",",header=F)
amount<-amount[amount$V4/amount$V3>=filter,]
pr_a<-merge(pr,amount,by=c("V1","V2"))
write.table(pr_a,out,sep=",",col.names=F,row.names=F)

