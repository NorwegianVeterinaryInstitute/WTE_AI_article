get_nodelabel_tips <- function(data_plot, node_label) {
  #' returns vector of tips descendants for a node label
  #' @param data_plot plot$data
  #' @param node_label the label of node, not node number
  #' Note: descendants_tips_from_node computed previously
  # get_nodelabel_tips(tp1$data, "N186")
  data_plot %>%
    filter(label == node_label) %>%
    select(descendants_tips_from_node) %>%
    pull() %>%
    unlist()
}