source('spearUtil.R')
argv<-commandArgs(TRUE)
expDat<-argv[1]

exp<-read.csv(expDat,sep=",",header=T)
exp<-exp[,c(-1:-4,-13,-26)]
exp$is_merged<-ifelse(exp$is_merged=="True",1,0)
csDiffSpear(exp)

