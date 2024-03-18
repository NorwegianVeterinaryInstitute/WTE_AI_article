#!/usr/bin/env Rscript
# This script is used to extract the queries cropped in frame from an query-references alignment obtained using vsearch
# vsearch is run on with an in-frame reference sequences dataset on a set of queries
# the optained alignment is cleaned by removing the sequences - to optain only the queries in frame


require(optparse) 
library(tidyverse)
library(seqinr)

option_list = list(
  make_option("--alignment", action = "store", 
              type = 'character',
              help = "pairwise alignment result from vsearch containing references and queries."),
  make_option("--output", action = "store", 
              type = 'character',
              help = "output file name of the inframe queries, fasta extension")
  
)

opt = parse_args(OptionParser(option_list = option_list))

# Test 
# test_dir <- "/mnt/2T/Insync/ONEDRIVE/REINSTALLED/projects_vault/Projects/2023/1_AvianInfluenza/12302_Avian_influenza_2023/analysis/method_development/vsearch_cropping_test"
# opt <- list(
#   alignment = paste(test_dir, "test_frame_cropping_fasta_pairs.aln.fasta", sep = "/"),
#   output = paste(test_dir, "HA_inframe_representative.fasta", sep = "/")
# )

# Script 
alignment <- seqinr::read.fasta(opt$alignment, as.string = F)

# the first one is always the query, and second one the reference  
seq_crop <- seq(1, length(alignment), by = 2)

write.fasta(sequences = alignment[seq_crop],
            names = names(alignment[seq_crop]),
            file.out = opt$output, 
            open = "w")
