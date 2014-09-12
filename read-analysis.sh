#!/bin/bash
# Documentation:
# use: read-analysis.sh <reads.fastq> <host.fa>

reads=$1
host=$2

temp_sample=${reads##*/}
sample=${temp_sample%%.*}

#make directory and move into it
tot_reads=$(zcat $reads | echo $((`wc -l`/4)))
num_dupe=$(dedupe.sh in=$reads |& grep "Duplicates" | cut -f 2 | cut -d " " -f 1)
num_uniq=$(echo "$tot_reads - $num_dupe" | bc -l)
perc_uniq=$(echo "$num_uniq / $tot_reads * 100" | bc -l)

# need to parse out blahblahblah
mkdir $sample
cp $host $sample
bwa index -a bwtsw $host
bwa bwasw -t 16 $host $reads > $sample/$sample.sam
num_mapped=$(samtools view -Sc -F 4 $sample/$sample.sam)
perc_mapped=$(echo "$num_mapped / $tot_reads * 100" | bc -l)


echo -e $tot_reads"\t"$num_uniq"\t"$perc_uniq"\t"$num_mapped"\t"$perc_mapped
