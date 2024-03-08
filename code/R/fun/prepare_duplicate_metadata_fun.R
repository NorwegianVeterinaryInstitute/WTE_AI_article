#' prepare_duplicate_metadata_fun 
#' 
#' HELPER 
#' Simple wrapper to allow preparation of metadata formating, that contains information for duplicates
#' @param tree a phylo object
#' @param metadata the original metadata
#' @param dup_file the file path that contains duplicated sequences as identified by seqkit
#' 
#' Note: that this structure will have to be kept when collapsing both duplicates files and nodes information later on

prepare_duplicate_metadata_fun <- function(tree, metadata, dup_file) {

  duplicates <- read_tsv(dub_file, col_names = c("ndub", "duplicates"))

  # creating a data frame from the tsv file 
  duplicates_df <-
    duplicates %>%
    select(duplicates) %>%
    pull() %>%
    as.list() %>%
    str_split(., ", ") %>%
    rlist::list.map(
      .,
      tibble::tibble("label" = str_remove_all(., ".*\\|"), "dupgrp" = .i) %>%
        tibble::rowid_to_column(., "duppos") %>%
        dplyr::add_count() %>%
        dplyr::mutate(representative_label = first(label))
    ) %>%
    do.call("rbind", .) %>%
    dplyr::rename(
      represented_seq_label
 = label,
      label = representative_label,
      nb_represented_sequences = n
    )

  # associated metadata to the tree - including duplicates 
  tree_meta_incl_duplicates <-
    tibble::tibble("label" = tree$tip.label) %>%
  # joining
  dplyr::left_join(duplicates_df) %>%
  # arranging
  dplyr::arrange(dupgrp, duppos) %>%
  # adding data for non duplicates - so we can merge all data
  # dplyr::filter(is.na(duppos)) %>%
  dplyr::mutate(
      duppos = if_else(is.na(duppos), 0, duppos),
      dupgrp = if_else(is.na(dupgrp), 0, dupgrp),
      represented_seq_label
 =
        if_else(is.na(represented_seq_label
  ), label,
          represented_seq_label

        ),
      nb_represented_sequences =
        if_else(is.na(nb_represented_sequences), 1,
          nb_represented_sequences
        ),
    ) %>%
  # getting metadata for the tips that are duplicated and non duplicated 
  dplyr::left_join(metadata, c("represented_seq_label
" = "label"))

}