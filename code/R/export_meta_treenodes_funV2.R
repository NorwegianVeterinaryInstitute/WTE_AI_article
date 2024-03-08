#' export_meta_treenodes_funV2.R
#' Modified according to the afterthoughts of collaborators
#' Function that wrangles the metadata for a tree using plot_data. Given a set of labels of tips and nodes, 
#' and all the represented tips for each set of labels, it join the metadata - unnests a set of selected
#' columns, removes columns that are not useful for display and export the wrangled metadata
#' as an excel file 
#' @param plot_data the plot data of a phylogenetic tree
#' @param metadata a metadata file containing labels to join to plot_data labels
#' @param col_rep_tips the column in the plot data that contains all the tips represented by labels (tips and nodes)
#' @param file xlsx file name - path for saving
#' @param sheet char sheet name - default is "labels_metadata"
#' @aram ... column names to select for metadata export (no quotes) 


export_meta_treenodes_funV2 <- function(plot_data, metadata, col_rep_tips, file, sheet,
                                        append = TRUE, ...) {
  # Formatting the table to export 
  df <-
    plot_data %>%
    filter(isTip) %>%
    dplyr::select(label, {{ col_rep_tips }}) %>%
    dplyr::rename(represented_label := {{ col_rep_tips }}) %>%
    tidyr::unnest(represented_label) %>%
    dplyr::left_join(metadata %>%
                       dplyr::distinct(), 
                     by = c("represented_label" = "label")) %>%
    dplyr::rename(tree_label = label) %>%
    # We need to add labels for the Nodes that were collapsed are are now tips
    dplyr::mutate(tree_label = 
                    ifelse(is.na(tree_label), 
                           link_label, 
                           tree_label)
    ) %>%
    # need to add Isolate ID here for afterthought and remove from the list
    dplyr::select(tree_label, represented_label, Isolate_Id, ...)
  
  # After thought !
  df <- 
    df %>%
    # represented isolates by their ID
    dplyr::rename(link_label = tree_label, 
                  represented_Id = Isolate_Id) %>%
    # Now we need to get the tree labels   
    # Its only at the nodes that the label should be kep as N
    dplyr::mutate(tree_label = 
                    ifelse(
                      startsWith(link_label, "N"), 
                      link_label,
                      represented_Id)
    ) %>%
    dplyr::select(-link_label, -represented_label) %>%
    dplyr::select(tree_label, represented_Id, everything()) %>%
    dplyr::distinct()
  


  # exporting the table
  xlsx::write.xlsx(as.data.frame(df),
                    file,
                    sheetName = sheet,
                    showNA = FALSE,
                    row.names = FALSE,
                    append = append)
  return(df)
}




