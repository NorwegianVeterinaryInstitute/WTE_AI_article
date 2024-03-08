#' Update plot data for monophyletic nodes (HELPER)
#'
#' This function updates the plot data for monophyletic nodes in a tree plot.
#' It filters the tree plot data to get only nodes,
#' finds the monophyletic groups for each node,
#' checks if the groups are monophyletic with and without bootstrap support above a given threshold,
#' adds edge data for plotting, and returns updated tree plot data.
#'
#' @param plot_data The plot data containing the plot_data information as obtained from create_simple_plot_boostrap_lab_fun
#' @param plot_data The tree with labelled nodes, as obtained from create_simple_plot_boostrap_lab_fun
#' @param bootstrap_threshold The bootstrap threshold for determining monophyletic groups (default is 95).
#'
#' @importFrom dplyr mutate rowwise filter if_else
#' @importFrom ape is.monophyletic
#' @importFrom tibble tibble
#'
#' @return The updated plot data with additional information for monophyletic nodes.
#'
#' @examples
#' # Example usage
#' test_list <- create_simple_plot_boostrap_lab_fun(rooted_tree)
#' test_list$simple_plot is the plot
#' test_list$tree_nodelab is the tree with named nodes labels
#' 
#' @export
update_plot_data_monophyletic_nodes <- function(plot_data, tree_nodelab, bootstrap_threshold = 95) {
  # 1. Filtering tree plot$data to get only nodes
  message("filtering the tree plot data to get only nodes")
  simple_plot_nodes_df <-
    plot_data %>%
    dplyr::filter(!isTip)

  # 2. finding monophyletic groups for each nodes
  # 2.1 we need to get the tips descendants for each node (number)
  simple_plot_nodes_df <-
    simple_plot_nodes_df %>%
    dplyr::rowwise() %>%
    dplyr::mutate(
      descendants_tips_from_node =
        list(get_tips_descendants_from_node(tree_nodelab, node))
    )

  # 2.2 Check if groups are monophyletic (independent of bootstrap threshold)
  message("checking if groups are monophyletic - without bootstrap support")
  simple_plot_nodes_df <-
    simple_plot_nodes_df %>%
    dplyr::mutate(
      isMono_noboot =
        ape::is.monophyletic(tree_nodelab, unlist(descendants_tips_from_node))
    )

  # 2.3 Check that group is monophyletic (dependent on bootstrap)
  message("checking if groups are monophyletic - with bootstrap support")
  simple_plot_nodes_df <-
    simple_plot_nodes_df %>%
    dplyr::mutate(isMono = dplyr::if_else(
      as.numeric(labels_bootstrap) >= bootstrap_threshold & isMono_noboot, TRUE, FALSE
    ))

  # add edge data for plotting
  message("adding edge data for plotting")
  edge_df <- tibble::tibble(
    "parent" = tree_nodelab$edge[, 1],
    "node" = tree_nodelab$edge[, 2],
    "edge_num" = 1:nrow(tree_nodelab$edge)
  )

  # update and return plot_data
  message("updating tree plot data and output")
  plot_data %>%
    dplyr::left_join(simple_plot_nodes_df) %>%
    dplyr::left_join(edge_df)
}