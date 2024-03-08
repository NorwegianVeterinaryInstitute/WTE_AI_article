#' nodelabels_bootstrap_depth_df
#'
#' Helper function for tree manipulation.
#' Adds node labels if they do not exist in the tree.
#' Bootstraps values that were stored in labels are shifted to own column.
#' Calculates the depth of each node.
#' Returns a tibble with the bootstraps, old labels,
#' and node depths.
#'
#' @param tree A phylo object representing the tree
#' @param method An integer specifying the method for calculating node depth (default = 1)
#' @prefix A character string specifying the prefix to use for the node labels (default = "N").
#' Do not recommending changing the default value (for now used as such in other functions).
#' @return A list containing the original tree: The original tree, the tree with named nodes, and the
#'         tibble with columns: bootstraps, previous labels: old labels, and node depths
#' @examples
#' tree <- read.tree("tree.nwk")
#' result <- nodelabels_bootstrap_depth_df(tree)
#' print(result$df_match_bootstraps_named_nodes)
#' @require(ape)
nodelabels_bootstrap_depth_df <- function(tree, method = 1, prefix = "N") {
  labelled_tree <- ape::makeNodeLabel(tree, prefix = prefix)

  df <-
    tibble(
      "labels_bootstrap" = c(tree$tip.label, tree$node.label),
      "labels_nodelabs" = c(labelled_tree$tip.label, labelled_tree$node.label),
      "node_depth" = ape::node.depth(tree, method = 1)
    )

  return(list(
    "tree_original" = tree,
    "tree_named_nodes" = labelled_tree,
    "df_match_bootstraps_named_nodes" = df
  ))
}