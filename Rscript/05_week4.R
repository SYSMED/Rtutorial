

# IRanges
library(IRanges)
ir1 <- IRanges(start = c(1,3,5), end = c(3,5,7))
ir1

IRanges(start = c(1,3,5), width = 3)

names(ir1)=c("a","b","c")
ir1

# GRanges
library(GenomicRanges)
gr=GRanges(seqnames = "chr1", strand = c("+","+","-"), ranges = ir1)
values(gr)=DataFrame(score=1:3)
gr

as.character(seqnames(gr))
strand(gr)
start(gr)
end(gr)
width(gr)
gr$score


# ExpressionSet to GRange
data(fil.eset)
head(fData(fil.eset))
colnames(fData(fil.eset))
eset.gr=GRanges(seqnames = fData(fil.eset)$chr, strand = fData(fil.eset)$strand, ranges = IRanges(start = fData(fil.eset)$start, end = fData(fil.eset)$end, names = fData(fil.eset)$gene.name))

eset.gr



# Biostrings
# BSgenome.Hsapiens.UCSC.hg38
library(Biostrings)
library(BSgenome.Hsapiens.UCSC.hg38)
BSgenome.Hsapiens.UCSC.hg38

seq=getSeq(BSgenome.Hsapiens.UCSC.hg38, eset.gr)

as.character(seq[[1]])
eset.gr$seq=seq

#complement(), reverseComplement(), subseq(), alphabetFrequency(), letterFrequency()

complement(subseq(seq[[1]], 1, 10))
reverseComplement(subseq(seq[[1]], 1, 10))

alphabetFrequency(seq[[1]])
letterFrequency(seq[[1]], letters = c("A", "C"), as.prob = T)


# GC percent
GC_content <- letterFrequency(seq, letters = "CG", as.prob = T)
eset.gr$GCcont=GC_content
eset.gr

# promoter sequence
promoter.gr=promoters(eset.gr, upstream = 1000, downstream = 0)
args(promoters)
eset.gr[1]
promoter.gr[1]

promoter.seq=getSeq(BSgenome.Hsapiens.UCSC.hg38, promoter.gr)
eset.gr$promoter.seq=promoter.seq
eset.gr



# write .fasta
writeXStringSet(promoter.seq[1:10], filepath = "result/promoter.fastq")



# RWebLogo
library(RWebLogo)
weblogo(as.character(subseq(promoter.seq[1:10], 1, 20))
)
args(weblogo)




# findOverlaps
query <- IRanges(c(1, 4, 9), c(5, 7, 10))
subject <- IRanges(c(2, 2, 10), c(2, 3, 12))
query
subject

hits=findOverlaps(query, subject)
query[queryHits(hits)]
subject[subjectHits(hits)]

# Annotation cytoband to eset
data("ucsc.cytoband")
head(ucsc.cytoband)

cytoband.gr=GRanges(seqnames = ucsc.cytoband$chrom, ranges = IRanges(start = ucsc.cytoband$chromStart, end = ucsc.cytoband$chromEnd, names = ucsc.cytoband$name))


cytoband=names(cytoband.gr[findOverlaps(eset.gr, cytoband.gr, select = "first")])

eset.gr$cytoband = cytoband



# Copy number variation



# ggplot2
library(ggplot2)
data(iris)
head(iris)

ggplot(iris, aes(x = Sepal.Length, y = Sepal.Width))  + geom_point()
ggplot(iris, aes(Sepal.Length, Sepal.Width))  + geom_point(aes(colour = Species))
ggplot(iris, aes(Sepal.Length, Sepal.Width))  + geom_point(aes(colour = Species, size=Petal.Width))
ggplot(iris, aes(Sepal.Length, Sepal.Width))  + geom_point(aes(colour = Species, size=Petal.Width), alpha=0.7)

df <- data.frame(dose=c("D0.5", "D1", "D2"), len=c(4.2, 10, 29.5))

g=ggplot(data=df, aes(x=dose, y=len)) + geom_bar(stat="identity")+ coord_flip()+theme_minimal()
g

g=ggplot(data=df, aes(x=dose, y=len)) + geom_bar(stat="identity", fill="steelblue")
g
g+geom_text(aes(label=len), vjust=1.6, color="white", size=3.5)+ theme_minimal()

data(mtcars)
mtcars$cyl
ggplot(mtcars, aes(x=factor(cyl)))+ geom_bar(stat="count", width=0.7, fill="steelblue") + theme_minimal()

df=fData(fil.eset)
ggplot(df, aes(x=chr))+geom_bar(stat="count")

