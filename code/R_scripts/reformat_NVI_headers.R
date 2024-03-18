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
# test_dir <- "/mnt/2T/Insync/ONEDRIVE/REINSTALLED/projects_vault/Projects/2023/1_AvianInfluenza/12302_Avian_influenza_2023/data/artic_consensus/H5N1"
# opt <- list(
#   sample = paste(test_dir, "Consensus_2022_07_1486_2.fasta", sep = "/"),
#   strain = "H5N1",
#   outdir = paste(test_dir, "reformated", sep = "/")
# )

# Script 
sample_id <- basename(opt$sample) %>%
  str_remove_all("(Consensus_)|(.fasta)")

sample_fasta <- seqinr::read.fasta(opt$sample, as.string = F)

# Format must be: `Isolate name | Segment | Isolate ID`  
# for our samples I do not have isolate name - so put isolateName_Strain instead
# seqinr::getAnnot(sample_fasta[[1]])
new_names <- 
tibble("old_names" = names(sample_fasta)) %>%
  mutate(segment = case_when(
    old_names == "1" ~ "PB2",
    old_names == "2" ~ "PB1",
    old_names == "3" ~ "PA",
    old_names == "4" ~ "HA",
    old_names == "5" ~ "NP",
    old_names == "6" ~ "NA",
    old_names == "7" ~ "MP",
    old_names == "8" ~ "NS",
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
