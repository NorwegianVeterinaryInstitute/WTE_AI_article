#' Create a simple plot with bootstrap values and labeled nodes (HELPER)
#'
#' This function takes a tree object and creates a simple plot where nodes are labeled and bootstrap values are added to the plot data.
#'
#' @param tree A phylogenetic tree object.
#' @param ... Additional arguments to be passed to the ggtree::ggtree function.
#'
#' @return A ggtree plot object with updated plot data including node depth and bootstrap labels.
#'
#' @examples
#' tree <- read.tree("tree.nwk")
#' test_list <- create_simple_plot_boostrap_lab_fun(rooted_tree)
#' test_list$simple_plot is the plot
#' test_list$tree_nodelab is the tree with named nodes labels
#'
#' @import ggtree
#' @import dplyr
#' @importFrom ggtree ggtree
#' @importFrom dplyr left_join
#'
#' @export
create_simple_plot_boostrap_lab_fun <- function(tree, ...) {
  ## create bootstrap field  and names for nodes
  message("Creating bootstrap field and names for nodes")
  # create the list incl. the modified tree with node labels instead of boostrap
  # incl. creation of labels_nodelabs and labels_bootstrap
  tree_nodelab_list <- nodelabels_bootstrap_depth_df(tree)
  # df correspondance labels_nodelabs, labels_bootstrap and node_depth
  tree_nodelab_df <- tree_nodelab_list$df_match_bootstraps_named_nodes
  # the phylo object - with labelled nodes
  tree_nodelab <- tree_nodelab_list$tree_named_nodes


  # create a simple plot to get the plot_tree$data
  message("creating a simple plot")
  simple_plot <- ggtree::ggtree(tree_nodelab, ...)

  # updating the plot data (node_depth, and labels_boostrap)
  message("merging bootstrap to plot data")
  simple_plot$data <-
    simple_plot$data %>%
    left_join(tree_nodelab_df, by = c("label" = "labels_nodelabs"))

  # plot with updated plot_data and the tree with node_labels and set in a list
  message("results are a list of a simple_plot and a tree with labelled nodes")
  results <- list(simple_plot, tree_nodelab)
  names(results) <- c("simple_plot", "tree_nodelab")
  return(results)
}