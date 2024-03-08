#' data wrangling for phylogenetic annotations with ggtree::geom_facet using geom_text 
#' 
#' @description 
#' Returns a dataframe for phylogenetic annotations with ggtree::geom_facet 
#' with options geom_text to concatenate all the tips that are represented
#' at each label (tip or nodes) and transform those as tring to it
#' can be used for visualisation in a ggtree geom_facet panel with the geom_text
#'
#' @details 
#' `get_represented_tips_geom_facet` takes an input data frame (plot data) and prepares it for use 
#' with ggtree::geom_facet. It filters the metadata to diplay only tips labels and returns the
#' data frame in the the format that is compatible with ggtree::geom_facet usage, 
#' that is to say: two columns, label and val. 
#'
#' The function extracts the specified nested variable,
#' creates a new column with the extracted nested variable,
#' then arranges the data frame by the label column.
#' It unnests the chosen variable to create separate rows for each value of the chosen variable.
#'
#' @param data The input data frame. Either plot data or metadata with labels containing the contingency table 
#' @param nested_col The name of the column containing the nested represented tips

#'
#' @return A modified data frame prepared for use with ggtree::geom_facet with geom_text
#' with the columns label and val

#'
#' @importFrom dplyr filter select rename 
#' @importFrom tidyr unnest
#'
#' @export
get_represented_tips_geom_facet <- function(data, nested_col = "tip_metalink") {

  data %>%
    dplyr::filter(isTip) %>%
    dplyr::select(label, {{ nested_col }}) %>%
    dplyr::rowwise() %>%
    dplyr::mutate(val = list(
        unlist(.data[[nested_col]] %>%
                str_c(collapse = ", ")
            ))) %>%
    dplyr::select(label, val) %>%
    tidyr::unnest(val)
}