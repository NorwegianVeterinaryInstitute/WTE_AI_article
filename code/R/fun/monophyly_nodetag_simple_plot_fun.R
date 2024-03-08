#' Create a simple plot of a phylogenetic tree and tag monophyletic groups
#'
#' This function creates a simple plot of a phylogenetic tree and tags the monophyletic groups on the plot. 
#' It is a wrapper function that combines the functionality of two other functions: 
#' `create_simple_plot_boostrap_lab_fun()` and `update_plot_data_monophyletic_nodes()`.
#'
#' @param tree A phylo object representing the phylogenetic tree.
#' @param bootstrap_threshold The minimal value of bootstrap support at which a branch is considered significant. Default is 95.
#' @param ... Additional arguments to be passed to the `ggtree::ggtree()` function.
#'
#' @return A list containing the simple plot and the tree with added node labels.
#' @details The simple plot is stored in the list element named "simple_plot", and the tree with added node labels is stored in the list element named "trees_nodeslab".
#' @examples
#' # Load required packages
#' library(ggtree)
#'
#' # Create a phylogenetic tree object
#' tree <- read.tree("tree.nwk")
#'
#' # Create the simple plot with tagged monophyletic groups
#' result <- monophyly_nodetag_simple_plot_fun(tree)
#' 
#' # Access the simple plot
#' simple_plot <- result$simple_plot
#'
#' # Access the tree with added node labels
#' tree_nodeslab <- result$trees_nodeslab
#'
#' @import ggtree
#' @export
monophyly_nodetag_simple_plot_fun <- function(tree, bootstrap_threshold = 95, ...) {

  plot_tree_list <- create_simple_plot_boostrap_lab_fun(tree, ...)

  # This is the simple plot - step 1
  the_simple_plot <- plot_tree_list$simple_plot

  # This is the updated plot data - step 2
  the_simple_plot$data <- update_plot_data_monophyletic_nodes(
    the_simple_plot$data, 
    plot_tree_list$tree_nodelab,
    bootstrap_threshold = bootstrap_threshold
  )

  # return the plot with the updated metadata
  message("Returning the plot with the updated metadata. The tree with added node labels is in .$trees_nodeslab, and the simple plot is in .$simple_plot")
  return(list("simple_plot" = the_simple_plot, "tree_nodelab" = plot_tree_list$tree_nodelab))

}