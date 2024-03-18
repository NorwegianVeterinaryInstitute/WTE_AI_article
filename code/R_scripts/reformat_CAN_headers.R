#!/usr/bin/env Rscript
# This script is used to extract segments from NVI consensus files insaflu 
# from cath naming 
# renaming segt_isolate.fasta 

require(optparse) 
library(tidyverse)
library(seqinr)

option_list = list(
  make_option("--sample", action = "store", 
              type = 'character',
              help = "sample to extract segments from"),
  make_option("--strain", action = "store", 
              type = 'character',
              help = "H5N1 osv ... to help rename headers"),
  make_option("--outdir", action = "store", 
              type = 'character',
              help = "directory where to output the segment files")
  
)

opt = parse_args(OptionParser(option_list = option_list))

# Test 
# test_dir <- "/mnt/2T/Insync/ONEDRIVE/REINSTALLED/projects_vault/Projects/2023/1_AvianInfluenza/12302_Avian_influenza_2023/data/sea_eagle_consensus/data_canadian"
# opt <- list(
#   sample = paste(test_dir, "sanitized/WIN-AH-2023-FAV-0035-6.fasta", sep = "/"),
#   strain = "H5N5",
#   outdir = paste(test_dir, "reformated", sep = "/")
#)

# Script 
sample_id <- basename(opt$sample) %>%
  str_remove_all("(Consensus_)|(.fasta)")

sample_fasta <- seqinr::read.fasta(opt$sample, as.string = F)

new_names <- 
tibble("old_names" = names(sample_fasta)) %>%
  rowwise() %>%
  mutate(segment = case_when(
    str_detect(old_names, "_PB2") ~ "PB2",
    str_detect(old_names, "_PB1") ~ "PB1",
    str_detect(old_names, "_PA") ~ "PA",
    str_detect(old_names, "_HA") ~ "HA",
    str_detect(old_names, "_NP") ~ "NP",
    str_detect(old_names, "_NA") ~ "NA",
    str_detect(old_names, "_M") ~ "MP",
    str_detect(old_names, "_NS") ~ "NS",
    TRUE ~ "error_name_segt"
  )) %>% 
  mutate(strain = opt$strain, 
         new_name = str_c(sample_id, "_", strain, "|", segment, "|", sample_id, sep = ""))
  
# check order kept - yes
# sum(new_names$old_names != names(sample_fasta))


write.fasta(sequences = sample_fasta,
            names = new_names$new_name,
            file.out = paste0(opt$outdir,"/", sample_id, ".fasta"), 
            open = "w")
