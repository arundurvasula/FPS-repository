#!/bin/bash
sample=$1
echo '################################'
echo '### Running BLAST on '$sample' ###'
echo '################################'
cores=(`nproc`)
pyfasta split -n $cores $sample

## need to figure out how to find only split fastas.
contigs=(`find ./P3-CLC-contigs.*.fa -type f`)
for file in ${contigs[@]}
do
    filename=${file##*/}
    time blastx -db nr -query $file -evalue 10 -matrix 'BLOSUM62' -word_size 3 -gapopen 11 -gapextend 1 -max_target_seqs 3 -outfmt "10 qseqid qlen sseqid evalue bitscore sskingdoms stitle sblastnames salltitles scomnames sscblyinames" -out ./$filename-blast.csv -num_threads 2 -seg "yes" &
done
wait
cat ./P3-CLC-contigs.??.fa-blast.csv > ./CLC-blast.csv
