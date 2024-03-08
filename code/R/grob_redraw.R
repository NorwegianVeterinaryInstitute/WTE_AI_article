#' Readjust the pannels from the ggtree plot and reexport as ggplot object
#' 
#' @param plot_object a ggtree plot object  panneled 
#' @param width_mult a vector of values to multiply the original width of each panel. 
#' Note that the tree counts as a pannel. 

grop_redraw <- function(plot_object, width_mult = c(1, .4, .4, .1)) {

  # transforms into a grob 
  gp <- ggplot2::ggplotGrob(plot_object)
  facet.columns <- gp$layout$l[grepl("panel", gp$layout$name)]


  # nb of panels/facets - first is the tree
  # now we multiply the width to rearrange their size 
  gp$widths[facet.columns] <- gp$widths[facet.columns] * width_mult
  # retransforms to a ggplot object
  ggplotify::as.ggplot(gp)
}
