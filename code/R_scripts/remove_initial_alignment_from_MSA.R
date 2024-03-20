#!/usr/bin/env Rscript
# This script is used to extract segments from NVI consensus files insaflu 
# from cath naming 
# renaming segt_isolate.fasta 

require(optparse) 
library(tidyverse)
library(seqinr)

option_list = list(
  make_option("--msa", action = "store", 
              type = 'character',
              help = "alignment, fasta"),
  make_option("--outname", action = "store", 
              type = 'character',
              help = "name for output incl, .fasta extension"),
  make_option("--outdir", action = "store", 
              type = 'character',
              help = "name of output directory")
  
)

opt = parse_args(OptionParser(option_list = option_list))

# Test 
# 
# opt <- list(
#     msa = "/mnt/2T/Insync/ONEDRIVE/REINSTALLED/projects_vault/Projects/2023/1_AvianInfluenza/12302_Avian_influenza_2023/data/sea_eagle_consensus/final_dataset_prep/HA/H5N1/msa/SEP_HA_H5N1_MSA0.fasta",
#     outname = "SEP_HA_H5N1_MSA_maxdata.fasta",
#     outdir = "/mnt/2T/Insync/ONEDRIVE/REINSTALLED/projects_vault/Projects/2023/1_AvianInfluenza/12302_Avian_influenza_2023/data/sea_eagle_consensus/final_dataset_prep/HA/H5N1/msa"
#     )

# Script 
# checked ok gaps preserved
msa <- seqinr::read.fasta(opt$msa, as.string = F)
outfile <- paste(opt$outdir, opt$outname, sep = "/")

# if file exist removes it  - otherwise will append on it
if (file.exists(outfile)) {file.remove(outfile)}

# now creating the filtering of the input
seq_names <- names(msa)

# I had added initial_alignment@ to the sequences of initial alignment to be able to filter-out
# but seems sequence cropped at separator ... 
for (i in seq_along(seq_names)) {
  
  if (!stringr::str_detect(seq_names[i], "initial")) {
    write.fasta(sequences = msa[i],
                names = seq_names[i],
                file.out = outfile, 
                open = "a")
  }
}

