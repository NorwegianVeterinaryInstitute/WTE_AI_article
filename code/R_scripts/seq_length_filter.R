#!/usr/bin/env Rscript
# filtering multifasta by length 
# ouput sequences that are shorter to lenght 

require(optparse) 
library(tidyverse)
library(seqinr)

option_list = list(
  make_option("--fasta", action = "store", 
              type = 'character',
              help = "references sequences for initial alignment"),
  make_option("--length", action = "store", 
              type = 'integer',
              help = "filter if shorter than this length")
)

opt = parse_args(OptionParser(option_list = option_list))

# Test 

# opt <- list(
#     fasta = "/mnt/2T/Insync/ONEDRIVE/REINSTALLED/projects_vault/Projects/2023/1_AvianInfluenza/12302_Avian_influenza_2023/data/sea_eagle_consensus/final_dataset_prep/HA/H5N1/filtering_gisaid1/HA_H5N1_GISAID_SEP_inframe.fasta",
#     length = 1700
#     )

# Script 
my_fasta <- seqinr::read.fasta(opt$fasta, as.string = F)


# new name 
new_fasta <- stringr::str_remove(basename(opt$fasta), ".fasta")
path_fasta <- stringr::str_remove(file.path(opt$fasta), basename(opt$fasta))
new_fasta_name <- paste0(path_fasta, new_fasta, "_length_filtered.fasta")

# if file exist removes it  - otherwise will append on it
if (file.exists(new_fasta_name)) {file.remove(new_fasta_name)}


# now creating the filtering of the input
mylen <- 0 # just to be sure 

for (i in seq_along(my_fasta)) {
  
  mylen <- getLength(my_fasta[i])
  
  if (mylen >= opt$length) {
    write.fasta(sequences = my_fasta[i],
                names = names(my_fasta)[i],
                file.out = new_fasta_name, 
                open = "a")
  }
}

