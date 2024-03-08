#' contingency_df_variable_fun
#' Contingency DataFrame Variable Function
#'
#' This function takes a data frame, a list of variables, and an optional grouping variable, and returns a contingency data frame.
#' The contingency data frame summarizes the values of the variables for each group.
#' For each variable, it also calculates a contingency element using the contingency_element_variable_fun function.
#'
#' @param data The input data frame.
#' @param variables A character vector specifying the variables to include in the contingency data frame.
#' @param group A vector specifying the grouping variable. Default is "label". !!! FOR NOW ONLY LABEL - pick should solve that
#' @param add_var_keep A character vector of additional variable to keep in the table, even if no contingency table is made.
#' @param drop_vars Optional character vector of variables to be dropped from the dataframe (eg. unused variables)
#'
#'
#' @return A dataframe where contingency tables are nested for each of the summarized variables.
#'
#' @examples
#' data <- data.frame(label = c("A", "A", "B", "B"), var1 = c(1, 2, 3, 4), var2 = c(5, 6, 7, 8))
#' contingency_df_variable_fun(data, c("var1", "var2"), "label")
#'
#' @import dplyr
#' @importFrom purrr list
#' @importFrom rlang all_of
#' @importFrom rlang .data
#' @importFrom rlang :=
#' @importFrom dplyr mutate
#' @importFrom dplyr rowwise
#' @importFrom dplyr pick
#' @importFrom dplyr group_by
contingency_df_variable_fun <- function(data, variables, group = label, add_var_keep = c("duppos", "represented_seq_label
"), drop_vars = NULL) {
  df <- data
  # case filtering variables we do not want to use
  if (!is.null(drop_vars)) {
    df <- df %>%
      select(-any_of(drop_vars))
  }
  # case we keep some variables for summary as list even if summary not done yet
  var_list <- c(variables, add_var_keep)

  # Todo: find alternative to pick which might have been clearer (see rlang, advancedR again)
  df <-
    df %>%
    ungroup() %>%
    group_by(pick({{ group }})) %>% # Find solution to get with quotes and several variables
  mutate(across(all_of(var_list), ~ list(.x))) %>%
    distinct()


  for (var in variables) {
    df <- df %>%
      rowwise() %>%
      mutate("{var}" := list(contingency_element_variable_fun(.data[[var]], !!var)))
  }

  return(df)
}
