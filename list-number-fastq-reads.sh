#!/bin/bash
# count the number of reads and report the number of reads in each file in the directory
#use with [script-name] > out.txt
files=(`ls`)
for f in *.fastq.gz
do
    lines=(`wc -l $f`)
    reads=(`echo $((lines/4))`)
    echo $f"\t" $lines
done
