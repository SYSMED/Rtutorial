################
#preprocessing 
################
data(eset)
hist(exprs(eset), breaks=100)


#1. log2 trnasformation
exprs(eset)=apply(exprs(eset)+1, 2, log2)
hist(exprs(eset), breaks=100)
boxplot(exprs(eset))



#2. aggregation by gene_symbol
head(fData(eset))
length(unique(fData(eset)$gene.name))
freq.dat=as.data.frame(table(fData(eset)$gene.name))

agg.expr=aggregate(exprs(eset), by=list(fData(eset)$gene.name), FUN=mean, na.rm=TRUE)
head(agg.expr)
colnames(agg.expr)[1]="Symbol"


#2-1. make aggregation.eset
id=agg.expr$Symbol
agg.expr=agg.expr[-1]
dim(agg.expr)
rownames(agg.expr)=id
head(agg.expr)

fdata=gtf[match(id, gtf$gene.name),]
rownames(fdata)=id
head(fdata)
featureData=AnnotatedDataFrame(data=fdata)

agg.eset=ExpressionSet(as.matrix(agg.expr), phenoData=phenoData, featureData=featureData)
agg.eset


#3. centering (gene & array centering)
#gene centering
gcen.expr=t(apply(exprs(agg.eset), 1, function(a) a-mean(a, na.rm=T)))

#array centering
agcen.expr=apply(gcen.expr, 2, function(a) a-mean(a, na.rm=T))
hist(agcen.expr, breaks=100)


################
#heatmap 
################
library(gplots)

mad=apply(agcen.expr, 1, mad)
quantile(mad)
fil.expr=agcen.expr[which(mad>1.0),]
dim(fil.expr)

heatmap.2(fil.expr, col=redgreen(75), density.info="none", trace="none", symm=F, symkey=T, scale="none") 

#add column label
col.color=colnames(fil.expr)
col.color[grep("^Wang_038$|^Wang_039$|^Wang_040$", col.color)]="gold"
col.color[grep("^Wang_138$|^Wang_139$|^Wang_140$", col.color)]="gray"
table(col.color)
heatmap.2(fil.expr, col=redgreen(75), density.info="none", trace="none", symm=F, symkey=T, symbreaks=F, scale="none", ColSideColors = col.color) 


##############################
#diffentially expressed genes 
##############################
eset=agg.eset
pData(eset)$tissue.type=NULL
pData(eset)$tissue.type=ifelse(grepl("^Wang_038$|^Wang_039$|^Wang_040$", sampleNames(eset)), "T", "N")
head(pData(eset))

t.id=sampleNames(eset)[grep("T", pData(eset)$tissue.type)]
n.id=sampleNames(eset)[grep("N", pData(eset)$tissue.type)]

fData(eset)$t.mean=rowMeans(exprs(eset[,t.id]))
fData(eset)$n.mean=rowMeans(exprs(eset[,n.id]))
fData(eset)$fc=fData(eset)$t.mean-fData(eset)$n.mean
fData(eset)$mad=apply(exprs(eset), 1, mad)

t.up=fData(eset)[which(fData(eset)$fc> 1.5 & fData(eset)$mad> 0.2 & fData(eset)$gene.type=="protein_coding"),]
t.dn=fData(eset)[which(fData(eset)$fc< -1.5 & fData(eset)$mad> 0.2 & fData(eset)$gene.type=="protein_coding"),]

dim(t.up)
dim(t.dn)

t.up.or=t.up[order(t.up$fc, decreasing = T),]
head(t.up.or)
t.dn.or=t.dn[order(t.dn$fc, decreasing = T),]
head(t.dn.or)


##############################
#GO Term 
##############################
install.packages("gProfileR")
library("gProfileR")

sigList=list(up=rownames(t.up.or), dn=rownames(t.dn.or))
sapply(sigList, length)

gProfile.List=lapply(sigList, function(sig) gprofiler(sig, src_filter = "GO:BP"))
sapply(gProfile.List, nrow)

go.d=gProfile.List$dn
dim(go.d)
go.d=go.d[order(go.d$p.value, decreasing = F),][1:10,]
head(go.d)

go.u=gProfile.List$up
dim(go.u)
go.u=go.u[order(go.u$p.value, decreasing = F),][1:10,]
head(go.u)

go.score=data.frame(goTerm=go.d$term.name, score=log10(go.d$p.value))
go.score$goTerm=factor(as.character(go.score$goTerm), levels=as.character(go.score$goTerm))
go.dn.df=go.score

go.score=data.frame(goTerm=go.u$term.name, score=-log10(go.u$p.value))
go.score$goTerm=factor(as.character(go.score$goTerm), levels=as.character(go.score$goTerm))
go.up.df=go.score

df=rbind(data.frame(go.dn.df, type="down"), data.frame(go.up.df, type="up"))
df=df[order(df$score),]
df$goTerm=factor(as.character(df$goTerm), levels = as.character(df$goTerm))

col.set=c("deepskyblue3", "pink")
col=c(rep(col.set[1],10),rep(col.set[2],10))
par(mar=c(4,20,3,1));barplot(as.numeric(df$score), font=2, horiz=T, las=2, col=col, names.arg=df$goTerm);abline(v=0)
legend("topleft", c("T_DN", "T_UP"), cex=1, bty = "n", fill=c("deepskyblue3", "pink"), text.font=2)
