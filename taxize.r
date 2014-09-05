#!/usr/bin/env Rscript
#This script will get the family names for all species in the 3rd column of a file
# use like cat ../results/P3/blast/P3-clean-blast.csv | ./taxize.r ../results/P3/blast/P3-virus-summary
# You need to provide a file name as an argument to the script
# You also might need to chmod +x the file
require("taxize")
require("ggplot2")
require("seqinr")

ca <- commandArgs(trailingOnly=TRUE)

blast <- read.table(file=ca[1], sep=",", header=FALSE, fill=FALSE, quote="")
contig.file <- read.fasta(file=ca[2])

blast$V2 <- gsub(".*\\[(.*)\\].*", "\\1", blast$V2)
blast.virus = subset(blast, grepl("virus", V2))

blast.virus$V1 <- gsub(" ","_", blast.virus$V1)
lengths <- getLength(contig.file[blast.virus$V1])
blast.virus["lengths"] <- lengths
sequence <- getSequence(contig.file[blast.virus$V1], as.string=TRUE)
blast.virus["sequence"] <- unlist(sequence)

families <- tax_name(query=blast.virus$V2,get='family', db='ncbi')
blast.virus["families"] <- families

write.table(blast.virus[c("V1", "lengths", "V2", "families", "sequence")], file=paste(ca[1], "-families.csv", sep=""), row.names=FALSE, sep=",", col.names=c("Contig name", "Length", "Virus name", "Virus family", "Sequence"))
png(file=paste(ca[1],"-graph", sep=""), width=1000, height=500)

vir.families <- table(blast.virus$families)
df.vir.families <- data.frame(vir.families)
if (length(df.vir.families$Var1) > 7) { # if there are more than 7 families
  df.vir.families <- subset(df.vir.families, Freq > 5)
}
ggplot(df.vir.families, aes(x=Var1, y=Freq, fill=Var1, title="Virus Families")) + labs(x="Family", y="Number of contigs", fill="Families") + geom_bar(stat="identity", xlab="Families", ylab="Number of contigs")

dev.off()