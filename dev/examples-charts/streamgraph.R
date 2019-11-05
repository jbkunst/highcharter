# install.packages("ggplot2movies")
data(movies, package = "ggplot2movies")

df <- movies  %>%
  dplyr::select(year, Action, Animation, Comedy, Drama, Documentary, Romance, Short) %>%
  tidyr::gather(genre, value, -year) %>%
  group_by(year, genre) %>%
  summarise(n = sum(value)) %>% 
  ungroup()

df

hchart(df, "streamgraph", hcaes(year, n, group = genre)) %>% 
  hc_yAxis(visible = FALSE)
