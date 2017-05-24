Rtutorial_week4
========================================================
author: Ji-Hye Choi
date: 2017.05.24
width: 2000

<style>

/* slide titles */
.reveal h3 { 
  font-size: 70px;
}

/* heading for slides with two hashes ## */
.reveal .slides section .slideContent h2 {
   font-size: 50px;
   font-weight: bold;
}

/* ordered and unordered list styles */
.reveal ul, .reveal ol { font-size: 50px; }

</style>



Today
========================================================

* Genomic Ranges
  + IRanges
  + GRanges
  + BSgenome
  + Biostrings
  
* ggplot
* RMarkdown

https://www.rstudio.com/resources/cheatsheets/


IRanges
========================================================
Infrastructure for manipulating intervals


```r
library(IRanges)
ir1 <- IRanges(start = c(1,3,5), end = c(3,5,7))
ir1
```

```
IRanges object with 3 ranges and 0 metadata columns:
          start       end     width
      <integer> <integer> <integer>
  [1]         1         3         3
  [2]         3         5         3
  [3]         5         7         3
```

GRanges
========================================================
like IRanges but with strand, chromosome (seqnames), metadata


```r
library(GenomicRanges)
gr <- GRanges(seqnames = "chr1", strand = c("+", "-", "+"), ranges = ir1)
values(gr) <- DataFrame(score = c(0.1, 0.5, 0.3))
gr
```

```
GRanges object with 3 ranges and 1 metadata column:
      seqnames    ranges strand |     score
         <Rle> <IRanges>  <Rle> | <numeric>
  [1]     chr1    [1, 3]      + |       0.1
  [2]     chr1    [3, 5]      - |       0.5
  [3]     chr1    [5, 7]      + |       0.3
  -------
  seqinfo: 1 sequence from an unspecified genome; no seqlengths
```

GRanges
========================================================

* Functions to get elements
  + start(), end(), width()
  + seqnames(), strand(), elementMetadata()



BSgenome (Biostrings-based genome data)
========================================================


```r
library(BSgenome.Hsapiens.UCSC.hg38)
BSgenome.Hsapiens.UCSC.hg38
```

```
Human genome:
# organism: Homo sapiens (Human)
# provider: UCSC
# provider version: hg38
# release date: Dec. 2013
# release name: Genome Reference Consortium GRCh38
# 455 sequences:
#   chr1                    chr2                    chr3                   
#   chr4                    chr5                    chr6                   
#   chr7                    chr8                    chr9                   
#   chr10                   chr11                   chr12                  
#   chr13                   chr14                   chr15                  
#   ...                     ...                     ...                    
#   chrUn_KI270744v1        chrUn_KI270745v1        chrUn_KI270746v1       
#   chrUn_KI270747v1        chrUn_KI270748v1        chrUn_KI270749v1       
#   chrUn_KI270750v1        chrUn_KI270751v1        chrUn_KI270752v1       
#   chrUn_KI270753v1        chrUn_KI270754v1        chrUn_KI270755v1       
#   chrUn_KI270756v1        chrUn_KI270757v1                               
# (use 'seqnames()' to see all the sequence names, use the '$' or '[['
# operator to access a given sequence)
```



========================================================
* ExpressionSet to GRange


```r
data(fil.eset)
head(fData(fil.eset))

eset.gr=GRanges(seqnames = fData(fil.eset)$chr, strand = fData(fil.eset)$strand, ranges = IRanges(start = fData(fil.eset)$start, end = fData(fil.eset)$end, names = fData(fil.eset)$gene.name))

values(eset.gr)=DataFrame(gene.id=fData(fil.eset)$gene.id, fc=fData(fil.eset)$fc)
```

Biostrings
========================================================
* getSeq()
* complement(), reverseComplement(), subseq()
* alphabetFrequency(), letterFrequency()


```r
library(Biostrings)
seq=getSeq(BSgenome.Hsapiens.UCSC.hg38, eset.gr)
eset.gr$seq=seq
```

========================================================
* get GC%
* promoter sequence: promoter()
* write fasta : writeXStringSet()
* RWebLogo
* find overlapped region: findOverlap()


IRanges::findOverlaps()
========================================================
* Annotation regional infomation (gene, cytoband, ...)
* Frequently used to analysis other omics data (Copy-number, methylation, mutation, ... )


```r
query <- IRanges(c(1, 4, 9), c(5, 7, 10))
subject <- IRanges(c(2, 2, 10), c(2, 3, 12))

findOverlaps(query, subject)
```

```
Hits object with 3 hits and 0 metadata columns:
      queryHits subjectHits
      <integer>   <integer>
  [1]         1           2
  [2]         1           1
  [3]         3           3
  -------
  queryLength: 3 / subjectLength: 3
```

```r
findOverlaps(query, subject, select="first")
```

```
[1]  1 NA  3
```

```r
findOverlaps(query, subject, select="last")
```

```
[1]  2 NA  3
```


ggplot
========================================================
* geom_plot(), geom_bar()


R Markdown
========================================================
* http://
