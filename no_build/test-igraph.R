rm(list = ls())
library("igraph")
library("readr")
library("highcharter")

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
object <- net
plot(net, layout = layout_nicely)


set.seed(10)
hchart(net)


net <- barabasi.game(80) 
set.seed(10)
hchart(net)

V(net)$degree <- degree(net, mode = "all")*3
V(net)$betweenness <- betweenness(net)

V(net)$color <- colorize_vector(V(net)$betweenness)
V(net)$size <- sqrt(V(net)$degree)

set.seed(10)
hchart(net)

