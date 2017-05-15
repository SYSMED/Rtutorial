############################################ 
# AJHCC_RNA_SEQ eset
############################################
#library
library("Biobase")

#1.Read cufflinks out files
getwd()
file.dir=file.path(getwd(), "result")
dir(file.dir)

cuff.dir=file.path(file.dir, "cufflinks")
fn.list=list.files(cuff.dir, "genes.fpkm_tracking", recursive = T, full.names = T)
cuff=lapply(fn.list, read.delim)
head(cuff[[1]])


#2.parsing ids
kid=unique(unlist(lapply(cuff, function(a) as.character(a$tracking_id))))
length(kid)#60468
head(kid)


#sub in r
x = "r tutorial"
y = sub("r ","HTML", x)
y

y = sub("t.*r","BBBBB", x) 
y


#3.parsing sample name
sample.name=as.character(sub(".*\\/", "", sub("/genes.fpkm_tracking", "", fn.list)))


#4.parsing fpkm status==ok
fpkm.ok=list()
for(i in 1:6){
  fpkm.ok[[i]]=cuff[[i]][which(cuff[[i]]$FPKM_status=="OK"), c(1,10)]
}
head(fpkm.ok[[1]])


expr=sapply(1:length(fpkm.ok), function(i) fpkm.ok[[i]][match(id, fpkm.ok[[i]]$tracking_id), "FPKM"])
colnames(expr)=sample.name
rownames(expr)=kid
head(expr)



#5.parsing fdata
gtf=read.delim(file.path(getwd(), "extdata/gtf.txt"))
head(gtf)

fdata=gtf[match(kid, gtf$gene.id),]
rownames(fdata)=kid
head(fdata)
featureData=AnnotatedDataFrame(data=fdata)


#6.parsing pdata
#Read file with clinical information
sample.info=read.delim(file.path(getwd(), "extdata/clinic_info.txt"))
head(sample.info)

pdata=sample.info[match(colnames(expr), sample.info$Sample_ID),]
rownames(pdata)=colnames(expr)
head(pdata)

phenoData=AnnotatedDataFrame(data=pdata)


#make eset
eset=ExpressionSet(as.matrix(expr), phenoData=phenoData, featureData=featureData)
eset
head(exprs(eset))


# remove ids with "0" value across all samples
cnt.zero=rowSums(exprs(eset), 1)
head(cnt.zero)
eset=eset[which(cnt.zero!=0),]
eset
head(exprs(eset))

save(eset, file=file.path(getwd(), "data/eset.rda"))
