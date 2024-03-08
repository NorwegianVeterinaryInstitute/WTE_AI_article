#' check_in_var
#'
#' HELPER
#'
#' This function allows testing if a factor takes values according to test criteria in the nested dataframe, and returns bolean a bolean, in a non nested column of the dataframe
#'
#' @param data The input data frame or tibble.
#' @param var The name of the column to check within the nested contingency data frame.
#' @param name_new_col The name of the new column to be added to the tibble. Default is "inNorway".
#' @param test_expr The expression used to test if the level is present. Default is `Norway %in% .x`.
#'
#' @return A modified tibble with an additional column indicating whether the test is true or not.
#'
#' @examples
#' # Create a sample data frame
#' test_df <- data.frame(country = list(c("Norway", "Sweden", "Denmark"), c("Germany", "France", "Italy")))
#'
#' # Check if "Norway" is present in the "country" column
#' check_in_var(test_df, "country")
#' @importFrom dplyr rowwise
#' @importFrom dplyr mutate
#' @importFrom purrr map
#' @importFrom rlang expr
#' @importFrom rlang !!
#' @export
check_in_var <- function(data, var, name_new_col = "inNorway", test_expr = rlang::expr("Norway" %in% .x)) {
  data %>%
    rowwise() %>%
    mutate("{name_new_col}" := any(unlist(
      list(purrr::map(.data[[var]][[1]], ~ !!test_expr))
    )))
}
# (!!) here if do not specify purrr::map get a problem - when do not import function with def
# TODO should e rewriten ? as a mutate to be able to do directly inside process of filtering ? 
# should allow colnames in {{}} and not as string ? 