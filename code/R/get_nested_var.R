#' Get Nested Variable
#'
#' This function extracts a nested variable from a data frame and creates a new column with the concatenated values.
#'
#' @param data The input data frame. (plot_data)
#' @param nested_col The name of the column containing the nested variable.
#' @param var The name of the nested variable to extract.
#' @param new_col The name of the new column to create.
#'
#' @return The input data frame with the new column added.
#'
#' @examples
#' data <- data.frame(nested_col = list(list(var = c("a", "b")), list(var = c("c", "d"))))
#' get_nested_var(data, "nested_col", "var", "new_col")
#'
#' @importFrom dplyr mutate rowwise
#' @importFrom stringr str_c
#' @importFrom purrr map unlist
#' @importFrom magrittr %>%
#'
#' @export
get_nested_var <- function(data, nested_col, var, new_col){
    
    data %>%
        rowwise() %>%
        mutate("{new_col}" := list(
            unlist(.data[[nested_col]][[var]]) %>%
                str_c(collapse = ", ")
            )
        ) 
}