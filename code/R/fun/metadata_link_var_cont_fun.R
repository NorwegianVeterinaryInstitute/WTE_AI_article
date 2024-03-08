#' metadata_link_var_cont_fun
#'
#' Wrapper function to get the metadata corresponding to a set of tips 
#' which are given as a vector in a col_link column.
#' The metadata for a series of factors or the interaction of two factors 
#' is implemented as a nested dataframe containing the raw metadata series of one 
#' factor/variable or the interaction of two variables. 
#' 
#' @param plot_data The input dataframe containing the data to be processed.
#' @param col_link The name of the column in plot_data that contains the tips to be linked with metadata.
#' @param metadata The metadata dataframe containing the metadata information.
#' @param interaction A logical value indicating whether interaction between two factors is required.
#' @param ... The factors/variables to be used for metadata retrieval.
#' 
#' @return The original dataframe with added columns: 'nested_{var}' containing a nested dataframe of 
#' the raw metadata for each factor (or interaction of 2 factors) for each tip given in col_link, and 'ctg_{var}' 
#' containing a nested dataframe which is the contingency table of 'nested_{var]'.
#' 
#' @examples
#' # Example usage
#' metadata_link_var_cont_fun(plot_data, col_link = tip_metalink, metadata = all_metadata_selected, interaction = FALSE, factor1, factor2)
#'
#' @import dplyr
#' @import tidyr
#' @import stringr
#' @importFrom purrr enquos
#' @importFrom purrr as_name
#' 
metadata_link_var_cont_fun <- function(plot_data, 
                                                                            col_link = tip_metalink,
                                                                            metadata = all_metadata_selected, 
                                                                            interaction = FALSE, 
                                                                            ...) {
    # ... is the factors variables 
    factor_vars <- enquos(..., .named = TRUE)
    names_factors <- names(factor_vars)
    
    df <- plot_data 

    if (!interaction){
        # we need to keep quoted because need to use in select
        # would be better to do all at once - but complicated without loop for now
        for (var in factor_vars){
            nest_col_name <- sym(paste0("nested_", as_name(var)))
            # contingency table name
            nest_col_ctg_name <- sym(paste0("ctg_", as_name(var)))
            
            df <- df %>%
                rowwise() %>%
                # Eeventually: The 2 mutates could be done in one step
                mutate(!!nest_col_name := list(
                    {{col_link}} %>% 
                        enframe(., name = "pos", value = "label"))
                    ) %>%
                mutate_at(vars(!!nest_col_name),
                                    ~ list(.x %>%
                                                     left_join(metadata, by = c("label" = "label")) %>%
                                                     select(label, !!var) %>%
                                                     mutate(pos = row_number()))
                ) %>% 
                mutate(!!nest_col_ctg_name := list(
                    nested_contingency_table_fun(!!nest_col_name, !!var))
                    )
            }
    } 
    else if (interaction & length(factor_vars) == 2){
            # case interaction two factors 
            nest_col_name <- sym(paste0("nested_", 
                                                                    str_c(names_factors, collapse = "~")
                                                                    ))
            # contingency table name
            nest_col_ctg_name <- sym(paste0("ctg_", str_c(names_factors, collapse = "~")
                                                                    ))
            
            df <- df %>%
                rowwise() %>%
                mutate(!!nest_col_name := list(
                    {{col_link}} %>% 
                        enframe(., name = "pos", value = "label"))
                    ) %>%
                mutate_at(vars(!!nest_col_name),
                        ~ list(.x %>%
                                         left_join(metadata, 
                                                             by = c("label" = "label")) %>%
                                         select(label, !!!factor_vars) %>%
                                         mutate(pos = row_number()))

                        ) %>%
                mutate(!!nest_col_ctg_name := 
                                 list(nested_contingency_table_fun(!!nest_col_name, 
                                                                                                     !!!factor_vars))
                 )

    }
    else {
        stop("interaction only possible with two factors")
         # This could be done by looping over sets of pairs/ interactions
         # would require wrapping step up in a function
         # then loop on all pairs of interactions
         # but do not think really necessary for my stuff
    }
    
    return(df)
}

# Tests 
# No interaction 
# test2 <- 
#   metadata_link_var_cont_fun(plot_data = my_plotdata2 %>% filter(label ==  "N100"), 
#                           col_link = tip_metalink,
#                           metadata = all_metadata_selected, 
#                           interaction = FALSE, 
#                           country, Host)
# # Interaction 2 factors 
# test3 <- 
#   metadata_link_var_cont_fun(plot_data = my_plotdata2 %>% filter(label ==  "N100"), 
#                           col_link = tip_metalink,
#                           metadata = all_metadata_selected, 
#                           interaction = TRUE,
#                           country, Host)