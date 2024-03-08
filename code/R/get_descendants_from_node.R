#' get_descendants_from_node
#' Helper function for tree manipulation.
#' Get the labels of both tips and nodes descendants from
#'    a given node number in a phylogenetic tree.
#'
#' @param tree A phylogenetic tree object.
#' @param node_number The node number from which to retrieve the descendants.
#' @return A vector of labels that includes both tips and nodes descendants from the given node (number).
#' @examples
#' @export
#' @require(phytools)
get_descendants_from_node <- function(tree, node_number) {
  get_label_from_node_vectorized(
    tree,
    phytools::getDescendants(tree, node_number)
  )
}
