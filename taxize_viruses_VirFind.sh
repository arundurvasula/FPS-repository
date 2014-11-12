#!/bin/bash
# Documentation:
# use: taxize_viruses.sh <blast.csv> <contigs.fa> <blast description column number>

#set -e
#set -u

blast=$1
contigs=$2
desc_col=$3

echo '##################################################'
echo '### Getting taxonomy information for '$blast' ###'
echo '##################################################'

# create directory for all the new files
mkdir ./$blast.tax
cp $blast ./$blast.tax
cd ./$blast.tax

#grab only raw file name
temp_blast=${blast##*/}
blast_no_file_ending=${temp_blast%%.*}
clean_output=$blast_no_file_ending-clean.tsv
awk -F"\t" -v desc_col=$desc_col '{print $1"\t"$desc_col}' $blast | tr -d \" > $clean_output
awk -F"\t" '$1 !~ /CONTIG/ {print $0}' $clean_output > $clean_output.2
taxize-VirFind.r $clean_output.2 ../$contigs
cp $clean_output.2* ../
