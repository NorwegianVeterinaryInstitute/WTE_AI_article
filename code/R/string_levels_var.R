#' string_levels_var
#'
#' HELPER
#' This function allows returning the unique levels of a factor into a new column and concatenating as a string for plotting.
#' This is useful when the factor/categorical variable levels/values are nested in the first element of dataframe.
#'
#' @param data A dataframe containing the data.
#' @param var The name of the variable for which the unique levels need to be extracted.
#' @param collapse The symbol used to collapse the levels into a string. Default is ",".
#'
#' @return A modified dataframe with the specified column containing a string with the different levels of the variable var.
#'
#' @examples
#' data <- data.frame(var = list(c("A", "B", "C"), c("B", "C", "D"), c("A", "D", "E")))
#' string_levels_var(data, "var")
#'
#' @importFrom dplyr mutate rowwise
#' @importFrom purrr map
#' @importFrom stringr str_c
#'
#' @export
string_levels_var <- function(data,
                              var,
                              collapse = ",") {
  data %>%
    rowwise() %>%
    mutate("levels_{var}" :=
      list(
        purrr::map(.data[[var]][[1]], ~.x)
      ) %>%
      unlist() %>%
      unique() %>%
      sort() %>%
      str_c(collapse = collapse))
}
# !! here if do not specify purrr::map get a problem - when do not import function with def
