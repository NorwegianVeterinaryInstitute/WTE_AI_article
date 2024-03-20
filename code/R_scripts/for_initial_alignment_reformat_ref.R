#!/usr/bin/env Rscript
# This script is used to extract segments from NVI consensus files insaflu 
# from cath naming 
# renaming segt_isolate.fasta 

require(optparse) 
library(tidyverse)
library(seqinr)

option_list = list(
  make_option("--fasta", action = "store", 
              type = 'character',
              help = "references sequences for initial alignment"),
  make_option("--outname", action = "store", 
              type = 'character',
              help = "name for output incl, .fasta extension"),
  make_option("--outdir", action = "store", 
              type = 'character',
              help = "name of output directory")
  
)

opt = parse_args(OptionParser(option_list = option_list))

# Test 

# opt <- list(
#    fasta = "/mnt/2T/Insync/ONEDRIVE/REINSTALLED/projects_vault/Projects/2023/1_AvianInfluenza/12302_Avian_influenza_2023/data/GISAID_data/files/filtered_per_article/inframe_cropping/updated_references/HA_repr_ref_inframe_extended.fasta",
#    outname = "for_initial_MSA_HA_repr_ref_inframe_extended.fasta",
#    outdir = "/mnt/2T/Insync/ONEDRIVE/REINSTALLED/projects_vault/Projects/2023/1_AvianInfluenza/12302_Avian_influenza_2023/data/sea_eagle_consensus/final_dataset_prep/HA/H5N1"
#    )

# Script 
my_fasta_ref <- seqinr::read.fasta(opt$fasta, as.string = F)

new_names <- 
tibble("old_names" = names(my_fasta_ref)) %>%
  mutate(new_name = str_c("initial_alignment", old_names, sep = "@"))
         
  
write.fasta(sequences = my_fasta_ref,
            names = new_names$new_name,
            file.out = paste(opt$outdir, opt$outname, sep = "/"), 
            open = "w")
