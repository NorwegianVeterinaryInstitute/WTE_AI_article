#' get_represented_helper
#' 
#' This function retrieves the tips that are represented for a given tip x. It serves as a helper function for mapping.
#' 
#' @param x The tip for which represented tips are to be retrieved.
#' @param df_duplicate The data frame containing duplicate information.
#' @param df_label The column name in df_duplicate that represents the tip labels.
#' @param df_represented The column name in df_duplicate that represents the represented tips.
#' 
#' @return A list of represented tips for the given tip x, or the original tip x if it is not represented.
#' 
#' @examples
#' # Example usage
#' get_represented_helper("A", df_duplicate = duplicates_df, df_label = label, df_represented = represented_seq_label
#' get_represented_helper("EPI_ISL_5804698", duplicates_df, label, represented_seq_label - correct
#' rlist::list.map(list("EPI_ISL_5804698", "N1", "EPI_ISL_5804698"), ~ get_represented_helper(.))  -  correct 
#' rlist::list.map(list(c("EPI_ISL_5804698", "N1"), "EPI_ISL_5804698"), ~ get_represented_helper(.)) -  wrong - no nested list!
#' rlist::list.map(unlist(list(c("EPI_ISL_5804698", "N1"), "EPI_ISL_5804698")), ~ get_represented_helper(.)) -  correct 
#' same for purrr::map  
#' 
#' WARNING: does not go down in the hiearchy of nested lists
get_represented_helper <- function(x,
                                             df_duplicate = duplicates_df,
                                             df_label = label,
                                             df_represented = represented_seq_label
) {
  # x must be a vector (or unique)
  unique_dup <- df_duplicate %>%
            select({{ df_label }}) %>%
            pull() %>%
            unique()

  # getting the represented tips 
  ifelse(x %in% unique_dup,
                     list(
                         df_duplicate %>%
                         filter({{ df_label }} == x) %>%
                         select({{ df_represented }}) %>% pull()
                         ),
                     list(x))
}

# now we need to do that to update all the tree 
# test_tips <- list("EPI_ISL_5804698", "N1", "EPI_ISL_5804698") # nolint
# rlist::list.map(test_tips, ~ get_represented_helper(.))
# purrr::map(test_tips, ~ get_represented_helper(.)) 
# # rlist::list.map("EPI_ISL_5804698", ~ get_represented_helper(.)) 
# test_tips = list(c("EPI_ISL_5804698", "N1"), "EPI_ISL_5804698")
# rlist::list.map(test_tips, ~ get_represented_helper(.))  # wrong 
# purrr::map(test_tips, ~ get_represented_helper(.))  # wrong 
# 
# rlist::list.map(unlist(test_tips), ~ get_represented_helper(.))  # correct 
# purrr::map(unlist(test_tips), ~ get_represented_helper(.))  # correct 
