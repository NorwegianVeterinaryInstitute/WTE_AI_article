# palettes for AI plot
# ressources  ---- 
# https://www.datanovia.com/en/blog/top-r-color-palettes-to-know-for-great-data-visualization/


# bootstrap palette ----
## individual country palettes for data exploration ----
# transparent bootstrap value when <= 95 Ultra-fast bootstrap - to avoid overplotting
rgb(0, 0, 1, 0, names = "zerocolor")
bootstrap_pal_col <- setNames(c(rgb(0, 0, 1, 0), rgb(0, 0.39, 0)), c(T, F))

# Option for checking bootstrap during tree exploration  
bootstrap_pal_col2 <- setNames(c(rgb(0, 0, 1, 0), rgb(0, 0.39, 0, 0.3)), c(T, F))

# country color - all 60 in global dataset -  for exploration ----
# We use all the colors to keep homogeneity between plots for different trees 
country_levels <- c(
    "Norway", "Albania", "Austria", "Belgium", "Bosnia and Herzegovina",
    "Bulgaria", "Croatia", "Cyprus", "Czech Republic", "Denmark",
    "Estonia", "Finland", "France", "Germany", "Greece", "Hungary",
    "Iceland", "Ireland", "Isle of Man", "Italy", "Jersey", "Lithuania",
    "Luxembourg", "Moldova, Republic of", "Montenegro", "Netherlands",
    "Poland", "Portugal", "Romania", "Russian Federation", "Slovakia",
    "Slovenia", "Spain", "Sweden", "Switzerland", "United Kingdom",
    "Benin", "Botswana", "Egypt", "Ghana", "Lesotho", "Mauritania",
    "Nigeria", "Senegal", "South Africa", "Bangladesh", "China",
    "Israel", "Japan", "Korea, Republic of", "(North America)", "Canada",
    "Honduras", "Panama", "United States", "Chile", "Colombia", "Ecuador",
    "Peru", "Venezuela, Bolivarian Republic of"
)

# ? separate "Venezuela, Bolivarian Republic of"
country_col_pal <- c(
    "#021671", "#DCFD2D", "#ED174C", "#0DD1FD", "#344C23", "#B765FB",
    "#AA8309", "#5C1723", "#36B976", "#0482FB", "#065064", "#E4C5AB",
    "#843579", "#D5A8C6", "#17FFE1", "#AEBBE6", "#019AA7", "#284AFD",
    "#614D11", "#FBCE09", "#6B8208", "#FA1FE4", "#04FB8A", "#D91586",
    "#6D0EB2", "#963E50", "#FA75B6", "#632C09", "#B2040D", "#1C5DA3",
    "#C1747C", "#A2683C", "#0B9C0D", "#203760", "#E7E09F", "#F6A077",
    "#BCF59E", "#F0491A", "#86C35E", "#F09601", "#1EC7B8", "#0C87C0",
    "#168C67", "#F189FD", "#216D17", "#A8DAE2", "#125F44", "#45056B",
    "#0414D1", "#B605D0", "#94DCB6", "#F99DA7", "#7D7CDC", "#5A1142",
    "#B9BF28", "#64F40D", "#7F3CF1", "#67B6F8", "#B89AF4", "#BB61A5"
)
names(country_col_pal) <- country_levels


## Contries groupping palette  ----
nordic_countries <- c("Norway", "Denmark", "Finland", "Iceland", "Sweden")

continent_europe <- c("Albania", "Austria", "Belgium", "Bosnia and Herzegovina", "Bulgaria", "Croatia", "Cyprus", "Czech Republic", "Estonia", "France",
                      "Germany", "Greece", "Hungary", "Ireland", "Italy", "Lithuania",
                      "Luxembourg", "Moldova, Republic of", "Montenegro", "Netherlands",
                      "Poland", "Portugal", "Romania", "Slovakia", "Slovenia", "Switzerland", "Spain", "United Kingdom", "Isle of Man", "Jersey")


continent_asia <- c("Bangladesh", "China",
                    "Israel", "Japan", "Korea, Republic of",
                    "Russian Federation")

continent_north_america <- c("Honduras", "(North America)", "Canada",
                             "Panama", "United States")

continent_south_america <- c("Chile", "Colombia", "Ecuador", "Peru",
                             "Venezuela, Bolivarian Republic of")

continent_africa <- c("Benin", "Botswana", "Egypt", "Ghana",
                      "Lesotho", "Mauritania",
                      "Nigeria", "Senegal", "South Africa")

col_grouped_countries_pal <- c(
  c(rep("#284AFD", length(nordic_countries))),
  c(rep("#0482FB", length(continent_europe))),
  c(rep("#F09601", length(continent_asia))),
  c(rep("#168C67", length(continent_north_america))),
  c(rep("#BCF59E", length(continent_south_america))),
  c(rep("#A2683C", length(continent_africa)))
)

names(col_grouped_countries_pal) <- c(
  nordic_countries,
  continent_europe,
  continent_asia,
  continent_north_america,
  continent_south_america,
  continent_africa)

# Better way to do the pallete 
col_grouped_countries_pal2 <- c("#284AFD", "#0482FB",
                                "#F09601", "#168C67",
                                "#BCF59E", "#A2683C")


names(col_grouped_countries_pal2) <- c("Nordic", "Other European",
                                       "Asia", "Africa",
                                       "North America", "South America")


## Country pal individual ---- 
# trying to homogeneize with previous so its easier to look at 
# 1. Eu
# 2. Rest Europe - greens 
# 2.1 (more blue if closes connection)
# 2.2 & 2.3
# 3. Asia - only russia most important  

col_country_ind_pal <-
  c("#284AFD", "#021671", "#0482FB", "#0414D1", "#67B6F8",
    "#0DD1FD", "#17FFE1",
    "#065064", "#36B976", "#216D17", "#86C35E", "#64F40D",
    "#168C67", "#BCF59E", "#04FB8A", "#125F44", "#344C23", "#0B9C0D",
    "#F09601", "#F0491A")

names(col_country_ind_pal) <-
  c("Norway", "Denmark", "Sweden", "Finland", "Iceland",
    "Netherlands", "United Kingdom",
    "Austria", "Belgium", "Bulgaria", "Czech Republic", "Germany",
    "Hungary", "Italy", "Poland", "Romania", "Slovakia", "Slovenia",
    "Russian Federation", "China")

# Those color remain - can be used to add other countries
# c("#1C5DA3",
#     "#1EC7B8", "#0C87C0"
#     "#DCFD2D", "#ED174C", "#B765FB",
#     "#AA8309", "#5C1723", "#E4C5AB",
#     "#843579", "#D5A8C6", "#AEBBE6",
#     "#614D11", "#FBCE09", "#6B8208", "#FA1FE4", "#D91586",
#     "#6D0EB2", "#963E50", "#FA75B6", "#632C09", "#B2040D",
#     "#C1747C", "#A2683C", "#203760", "#E7E09F", "#F6A077",
#     "#F189FD", "#A8DAE2", "#45056B",
#     "#B605D0", "#94DCB6", "#F99DA7", "#7D7CDC", "#5A1142",
#     "#B9BF28", "#7F3CF1", "#B89AF4", "#BB61A5")


# Years palettes ----- 
## shapes years ----
# needs to be grouped because its presented on the tree, by levels

### SEP ---- 

# open symbols for composite years - and old years - the lest readable (first 2 ones are not represented)
SEP_levels_years <- c("1996", "2014", "2020", "2020,2021", "2021", "2021,2022", "2022")
SEP_years_shape_pal <- c(8, 9, 15, 22, 19, 21, 17)
names(SEP_years_shape_pal) <- SEP_levels_years # because the first 2 years are not represented 

# This is for representation of plots after removal of outgroup
# SEP_norm_years <- c("2020", "2021", "2022")
# SEP_years_norm_shape_pal <- c(15, 16, 17)
# names(SEP_years_norm_shape_pal) <- SEP_norm_years


### AP ----
# TODO : to revise when I do the plot 
#AP_years_shape_pal <- c(8, 9, 15, 22, 19, 21, 17)
#AP_levels_years <- c(" 1996 ", " 2014 ", " 2020 ", " 2020, 2021 ", " 2021 ", " 2021, 2022 ", " 2022 ", " 2022, 2023 ", " 2023 ")
#names(AP_years_shape_pal) <- AP_levels_years[2:length(AP_levels_years)] # because the first 2 years are not represented 

## colors years ----
### for several categories ----
# display.brewer.all(n = 5, type = "seq", select = "Blues", colorblindFriendly = T)

### # SEP ---- 
SEP_years_col_pal <- brewer.pal(n = 5, name = "Blues")
names(SEP_years_col_pal) <- SEP_levels_years[3:length(SEP_levels_years)]

#### AP ----
# TODO 

### For barplots ----
# is individual years - no grouping 

#### SEP and AP ----
# AP is planned - so we are sure its homogenous 
years_ind_col_pal <- c("#17FFE1", "#0482FB", "#0414D1", "#021671")
names(years_ind_col_pal) <- c("2020", "2021", "2022", "2023")

# Bird families palettes ---- 
# This need to be homogenous but I am not sure all the families I will get - so need to be
# added after 

host_families_levels <- c("Avian",
"Sulidae", "Laridae", "Procellariidae", "Anatidae", "Phalacrocoracidae", "Stercorariidae",
"Phasianidae", "Columbidae", "Struthionidae",
"Accipitridae", "Falconidae",
"Scolopacidae", "Corvidae",
"Numididae", "Threskiornithidae",
"Podicipedidae",
"Spheniscidae")

# Grouping colors 
## Unspecific get greys tones
## sea birds blue 
# More close to common food green (or human)
# Hunters are more violet rosa
# coastal shore are more brown
# orange the one we done not really have
## freshwater bird - more turkeese 
## penguin dark blue 
# Vioolet (blue + violet = sear bird predatory) 
host_families_color_pal <- c("#D3D3D3",
    "#67B6F8", "#0482FB", "#0DD1FD", "#0414D1", "#67B6F8", "#284AFD",
    "#BCF59E", "#344C23", "#168C67",
    "#843579", "#6D0EB2",
    "#A2683C", "#632C09",
    "#F09601", "#F0491A",
    "#17FFE1",
    "#203760")
names(host_families_color_pal) <- host_families_levels

# PALETTE from species 
## -> maybe tone of colors per family ? Try to see if work
## That will not work, there are already enough groups with families
## Try to coordinate with colors per families in H5N1


# PALETTE for the categories highlights in the plots 

category_highlight_pal <- c(rgb(0.7, 0.7, 0.7, 0.2), "#FF00BE", "#4100FF")
names(category_highlight_pal) <- c("Other Country", "NO: WTE", "NO: Other Avian")

# This could avoid to have to give levels - but we want plotting in specified order
