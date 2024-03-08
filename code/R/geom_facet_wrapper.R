# TODO Find a way to make it functional ! with a geom 

#' modifies in place the plot data to be able to plot geom_facet directly 
#' without creating intermediate datasets
#' @param data the plot data
#' @param nested_col The name of the column containing the nested variable.
#' @param var The name of the nested variable to extract.
#' @param new_col The name of the new column to create.
#' @param ... arguments for geom facet
#' 
geom_facet_wrapper <- function(data, nested_col, var, new_col, ...){
  
  df <- get_data_geom_facet(data = data, 
                            nested_col = nested_col, 
                            var = var, ...)
  
  #geom_facet(...)
  return(df)
  
}
