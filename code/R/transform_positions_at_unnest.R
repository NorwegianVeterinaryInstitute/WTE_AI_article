#transform_positions_at_unnest.R


#' Updates plot positions of a plot during unnesting of data. 
#' It uses the pos variable to create steps that will be added to the positional 
#' variable of choice
#' @param data plot data 
#' @param  pos_col positional variable to be updated (x or y). Default x.
#' @param sequence_col the variable that represent the position of the nested factor/categorical variable
#' we are interested to look at. The nested variable must be a dataframe.
#' @param spacing relative spacing : given value / (max pos_col - min pos_col)
#' Inspired by phyloseq 
#' 

transform_positions_at_unnest <- function(data, pos_col = x, sequence_col = pos, 
                                          spacing = 1) {
  # compute the maximum sequence to generate
  max_pos <- data %>% 
    dplyr::select({{sequence_col}}) %>% 
    dplyr::pull() %>% 
    max()
  
  # compute the interval of of pos_col to get the order of magnitude 
  pos_col_vector <- 
    data %>% 
    dplyr::select({{pos_col}}) %>% 
    dplyr::pull() 
  
  diff_pos_col <- max(pos_col_vector) - min(pos_col_vector)
  
  message(sprintf("The min value of positional variable is %s and the max value is %s.\n 
                  This should help you choose spacing values", 
                  min(pos_col_vector), max(pos_col_vector)))
  
  message(sprintf("You have a maximum of %s sequences positions for your unnested variable", max_pos))
  
  # compute the step to add to the pos_col
  
  # First position must not be shifted
  data %>%
    mutate_at(vars({{pos_col}}), ~ . + (spacing *  ({{sequence_col}}-1)))
  
}

# test <- 
#   plot_subtree_N348$data %>%
#   unnest(ctg_year) 
# 
# test2 <- test %>% select(label, x, year, pos)
# 
#transform_positions_at_unnest(test2, pos_col = x, sequence_col = pos)
