
# load eset
data(eset)
eset
# exprs, pData, fData
dim(exprs(eset))
pData(eset)
fData(eset)

# log2
hist(exprs(eset))
exprs(eset)=log2(exprs(eset)+1)

# aggregation to symbol
eset.agg=aggregate.eset(eset)


# protein coding
table(fData(eset.agg)$gene.type)
fil.eset=eset.agg[fData(eset.agg)$gene.type=="protein_coding",]


# mean of Tumor and Normal
mean.T=rowMeans(exprs(fil.eset[,1:3]))
mean.N=rowMeans(exprs(fil.eset[,4:6]))

# fold change
fc=mean.T-mean.N
hist(fc)

# add fdata 
fData(fil.eset)$fc=fc

# order by fc
fil.eset=fil.eset[order(fData(fil.eset)$fc, decreasing = T),]
head(exprs(fil.eset))

# DEG
length(which(fData(fil.eset)$fc > 2))
length(which(fData(fil.eset)$fc < -2))

deg.up=data.frame(symbol=featureNames(fil.eset)[which(fData(fil.eset)$fc > 2)], fc=fData(fil.eset)$fc[which(fData(fil.eset)$fc > 2)])
head(deg.up)

deg.down=data.frame(symbol=featureNames(fil.eset)[which(fData(fil.eset)$fc < -2)], fc=fData(fil.eset)$fc[which(fData(fil.eset)$fc < -2)])
head(deg.down)

# write
write.csv(deg.up, file = "result/deg.up.csv")
write.csv(deg.down, file = "result/deg.dn.csv")

# IGV
# DAVID
# network (GENEMENIA)







# Gene Set Enrichment Analysis

# rm NA
sum(is.na(exprs(fil.eset)))
fil.eset=fil.eset[which(rowSums(is.na(exprs(fil.eset)))==0),]

# input (.gct)
fn=file.path(getwd(), "result/expr.gct")
cat("#1.2\n", file=fn)
cat(c(nrow(fil.eset),"\t",ncol(fil.eset),"\n"), sep="", file=fn, append=T)
res=cbind(as.data.frame(rownames(fil.eset)), rownames(fil.eset), exprs(fil.eset))
colnames(res)[1:2]=c("NAME", "DESCRIPTION")
write.table(res, file=fn, append=T, sep="\t", quote=F, row.names=F, col.names=T)

# input (.cls)
fn=file.path(getwd(), "result/TvsN.cls")
pData(fil.eset)$class=factor(c("T","T","T","N","N","N"), levels=c("T","N"))
n.cls=names(table(pData(fil.eset)$class))
cat(paste(length(pData(fil.eset)$class),length(n.cls),"1",sep=" "),"\n", file=fn)
cat("#", file=fn, append=T)
cat(paste(n.cls,sep=" "),"\n", file=fn, append=T)
cat(paste(pData(fil.eset)$class,sep=" "),"\n", file=fn,append=T)

# .gmt
data(EMT.sig)
siglist=EMT.sig
fn=file.path(getwd(), "result/EMT.gmt")
for (i in 1:length(siglist)){
  cat(names(siglist[i]), "NA", siglist[[i]],"\n",append=T, sep="\t",file=fn)
}


