#' ---
#'  title: "Technology Clusters"
#'  author: Joshua
#'  date: "Today"
#'  output: 
#'    flexdashboard::flex_dashboard:
#'      orientation: columns
#'      source_code: embed
#' ---
  
#+ include=FALSE
library(highcharter)
library(readr)
library(dplyr)
library(igraph)

# This shared file contains the number of question that have each pair of tags
# This counts only questions that are not deleted and have a positive score

tag_pair_data <- read_csv("~/../Downloads/tag_pairs.csv.gz")

relationships <- tag_pair_data %>%
  mutate(Fraction = Cooccur / Tag1Total) %>%
  filter(Fraction >= .35) %>%
  distinct(Tag1)

v <- tag_pair_data %>%
  select(Tag1, Tag1Total) %>%
  distinct(Tag1) %>%
  filter(Tag1 %in% relationships$Tag1 |
           Tag1 %in% relationships$Tag2) %>%
  arrange(desc(Tag1Total))

g <- graph.data.frame(relationships, directed = FALSE, vertices = v)

wc <- cluster_walktrap(g)

nc <- length(unique(membership(wc)))

V(g)$label <- V(g)$name
V(g)$page_rank <- round(page.rank(g)$vector, 2)
V(g)$page_rank <- round(page.rank(g)$vector, 2)
V(g)$betweenness <- round(betweenness(g), 2)
V(g)$degree <- degree(g)
V(g)$size <- V(g)$degree
V(g)$comm <- membership(wc)
V(g)$color <- colorize(membership(wc))

#+
hchart(g, minSize = 5, maxSize = 40) %>% 
  hc_chart(zoomType = "xy")
