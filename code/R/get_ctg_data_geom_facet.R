#' data wrangling for phylogenetic annotations with ggtree::geom_facet 
#' 
#' @description 
#' Returns a dataframe for phylogenetic annotations with ggtree::geom_facet 
#' with options geom_text and geom_tile, for a categorical variable that is stored in a 
#' nested contingency table. 
#'
#' @details 
#' `get_ctg_data_geom_facet` takes an input data frame (plot data) and prepares it for use 
#' with ggtree::geom_facet. It filters the metadata to diplay only tips labels and returns the
#' data frame in the the format that is compatible with ggtree::geom_facet usage, 
#' that is to say: two columns, label and val.
#'
#' The function extracts the specified nested variable,
#' creates a new column with the extracted nested variable,
#' then arranges the data frame by the label column.
#' It unnests the chosen variable to create separate rows for each value of the chosen variable.
#'
#' Warning: This function is designed to work on contingency tables (_ctg_) with the geom_text
#' and geom_tile when the objective is to display several values in the same line, eg year will be: 2022, 2023
#'  bn
#' @param data The input data frame. Either plot data or metadata with labels containing the contingency table 
#' @param nested_col The name of the column containing the nested variable.
#' @param var The name of the nested variable to extract.
#' TODO : find a better way
#' @param new_col The name of the new column to create, for the function get_nested_var.
#'
#' @return A modified data frame prepared for use with ggtree::geom_facet with geom_text and geom_tile.
#' with the columns label and val
#'
#' @examples
#' data <- data.frame(label = c("A", "B", "C"),
#'                    nested_col = list(c("X", "Y"), c("Z"), c("W", "V")),
#'                    stringsAsFactors = FALSE)
#'
#' get_ctg_data_geom_facet(data, nested_col, nested_var, new_col)
#'
#' @importFrom dplyr filter select rename arrange
#' @importFrom tidyr unnest
#' @import get_nested_var
#'
#' @export
get_ctg_data_geom_facet <- function(data, nested_col, var, new_col) {
  data %>%
    dplyr::filter(isTip) %>%
    get_nested_var(., {{ nested_col }}, {{ var }}, {{ new_col }}) %>%
    dplyr::select(label, {{ new_col }}) %>%
    dplyr::rename(val = {{ new_col }}) %>%
    dplyr::arrange(label) %>%
    tidyr::unnest(val)
}
