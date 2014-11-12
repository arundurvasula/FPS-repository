#!/usr/bin/env Rscript
#This script will get the family names for all species in the 3rd column of a file
# use like cat ../results/P3/blast/P3-clean-blast.csv | ./taxize.r ../results/P3/blast/P3-virus-summary
# You need to provide a file name as an argument to the script
# You also might need to chmod +x the file
require("taxize")
require("ggplot2")
require("seqinr")

ca <- commandArgs(trailingOnly=TRUE)

blast <- read.table(file=ca[1], sep="\t", header=TRUE, fill=TRUE, quote="")
contig.file <- read.fasta(file=ca[2])

blast$All.subject.Seq.id.s. <- gsub(".*\\[(.*)\\].*", "\\1", blast$All.subject.Seq.id.s.)
blast.virus = subset(blast, grepl("VIRUS", All.subject.Seq.id.s.))

blast.virus$All.subject.Seq.id.s. <- gsub(" ","_", blast.virus$All.subject.Seq.id.s.)
l <- as.character(blast.virus$Query.Seq.id)
lengths <- list()
sequence <- list()
for (i in 1:length(blast.virus$Query.Seq.id)) 
{
  tryCatch({
    currpos <- l[i]
    len <- getLength(contig.file[currpos])
    seq <- getSequence(contig.file[currpos], as.string=TRUE)
    currpos.fist.letter <- substring(currpos, 1, 1)
    #if(currpos.first.letter != "N")
    #{
    #  len <- 0
    #  seq <- "NA"
    #}
    lengths<- append(lengths, len)
    sequence <- append(sequence, seq)
  }, error=function(e) {cat("ERROR :",conditionMessage(e), currpos, "\n continuing anyway... \n")})
}


#lengths <- getLength(contig.file[blast.virus$Query.Seq.id])
blast.virus["lengths"] <- unlist(lengths)
#sequence <- getSequence(contig.file[blast.virus$Query.Seq.id], as.string=TRUE)
blast.virus["sequence"] <- unlist(sequence)

families <- tax_name(query=blast.virus$All.subject.Seq.id.s.,get='family', db='ncbi')
blast.virus["families"] <- families

write.table(blast.virus[c("Query.Seq.id", "lengths", "All.subject.Seq.id.s.", "families", "sequence")], file=paste(ca[1], "-families.tsv", sep=""), row.names=FALSE, sep="\t", col.names=c("Contig name", "Length", "Virus name", "Virus family", "Sequence"))
png(file=paste(ca[1],"-graph.png", sep=""), width=1000, height=500)

vir.families <- table(blast.virus$families)
df.vir.families <- data.frame(vir.families)
if (length(df.vir.families$Var1) > 10) { # if there are more than 7 families
  df.vir.families <- subset(df.vir.families, Freq > 5)
}
ggplot(df.vir.families, aes(x=Var1, y=Freq, fill=Var1, title="Virus Families")) + labs(x="Family", y="Number of contigs", fill="Families") + geom_bar(stat="identity", xlab="Families", ylab="Number of contigs")

dev.off()