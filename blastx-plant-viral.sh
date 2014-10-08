#!/bin/bash
# Documentation:
# -blastx.sh <contigs.fa>

set -e
set -u
sample=$1
#cores=(`nproc`)
cores=8
pident_thresh=90
length_thresh=100
echo '################################'
echo '### Running BLAST on '$sample' ###'
echo '################################'

# create directory for all the new files
mkdir ./$sample.blast
cp $sample ./$sample.blast
cd ./$sample.blast

pyfasta split -n $cores $sample

#grab only raw file name
temp_sample=${sample##*/}
sample_no_file_ending=${temp_sample%%.*}

contigs=(`find ./$sample_no_file_ending.*.fa -type f`)

for file in ${contigs[@]}
do
    filename=${file##*/}
    time blastx -db nr -gilist green_plant.gi.txt -query $file -evalue 10 -matrix 'BLOSUM62' -word_size 3 -gapopen 11 -gapextend 1 -max_target_seqs 3 -outfmt "6 qseqid qlen sseqid evalue bitscore stitle pident length" -out ./$filename-blast.tsv -num_threads 2 -seg "yes" &
done
wait
cat ./$sample_no_file_ending.*.fa-blast.tsv > ./$sample-plant-blast.tsv

#get names of plant contigs
awk '$7 >= 90 && $8 >= 100 {print $1}' ./$sample-plant-blast.tsv > plant_contigs.txt
#get sequences of plant contigs
grep -A 1 "`cat plant_contigs.txt`" contig.fa > plant_contigs.fa
grep -v "`cat plant_contigs.fa`" contig.fa > non_plant_contigs.fa

blastx-viral.sh non_plant_contigs.fa
 
#cp $sample-blast.tsv ../
