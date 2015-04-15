#!/bin/bash
# this script counts the number of entries in a fasta file
#use [script-name] [fasta-file.fa]

grep -c "^>" $1
