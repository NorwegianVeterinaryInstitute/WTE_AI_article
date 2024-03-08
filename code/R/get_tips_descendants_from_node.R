#' get_tips_descendants_from_node
#' Helper function for tree manipulation.
#' Get the labels of tips (not nodes) descendants from a given node number in a tree.
#'
#' @param tree The input tree object.
#' @param node_number The number of the node from which to retrieve the tips descendants.
#' @return A character vector containing the labels of the tips descendants from a node number.
#' @examples
#'
#' # Get the tips descendants from node number 5
#' tips_descendants <- get_tips_descendants_from_node(tree, 5)
#' @export
get_tips_descendants_from_node <- function(tree, node_number) {
  all_descendants <- get_descendants_from_node(tree, node_number = node_number)
  all_descendants[all_descendants %in% tree$tip.label]
}