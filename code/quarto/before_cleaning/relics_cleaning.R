do not do that - but is in metadata
# Host_latin_facet_df <- 
#   get_ctg_data_geom_facet(explor_plot3d$data, "ctg_Host_latin", "Host_latin", "Host_latin_string")

# HERE ADDED for simple label panel - we do not do that
# labels_df <- 
#   explor_plot3d$data %>%
#   dplyr::filter(isTip) %>%
#   dplyr::select(label) %>%
#   dplyr::mutate(val = label)



Host_latin_facet_df <- 
  get_ctg_data_geom_facet(explor_plot3d$data, "ctg_Host_latin", "Host_latin", "Host_latin_string")


# HERE : getting all the represented tips - had to create a function
# all_represented_tips_df <- get_represented_tips_geom_facet(explor_plot3d$data) %>%
#   # HERE - because the function was build before they changed their mind ... 
#   # Then I have to change the val by the  isolate ID and not by the label 
#   get_isolateID_from_label_string(., 
#                                   metadata = all_tree_metadata, 
#                                   meta_isolateID_col = Isolate_Id) 


 # HERE adding tips labels need some adjustment
  # ggtree::geom_facet(
  #   panel = "labels",
  #   data = labels_df,
  #   geom = geom_text,
  #   mapping = aes(x = -.4, label = val),
  #   hjust = 0,
  #   size = 1)  + 
  # HERE adding all represented tips  
  # ggtree::geom_facet(
  #   panel = "labels", 
  #   data = labels_df,
  #   geom = geom_text,
  #   mapping = aes(x = -.4, label = val),
  #   hjust = 0,
  # size = 1)  + 
  # HERE adding all the tips represented 
  # ggtree::geom_facet(
  #   panel = "labels", 
  #   data = all_represented_tips_df,
  #   geom = geom_text,
  #   mapping = aes(x = -.4, label = val),
  #   hjust = 0,
  #   size = 1)  + 
#)


# Adding Host familly panel 
ggnewscale::new_scale_fill() +
  ggtree::geom_facet(
    panel = "Family", 
    data = Host_family_facet_df2,
    geom = geom_bar,
    mapping = aes(x = value, fill = variable),
    orientation = 'y', 
    width = 1, 
    stat = "identity") +
  scale_fill_manual(values = host_families_color_pal,
                    name = "Host Family") +
  
  # Adding Host familly panel 
  # ggnewscale::new_scale_fill() +
  # ggtree::geom_facet(
  # panel = "Family", 
  # data = Host_family_facet_df2,
  # geom = geom_bar,
  # mapping = aes(x = value, fill = variable),
  # orientation = 'y', 
  # width = 1, 
  # stat = "identity") +
# scale_fill_manual(values = host_families_color_pal,
#                   name = "Host Family") +


ggtree::geom_facet(
  panel = "Host Latin", 
  data = Host_latin_facet_df,
  geom = geom_text,
  mapping = aes(x = -.4, label = val),
  hjust = 0,
  size = 1) +
  
  # ggtree::geom_facet(
  #   panel = "Host Latin", 
  #   data = Host_latin_facet_df,
  #   geom = geom_text,
  #   mapping = aes(x = -.4, label = val),
  #   hjust = 0,
  #   size = 1) +
  
  # collapsed_plot <- grop_redraw(explor_plot4, 
  #                               width_mult = c(1, .1, .1, .3, .1, .3, .3)
#         )

HERE for the labels

```{r}
# collapsed_plot_labels <- grop_redraw(explor_plot4, 
#                               width_mult = c(1, .1, .05, .05, .2, .05, .3, .5)
#         )
```



## Adding the isolates names
```{r}
explor_plot4$data %>% 
  print(n = 10, width = Inf)

test <- 
  explor_plot4$data %>%
  filter(label == "N1") %>%
  select(label, tip_metalink) 
test[1, "tip_metalink"] %>% 
  tibble(label = .) %>%
  unnest(label) 
print(width = Inf)
```

```{r}
unnest(tip_metalink)

```


subtree_N1732 <- 
  extract.clade(rooted_tree_nodelab, 
                "N1732",
                root.edge = 0, 
                collapse.singles = TRUE,
                interactive = FALSE)
  


```{r}
test <- 
  plot_subtree_N1732$data %>%
  filter(isTip, inNorway) %>%
  arrange(desc(y)) %>%
  head()

# Here adding the tip labels 
# This is all jumbled too many - so we put that aside in a panel
# ggtree::geom_tiplab(aes(label = Isolate_Id),
#                     size = .5,
#                     hjust = 1e-4,
#                     align = FALSE) + 


# we need to trick to get the tree in the background layer
# geom_tippoint(size = .1, alpha = 0) +

