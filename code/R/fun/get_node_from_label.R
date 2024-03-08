#' get_node_from_label
#'
#' Helper function for tree manipulation: get the node number from a node label.
#'
#' @param tree A phylo object with node labels.
#' @param node_label The node label from which we want to return the node number.
#'
#' @return The node number corresponding to the given node label.
#' @require(dplyr)
#' @require(ape)
#' @require(tibble)
get_node_from_label <- function(tree, node_label) {
  tree %>%
    tibble::as_tibble() %>%
    dplyr::filter(label %in% node_label) %>%
    dplyr::select(node) %>%
    dplyr::pull()
}
