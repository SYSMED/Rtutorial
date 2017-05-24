aggregate.eset=function(eset){
  # aggregation
  expr.agg=aggregate(exprs(eset), list(as.character(fData(eset)$gene.name)), mean)
  rownames(expr.agg)=expr.agg$Group.1
  expr.agg=expr.agg[,-1]
  
  fdat=AnnotatedDataFrame(fData(eset)[match(rownames(expr.agg), fData(eset)$gene.name),])
  rownames(fdat)=rownames(expr.agg)
  pdat=AnnotatedDataFrame(pData(eset))
  ExpressionSet(as.matrix(expr.agg), phenoData=pdat, featureData=fdat)
}


cbs2grList=function(cbsList, seg.col="seg.mean", chr.col="chrom", str.col="loc.start", end.col="loc.end", num_mark.col="num.mark", sample.col="ID"){
  
  cbs.grList = NULL
  
  for (i in 1:length(cbsList)) {
    cbs = cbsList[[i]]
    cbs = cbs[which(!is.na(cbs[,seg.col])),]
    seqnames = ifelse(grepl("chr", cbs[,chr.col]), cbs[,chr.col], paste0("chr", cbs[,chr.col]))
    
    gr = GRanges(seqnames = seqnames, ranges = IRanges(as.numeric(cbs[,str.col]),as.numeric(cbs[,end.col])), strand = NULL, num.mark = cbs[,num_mark.col], seg.mean = cbs[,seg.col])
    names(gr) = cbs[,sample.col]
    cbs.grList = c(cbs.grList, gr)
  }
  names(cbs.grList) = names(cbsList)
  cbs.grList
}