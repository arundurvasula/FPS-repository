#!/bin/bash
#assemble.sh <reads.fastq.gz>
set -u

reads=$1
temp_sample=${reads##*/}
sample_no_file_ending=${temp_sample%%.*}
trimmedreads=$sample_no_file_ending-trimmed.fastq.gz
qualreads=$sample_no_file_ending-qual.fastq


#trim adaptors with WGA adaptors
echo "Trimming adaptors with cutadapt using TNA adaptor sequences"
cutadapt -a AGATCGGAAGAGCACACGTC \
    -a AGATCGGAAGAGCGTCGTGT \
    -e 0.1 -O 5 -m 15 \
    -o $trimmedreads $reads

#remove low quality sequences using the defaults
echo "Removing low quality sequences with sickle"
sickle se -f $trimmedreads -t sanger -o $qualreads

#mkdir contigs-$sample_no_file_ending
echo '##########################'
echo '### Assembling '$reads' ###'
echo '##########################'
idba_ud -r $qualreads -o contigs-$sample_no_file_ending --mink 29 --maxk 49 --step 2
#cp contigs/contig.fa ./
