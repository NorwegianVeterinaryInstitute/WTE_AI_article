#' Creates a dataframe from the file containing a list of duplicates
#'
#' `create_duplicates_df` reads a file containing a list of duplicates, as produced by seqkit,
#' and creates a dataframe with information about the duplicates. The file should be in
#' tab-separated values (TSV) format with two columns: "ndub" and "duplicates". The "ndub"
#' column represents the representative sequence used in the tree, and the "duplicates"
#' column contains the comma-separated list of duplicate sequences.
#'
#' @param file The path to the file containing the list of duplicates.
#' 
#' @return A dataframe with information about the duplicates, including the label of each
#'         duplicate, the duplicate group it belongs to, the position of the duplicate
#'         within the group, the count of duplicates in the group, and the label of the
#'         representative sequence.
#'         
#' @importFrom dplyr select pull rename mutate add_count first
#' @importFrom rlist list.map
#' @importFrom readr read_tsv
#' @importFrom stringr str_split str_remove_all
#' @importFrom tibble tibble rowid_to_column
#' @examples
#' create_duplicates_df("path/to/duplicates.tsv")
#' @export
create_duplicates_df <- function(file) {

  # read as table
  readr::read_tsv(file, col_names = c("ndub", "duplicates")) %>%
  # extract the column containing duplicates 
  # The first duplicates is the representative sequence used in the tree
  dplyr::select(duplicates) %>%
  dplyr::pull() %>%
  # transforming to list
  base::as.list() %>%
  stringr::str_split(., ", ") %>%
  # using rlist to create a dataframe for each element of the list 
  rlist::list.map(.,
         tibble::tibble("label" =
                          stringr::str_remove_all(., ".*\\|"), "dupgrp" = .i) %>%
           tibble::rowid_to_column(., "duppos") %>%
           dplyr::add_count() %>%
  # require an intermediary temp
           dplyr::mutate(representative_label = dplyr::first(label))
         ) %>%
  # creating the dataframe 
  base::do.call("rbind", .) %>%
  # represented_tips_by_label replace represented tips by tips 
  dplyr::rename(represented_seq_label = label,
                label = representative_label,
                nb_represented_sequences = n)
}

#nb_represented_sequences replaces nb_representated_sequences
