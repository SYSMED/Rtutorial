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
