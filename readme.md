# FPS (Foundation Plant Services) repository
This repository contain scripts for analysis of Illumia data, including assembly, blast, and taxonomic identification

## Installation requirements
This repository's scripts assume that the following programs are installed and placed in the Unix path:

- NCBI's BLAST with the NR BLAST database
- IDBA_UD
- samtools
- bwa
- R (plus these packages)
    - taxize
    - ggplot2
    - seqinr
  
  
## General usage
This repository should be placed in the Unix path. Most scripts can be run using 

    <script.sh> <data.file>
  
Details of the input data are included at the beginning of each script. Scripts will create directories where they are run with the results of the analysis. For example, if I run `blastx.sh sample.001.fa` in my home directory, I will get a folder called `sample.001.fa.blast` in my home directory, containing all the results.

## Naming data and results
There is a naming scheme somewhere out there