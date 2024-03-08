#' data wrangling for phylogenetic annotations with ggtree::geom_facet 
#' 
#' @description 
#' Returns a dataframe for phylogenetic annotations with ggtree::geom_facet 
#' with options geom_bar, for a categorical variable that is stored in a 
#' nested table. For nested contingency tables and usage with geom_text and geom_tile,
#' please use the function get_ctg_data_geom_face
#'
#' @details 
#' `get_data_geom_facet` takes an input data frame (plot data) and prepares it for use 
#' with ggtree::geom_facet. It filters the metadata to display only tips labels 
#' and returns the data frame in the the format that is compatible with 
#' ggtree::geom_facet usage, that is to say: tree columns, label, 
#' variable (your var) and value (count of var for each label to get the number of
#' time your var is observed in each label).
#'
#' The function filters tips, extracts the specified nested variable,
#' optional : group your variable by category, then counts the number
#' of times each category is observe in each tip and count the sum by tip 
#' to be able to create a barplot with geom_bar.
#'#'
#' Warning: This function is not designed to work on contingency tables _ctg_ 
#' please use the function get_ctg_data_geom_face for this purpose.
#' 
#' @param data The input data frame. Either plot data or metadata with labels containing the contingency table 
#' @param nested_col The name of the column containing the nested variable.
#' @param var The name of the nested variable to extract.
#' @param group_expr a rlang expression to modify the variable display, eg. grouping
#' of the variable if the variable has a certain value 
#'
#' @return A modified data frame prepared for use with ggtree::geom_facet with geom_bar
#' with the columns label and variable (your var) and value (count per var per label)
#'
#' @examples
#' data <- data.frame(label = c("A", "B", "C"),
#'                    nested_col = list(c("X", "Y"), c("Z"), c("W", "V")),
#'                    stringsAsFactors = FALSE)
#'
#' my_group_expr <- rlang::expr(case_when(
#'                                   variable %in% nordic_countries ~ "Nordic",
#'                                   variable %in% continent_europe ~ "Other European"))
#'
#' @importFrom dplyr filter select rename mutate rowwise summarise
#' @importFrom tidyr unnest
#' @importFrom glue glue
#' 
#'
#' @export
get_data_geom_facet <- function(data, nested_col, var, group_expr = NULL) {

  var <- deparse(substitute(var))

  df <-
    data %>%
    dplyr::filter(isTip) %>%
    dplyr::select(label, {{ nested_col }}) %>%
    # preventing bug if column name exists already under the hood
    tidyr::unnest({{ nested_col }}, names_sep = "@unnested_") %>%
    dplyr::rename(variable =
                    dplyr::contains(glue::glue("@unnested_{var}"))
                  ) %>%
    # Ensure it is regarded as categorical variable
    dplyr::mutate_at(dplyr::vars(variable), as.character) %>%
    dplyr::select(label, variable)

  # allows to get a flexible grouping for var
  if (!is.null(group_expr)) {
    df <- df %>%
      dplyr::rowwise() %>%
    # TODO should be improved by rlang set and get_expr - but it works for now
    dplyr::mutate(variable = !!(group_expr))
  }
  # count the number of time each variable is observed in each label
  df %>%
    dplyr::group_by(label, variable) %>%
    dplyr::summarise(value = n(), .groups = "keep") %>%
    dplyr::ungroup() %>%
    dplyr::group_by(label) %>%
  # the sum must be by group of label so it can be standard width column
  dplyr::mutate(value = value / sum(value))
}






