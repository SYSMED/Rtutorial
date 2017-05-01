######################
#HCC EXPRESSION DATA
######################
library("Biobase")

file.dir="/data/Rpackage/Rtutorial/Rscript/example/file"
dir(file.dir)

#read data(expression, symbol_annotatation_data, clinical_info)
expr=read.delim(file.path(file.dir, "expression.txt"))
fdata=read.delim(file.path(file.dir, "annotation.txt"))
pdata=read.delim(file.path(file.dir, "clinical_info.txt"))

dim(expr)
dim(fdata)
dim(pdata)

head(expr)
head(fdata)
head(pdata)

#1. expression data 
head(expr)
ID=expr$ILMN_ID
length(ID)

expr=expr[-1]
dim(expr)
rownames(expr)=ID
head(expr)

sam.id=pdata$sample_id[match(colnames(expr), pdata$geo_accession)] 
colnames(expr)=sam.id
head(expr)


#2. annotation data 
fdata=fdata[match(ID, fdata$ID),]
rownames(fdata)=ID
head(fdata)
featureData=AnnotatedDataFrame(data=fdata)


#3. pheno data 
pdata=pdata[match(colnames(expr), pdata$sample_id),]
rownames(pdata)=colnames(expr)
head(pdata)

phenoData=AnnotatedDataFrame(data=pdata)

#eset
eset=ExpressionSet(as.matrix(expr), phenoData=phenoData, featureData=featureData)
eset

################
#preprocessing 
################
hist(exprs(eset), breaks=100)

#1. log2 trnasformation
exprs(eset)=apply(exprs(eset)+1, 2, log2)
hist(exprs(eset), breaks=100)
boxplot(exprs(eset))


#2. aggregation by Gene_Symbol
length(unique(fData(eset)$Gene_Symbol))
freq.dat=as.data.frame(table(fData(eset)$Gene_Symbol))

agg.expr=aggregate(exprs(eset), by=list(fData(eset)$Gene_Symbol), FUN=mean, na.rm=TRUE)
colnames(agg.expr)[1]="Symbol"

colnames(agg.expr)
head(agg.expr)


#2-1. agg.eset
id=agg.expr$Symbol
agg.expr=agg.expr[-1]
dim(agg.expr)
rownames(agg.expr)=id

agg.eset=ExpressionSet(as.matrix(agg.expr), phenoData=phenoData)


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
fil.expr=agcen.expr[which(mad>0.5),]
dim(fil.expr)

heatmap.2(fil.expr, col=redgreen(75), density.info="none", trace="none", symm=F, symkey=T, scale="none") 


#add column label
col.color=colnames(fil.expr)
col.color[grep("T", col.color)]="firebrick"
col.color[grep("N", col.color)]="dodgerblue"
table(col.color)
heatmap.2(fil.expr, col=redgreen(75), density.info="none", trace="none", symm=F, symkey=T, scale="none", ColSideColors = col.color) 


#change expression colors
my_palette <- colorRampPalette(c("gold1", "white", "dodgerblue"))(n = 999)
heatmap.2(fil.expr, col=my_palette, density.info="none", trace="none", symm=F, symkey=T, scale="none", ColSideColors = col.color) 


##############################
#diffentially expressed genes 
##############################
eset=agg.eset
t.id=sampleNames(eset)[grep("T", sampleNames(eset))]
n.id=sampleNames(eset)[grep("N", sampleNames(eset))]

fData(eset)$t.mean=rowMeans(exprs(eset[,t.id]))
fData(eset)$n.mean=rowMeans(exprs(eset[,n.id]))
fData(eset)$fc=fData(eset)$t.mean-fData(eset)$n.mean
fData(eset)$mad=apply(exprs(eset), 1, mad)

t.up=fData(eset)[which(fData(eset)$fc> 0.5 & fData(eset)$mad> 0.2),]
t.dn=fData(eset)[which(fData(eset)$fc< -0.5 & fData(eset)$mad> 0.2),]

head(t.up)
head(t.dn)

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
go.d=go.d[order(go.d$p.value, decreasing = F),][1:5,]
head(go.d)

go.u=gProfile.List$up
dim(go.u)
go.u=go.u[order(go.u$p.value, decreasing = F),][1:5,]
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
col=c(rep(col.set[1],5),rep(col.set[2],5))
par(mar=c(4,20,3,1));barplot(as.numeric(df$score), font=2, horiz=T, las=2, col=col, names.arg=df$goTerm);abline(v=0)
legend("topleft", c("T_DN", "T_UP"), cex=1, bty = "n", fill=c("deepskyblue3", "pink"), text.font=2)



