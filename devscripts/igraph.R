rm(list = ls())
library("igraph")
library("readr")
library("dplyr")
library("highcharter")

layout <- layout_nicely
urlb <- "https://raw.githubusercontent.com/kateto/R-Network-Visualization-Workshop/master/Data"
nodes <- read_csv(file.path(urlb, "Dataset1-Media-Example-NODES.csv"))
links <- read_csv(file.path(urlb, "Dataset1-Media-Example-EDGES.csv"))
links <- links %>% 
  group_by(from, to) %>% 
  summarise(weight = sum(weight)) %>% 
  ungroup()


net <- graph.data.frame(links, nodes, directed = TRUE)
net


V(net)$color <- colorize_vector(V(net)$media.type)
V(net)$size <- V(net)$audience.size*0.6
V(net)$label <- V(net)$media

E(net)$width <- E(net)$weight/6
E(net)$color <- V(net)$color[get.edges(net, 1:ecount(net))[,1]]

set.seed(10)
plot(object <- net, layout = layout_nicely)

set.seed(10)
hchart(net)

set.seed(10)
hchart(net, minSize = 5, maxSize = 20)

V(net)$label <- NA
hchart(net, minSize = 5, maxSize = 20) 

net <- remove.vertex.attribute(net, "size")
hchart(net)

library("igraph")
net <- barabasi.game(200) 
hchart(net)

V(net)$degree <- degree(net, mode = "all")*3
V(net)$betweenness <- betweenness(net)
V(net)$color <- colorize_vector(V(net)$betweenness)
V(net)$size <- sqrt(V(net)$degree)
V(net)$label <- seq_along(V(net)$size)
hchart(net, minSize = 5, maxSize = 20)

set.seed(10)
plot(net)


library("rgexf")
library("stringr")
library("purrr")
library("resolution")

net <- "http://media.moviegalaxies.com/gexf/316.gexf" %>% 
  # "http://media.moviegalaxies.com/gexf/92.gexf" %>% 
  read_lines() %>% 
  read.gexf() %>% 
  gexf.to.igraph()

V(net)$name <- str_to_title(V(net)$name)
V(net)$label <- V(net)$name %>% 
  str_extract_all("^\\w{2}| \\w") %>% 
  map_chr(function(x) {
    x %>% unlist() %>% str_c(collapse = "")
  })
V(net)$size <- degree(net)  # page.rank(net)$vector

cl <- cluster_resolution(net)

V(net)$comm <- membership(cl)
table(V(net)$comm)

V(net)$color <- colorize_vector(V(net)$comm)


plot(net)
hchart(net, minSize = 10, maxSize = 20)
