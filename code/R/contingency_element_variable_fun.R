#' contingency_element_variable_fun
#'
#' Helper to create contingency tables for variables - iteratively
#' This function takes a list element and a variable name as input and performs the following operations:
#' 1. Converts the list element into a table using rlist::list.table() function.
#' 2. Converts the table into a tibble using tibble::as_tibble() function.
#' 3. Merges the list element using rlist::list.merge() function.
#' 4. Appends the number of unique levels of the variable to the merged list using rlist::list.append() function.
#' 5. Sets the column names of the merged list using setNames() function.
#' 6. Converts the merged list into a tibble using as_tibble() function.
#'
#' @param list_element A list element.
#' @param variable A variable name.
#'
#' @return A contingency table tibble containing the merged list. Variable categories, frequencency of each and the unique levels of the variable.
#'
#' @examples
#' contingency_element_variable_fun(list_element = list(a = c(1, 2, 3), b = c(4, 5, 6)), variable = "a")
#' contingency_element_variable_fun(list_element = list(a = c(1, 2, 3), b = c(4, 5, 6)), variable = "b")
#'
#' @importFrom rlist list.table
#' @importFrom tibble as_tibble
#' @importFrom rlist list.merge
#' @importFrom rlist list.append
#' @importFrom glue glue
#' @importFrom dplyr setNames
#'
#' @export
contingency_element_variable_fun <- function(list_element, variable) {
  list_element %>%
    list.table(., table.args = list(dnn = list(variable), useNA = "no")) %>%
    as_tibble() %>%
    list.merge() %>%
    list.append(., "unique" = length(levels(as.factor(.[[variable]])))) %>%
    setNames(., c(
      variable,
      glue("Freq", variable, .sep = "_"),
      glue("unique_levels", variable, .sep = "_")
    )) %>%
    as_tibble()
}