#' Update plot data with a column that list all the represented tips and duplicates sequences, so this can be linked to the metadata
#'
#' This function updates the plot data by creating a new column where all the represented tips are stored in a list.
#' It takes the original plot data, the column name for the new data, the column name for the descendants of tips, the column name for the label,
#' the duplicates dataframe, the column name for the label in the duplicates dataframe, and the column name for the represented tips in the duplicates dataframe.
#'
#' @param data The original data frame.
#' @param data_new_col The column name for the new data (default: "tip_metalink").
#' @param data_desc_nodes The column name for the descendants of tips.
#' @param data_label The column name for the label.
#' @param df_duplicate The duplicates dataframe.
#' @param df_label The column name for the label in the duplicates dataframe.
#' @param df_represented The column name for the represented tips in the duplicates dataframe.
#'
#' @return The updated data frame with the new column which list all the tips represented in the metadata.
#'
#' @examples
#' Flattens the list - SHOULD BE REWRITTEN ! 
#' data <- data.frame(isTip = c(TRUE, FALSE, TRUE),
#'                    descendants_tips_from_node = list(c("A", "B"), c("C", "D"), c("E", "F")),
#'                    label = c("Label1", "Label2", "Label3"))
#' duplicates_df <- data.frame(label = c("Label1", "Label2", "Label3"),
#'                             represented_seq_label = list(c("A", "B"), c("C", "D"), c("E", "F")))
#' update_plotdata_desc_repr_metalink_fun(data, "tip_metalink", "descendants_tips_from_node", "label", duplicates_df, "label", "represented_seq_label")
#'
#' @importFrom dplyr mutate case_when rowwise
#' @importFrom purrr map
#' @importFrom rlang expr
#' @importFrom rlang !! :=
#' @importFrom rlang deparse substitute
#' @importFrom tidyr list
#' @importFrom tidyr unlist
#' @importFrom tidyr unique
#' @importFrom tidyr list
#' @importFrom tidyr NA_character_
#' @importFrom tidyr %>% 
#'
#' @export
update_plotdata_desc_repr_metalink_fun <- function(
        data,
        data_new_col = tip_metalink,
        data_desc_nodes = descendants_tips_from_node,
        data_label = label,
        df_duplicate = duplicates_df,
        df_label = label,
        df_represented = represented_seq_label
) {

  # required quoting
  data_new_col <- deparse(substitute(data_new_col))

  # helpers to get the defaults and simplify writing
  luu <- function(x) {
    list(unique(unlist(x)))
  }

  # TODO adding case when no duplicates 
  # Case when there are duplicates sequences to add
  if (!is.null(df_duplicate)) {
    
  gth <- rlang::expr(get_represented_helper(luu(.), 
                                            {{ df_duplicate }}, 
                                            {{ df_label }}, 
                                            {{ df_represented }})
                     )
  
    # ensure only unique are kept
    # defensive - only considers unique values 

    data %>%
          rowwise() %>%
          mutate("{ data_new_col }" :=
                   case_when(
                     isTip ~ luu(purrr::map({{ data_label }}, ~ !!gth)),
                     !isTip ~ luu(purrr::map({{ data_desc_nodes }}, ~ !!gth)),
                     TRUE ~ list(NA_character_)
                   ))
  }
  else {
    # Could just put data label ? wondering about formating
    data %>%
      rowwise() %>%
      mutate("{ data_new_col }" :=
               case_when(
                 isTip ~ luu(purrr::map({{ data_label }}, ~ {{ data_label }})),
                 !isTip ~ luu(purrr::map({{ data_desc_nodes }}, ~ {{data_desc_nodes}})),
                 TRUE ~ list(NA_character_)
               ))
  }
}




# Tests helps 

# testing if work - ok final nodes is more also 
# This basis is working - using the defaults form descendants tips from node 
# test_df <-
#   my_plotdata %>%
#   rowwise() %>%
#   mutate(
#     tip_metalink =
#       case_when(
#         isTip ~ list(unlist(purrr::map(
#           label,
#           ~ get_represented_helper(.)
#         ))),
#         (!isTip) ~ list(unlist(purrr::map(
#           unique(unlist(descendants_tips_from_node)),
#           ~ get_represented_helper(.)
#         ))),
#         TRUE ~ list(NA_character_)
#       )
#   )
# test_df %>%
#   rowwise() %>%
#   mutate(len_origin = 
#            case_when(
#              isTip ~ length(unlist(label)),
#              (!isTip) ~ length(unlist(descendants_tips_from_node))),
#          len_final = length(unlist(tip_metalink))
#          )  %>%
#   select(len_origin, len_final) %>%
#   View()


# luu <- function(x) {list(unique(unlist(x)))}
# This is another potential solution
# gth <- function(x) {
#     get_represented_helper(x, df_duplicate, df_label, df_represented)
#   }

# test_tips1 <- list(" EPI_ISL_5804698 ", " N1 ", " EPI_ISL_5804698 ")
# test_tips2 <- list(c(" EPI_ISL_5804698 ", " N1 "), " EPI_ISL_5804698 ")  
# luu(test_tips1)
# luu(test_tips2)

# commes from 
# test_df <- 
#   my_plotdata  %>%
#   filter(!isTip, label == " N1 ") %>%
#   rowwise() %>%
#   mutate(test = list(unlist(purrr::map(descendants_tips_from_node, ~ get_represented_helper(.))))) %>%
#   pull(test)

# test_df <- 
#   my_plotdata  %>%
#   filter(isTip, label == " EPI_ISL_5804698 ") %>%
#   rowwise() %>%
#   mutate(test = list(unlist(purrr::map(label, ~ get_represented_helper(.))))) %>%
#   pull(test)

# Test with H5N5 - where no duplicates
# my_plotdata %>%
#   update_plotdata_desc_repr_metalink_fun(df_duplicate = NULL, 
#                                          df_label = NULL,
#                                          df_represented = NULL) %>%
#   rowwise() %>%
#   mutate(identical = if_else(isTip, identical(label, unlist(tip_metalink)),
#                              identical(unlist(descendants_tips_from_node),
#                                        unlist(tip_metalink)))) %>%
#   View()
