#' test_plot_fun
#'
#' This function generates a test plot for data exploration.
#' It takes a tree object, metadata, point color, and point shape as inputs.
#' The function plots the tree using ggtree package,
#' with a rectangular layout and ladderize option set to True.
#' It adds metadata to the plot and overlays point markers on the tips of the tree,
#' with color and shape specified by the input arguments.
#' The x and y axes are scaled using pretty breaks, and the plot is styled with the theme_linedraw.
#'
#' @param tree A tree object.
#' @param metadata A data frame containing metadata.
#' @param point_col A column name in the metadata data frame specifying the color of the point markers.
#' @param point_shape A column name in the metadata data frame specifying the shape of the point markers.
#'
#' @return A ggplot object representing the test plot.
#'
#' @import ggtree
#' @importFrom ggplot2 geom_tippoint scale_x_continuous scale_y_continuous theme_linedraw
#' @importFrom scales pretty_breaks
#'
#' @examples
#' tree <- read.tree("tree.nwk")
#' metadata <- read.csv("metadata.csv")
#' test_plot_fun(tree, metadata, "color", "shape")
#' @require(ggtree)
#' @require(ggplot2)
test_plot_fun <- function(tree, metadata, point_col, point_shape) {
  tree %>%
    ggtree::ggtree(.,
      layout = "rectangular", ladderize = TRUE,
      lwd = 0.1, color = "black"
    ) %<+%
    metadata +
    ggtree::geom_tippoint(aes(
      color = {{ point_col }},
      shape = {{ point_shape }}
    )) +
    ggplot2::scale_x_continuous(breaks = pretty_breaks(n = 10)) +
    ggplot2::scale_y_continuous(breaks = pretty_breaks(n = 10)) +
    ggplot2::theme_linedraw()
}