#' collapsing_nodes_from_nodes_fun
#' Function to collapse nodes recursively using a named node label.
#' The function gets the tips descending for each node and then collapse
#' the tree. Does that for each node to collapse iteratively.
#' Note: Must replace collapsing_nodes_fun
#' 
#' Returns a tree with collapsed nodes.
#'
#' @param tree A tree with labelled nodes (named - not bootstraps).
#' @param nodes A vector of nodes to collapse. 
#' @param trim.internal Logical value indicating whether internal nodes should be trimmed after collapsing.
#' @param ... Additional arguments to be passed to 'ape::drop.tip'.
#' see ape::drop.tip for more details.
#'
#' @return The collapsed tree.

collapsing_nodes_from_nodes_fun <- function(tree, nodes, trim.internal = F, ...) {
  
  collapsed_tree <- tree
  
  # Try in case shallower nodes might already have been deleted
  message("recuring collapsing of nodes")
  
  # initiating to be sure 
  collapsed_tree <- tree 
  
  for (each_node in nodes) {
    # get the node number from node label
    node_nb <- get_node_from_label(tree = collapsed_tree, 
                                   node_label = each_node)
    
    # need to check if the node exists in the tree
    # Eg. if it already has been collapsed before it became a tip, not a node
    if(each_node %in% collapsed_tree$node.label){
      # Get the list of descendants from the node
      the_descendants <- get_descendants_from_node(tree = collapsed_tree, 
                                                   node_number = node_nb)
      
      # dropping tips 
      collapsed_tree <- try(
        ape::drop.tip(phy = collapsed_tree, 
                      tip = the_descendants, 
                      trim.internal = trim.internal,
                      ...),
        silent = FALSE
      )
    }
    else{
      message(paste("Node ", each_node, " does not exist in the tree"))
    }
    
  }
  
  message("returning the collapsed tree")
  return(collapsed_tree)
}
