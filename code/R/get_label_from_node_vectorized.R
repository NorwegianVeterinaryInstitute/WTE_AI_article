#' Vectorized version of get_label_from_node function
#'
#' This function vectorizes the get_label_from_node function, allowing it to accept
#' a vector of node numbers as input and return a vector of corresponding labels.
#'
#' @param node_number A vector of node numbers.
#'
#' @return A vector of node labels corresponding to the input node numbers.
#'
#' @export
get_label_from_node_vectorized <-
  Vectorize(get_label_from_node, vectorize.args = "node_number")
