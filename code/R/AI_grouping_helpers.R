# For creating categories highlight ---- 
grouping_helper_category_highligth <-
  rlang::expr(
    case_when(
      inNorway & isWTE ~ "NO: WTE",
      inNorway & (!isWTE) ~ "NO: Other Avian",
      TRUE ~ "Other Country")
    )
category_highligth_levels <- c("Other Country", "NO: Other Avian", "NO: WTE")


# for function get_data_geom_facet - grouping for countries ----
# TODO should be improve by set and get_expr in rlang
# FOR now need to use variable as its the variable name in the dataframe
grouping_helper_country <- rlang::expr(
  case_when(
    variable %in% nordic_countries ~ "Nordic",
    variable %in% continent_europe ~ "Other European",
    variable %in% continent_asia ~ "Asia",
    variable %in% continent_africa ~ "Africa",
    variable %in% continent_north_america ~ "North America",
    variable %in% continent_south_america ~ "South America")
)

