#' Function to get the isolate ID from a prepared data where 
#' labels are given in a string format.
#' HELPER : done to accomondate change of mind
#' rerun the dataframe where the columns where the labels are stored with isolateID instead
#' @param data the dataframe to modify label, val
#' @param metadata the metadata dataframe where the isolateID are stored, column label must be the join
#' @param metadata_isolateID_col the column name where the string of label to modify is stored


get_isolateID_from_label_string <- function(data, metadata, 
                                            meta_isolateID_col
                                            ){
  
  data %>%
    # nesting the data
    tidyr::nest(.by = matches("label"), .key = "nested_col") %>%
    rowwise() %>%
    # splitting the string 
    mutate(nested_col = list(
      rlist::list.map(.data[["nested_col"]], 
                      ~ str_split (., ", ")
                      ) %>%
        rlist::list.stack(data.table = TRUE) %>%
        dplyr::left_join(metadata %>% 
                           select(label, {{meta_isolateID_col}}),
                         by = c("V1" = "label")) %>%
        dplyr::select(-V1) %>%
        dplyr::rename(val = {{meta_isolateID_col}}) 
    )) %>%
    # recollapsing in the same format
    dplyr::mutate(val = list(
      unlist(.data[["nested_col"]]) %>%
        str_c(collapse = ", ")
    )) %>%
    dplyr::select(-nested_col) %>%
    # unnesting neccesary to get the data in the same format
    tidyr::unnest(cols = val)
}
  
# get_isolateID_from_label_string(data = all_represented_tips_df, 
#                                 metadata = all_tree_metadata, 
#                                 meta_isolateID_col = Isolate_Id) %>%
#   dplyr::filter(label == "N4247")

# RELICS  
# 
# test <- 
#   all_represented_tips_df %>% 
#   tidyr::nest(.by = matches("label"), .key = "nested_val") # %>%
# dplyr::filter(label == "N4247") 
# 
# 
# test 
# all_represented_tips_df %>%
#   filter(label == "N4247") 
# 
# test$nested_val
# # I need to separate each of the val by , 
# 
# 
# test2 <- 
#   test %>% 
#   rowwise() %>%
#   mutate(nested_val = list(
#     rlist::list.map(.data[["nested_val"]], 
#                     ~ str_split (., ", ")) %>%
#       rlist::list.stack(data.table = TRUE) %>%
#       dplyr::left_join(all_tree_metadata %>% 
#                          select(label, Isolate_Id),
#                        by = c("V1" = "label")) %>%
#       dplyr::select(-V1) %>%
#       dplyr::rename(val = Isolate_Id) 
#   )) %>%
#   dplyr::mutate(val = list(
#     unlist(.data[["nested_val"]]) %>%
#       str_c(collapse = ", ")
#   )) %>%
#   dplyr::select(-nested_val)
# 
# 
# test2 %>%
#   tidyr::unnest(cols = val) %>%
#   View()
# 
