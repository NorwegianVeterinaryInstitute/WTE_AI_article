#' get_label_from_node
#' Helper for tree manipulation: get the node label from a given node number.
#'
#' @param tree A phylo object with node labels.
#' @param node_number The node number for which to retrieve the label.
#'
#' @return The label of the specified node.
#'
#' @examples
#' tree <- read.tree("tree.nwk")
#' get_label_from_node(tree, 5)
#'
#' @return The node label corresponding to the given node number.
get_label_from_node <- function(tree, node_number) {
  tree %>%
    as_tibble() %>%
    filter(node == as.integer(node_number)) %>%
    select(label) %>%
    pull()
}
