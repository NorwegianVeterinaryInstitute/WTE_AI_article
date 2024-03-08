#' nested_contingency_table_fun.R
#' 
#' Function to create a contingency table - can be used in the nested data-frame 
#' for one or two variables of the metadata. Its done to create contingency table in
#' each nested table
#' 
#' @param data The data frame containing the metadata.
#' @param ... One or two variables of the metadata to create the contingency table for.
#' 
#' @return A data frame with the factor (or interactions) levels for each variable, 
#' the frequency this level was encountered, and the count of different factor levels.
#' 
#' @examples
#' data <- data.frame(
#'   var1 = c("A", "B", "A", "B", "A"),
#'   var2 = c("X", "Y", "X", "Y", "X")
#' )
#' 
#' nested_contingency_table_fun(data, var1, var2)
#' 
#' @import dplyr
#' @import tidyr

nested_contingency_table_fun <- function(data, ...){
    
    # note unique levels added - even if repeated by row - can be used then in filter
    # will need to use distinct then but can be searched 
    
    # TODO : rewrite using names = T - should simplify
    factor_vars <- enquos(...)
    names_factors <- sapply(factor_vars, 
                                                     function(x) {as_name(x)},
                                                     USE.NAMES = FALSE)
    # factor_vars <- enquos(..., .named = T)
    # names_factors <- names(factor_vars)
    # Require another change in the way to do the fun - wait
    
    # considering 2 variables
    if (length(factor_vars) == 2) {
        
        # Getting levels interaction 
        name_interaction <- sym(paste0("levels@", str_c(names_factors, collapse = "~")))
        name_tally <- paste0("freq_levels@", str_c(names_factors, collapse = "~"))
        name_unique_levels <- sym(str_c(names_factors, collapse = "~"))
        
        conting_df <- 
        data %>%
            # to be certain 
            ungroup() %>%
            unite(!!name_interaction, matches(names_factors), 
                        sep = "@", 
                        remove = FALSE) %>%
            group_by(!!name_interaction) %>%
            add_tally(name = name_tally) %>%
            select(!!name_interaction, !!name_tally) %>%
            # getting unique levels nb (repeated for each row)
            ungroup() %>%
            mutate("nb_levels@{name_unique_levels}" := length(unique(!!name_interaction)))
        
    }
    # considering 1 variable
    else if (length(factor_vars) == 1) {
        
        name_tally <- paste0("freq_levels@", unlist(names_factors))
        name_unique_levels <- sym(unlist(names_factors))
        
        conting_df <- 
        data %>%
            group_by(!!!factor_vars) %>%
            add_tally(name = name_tally) %>%
            select(!!!factor_vars, !!name_tally) %>%
            # getting unique levels nb (repeated for each row)
            ungroup() %>%
            mutate("nb_levels@{name_unique_levels}" := length(unique(!!!factor_vars)))
    }
    else {
        stop("Only 1 or 2 variables can be considered")
        # This could be done at the higher level - by looping over sets of pairs / interactions
    }
    # adding row position for plotting helper
    conting_df %>% 
    distinct() %>%
    mutate(pos = row_number())
}

# Tests 
# test <-  
#   my_plotdata2 %>%
#   mutate(nested_country = tip_metalink) %>%
#   #filter(label ==  "EPI_ISL_18455202") %>%
#   filter(label ==  "N100") %>%
#   rowwise() %>%
#   # nested_country represent what ever variable(s) we want to represent
#   # first need to add the column of labels for merging data 
#   # and creates a nested tibble  
#   mutate(nested_country =  list(
#     tip_metalink %>% 
#     enframe(., name = "pos", value = "label") 
#     )) 
#   # ok so now we can do operations on nested tibble - to link the metadata 
#   # so with the function inside we can create operations - on what we want 
# 
# # For one level 
# test %>%
#   mutate_at(vars(nested_country), 
#             ~ list(.x %>% 
#                      left_join(all_metadata_selected, by = c("label" = "label")) %>%
#                      select(label, country) %>%
#                      mutate(pos = row_number()))
#               
#             ) %>%
#   mutate(nested_country_contig = 
#            list(nested_contingency_table_fun(nested_country, country))
#          ) 
# 
# # for 2 levels interaction
# test %>% 
#   mutate_at(vars(nested_country),
#             ~ list(.x %>%
#                      left_join(all_metadata_selected, by = c("label" = "label")) %>%
#                      select(label, country, Host) %>%
#                      mutate(pos = row_number()))
# 
#             ) %>%
#   mutate(nested_country_contig =
#            list(nested_contingency_table_fun(nested_country, Host, country))
#          )