rm(list = ls())
library("igraph")
library("readr")
library("dplyr")
library("highcharter")

urlb <- "https://raw.githubusercontent.com/kateto/R-Network-Visualization-Workshop/master/Data"

nodes <- read_csv(file.path(urlb, "Dataset1-Media-Example-NODES.csv"))
links <- read_csv(file.path(urlb, "Dataset1-Media-Example-EDGES.csv"))
links <- links %>% 
  group_by(from, to) %>% 
  summarise(weight = sum(weight)) %>% 
  ungroup()

net <- graph.data.frame(links, nodes, directed = TRUE)

V(net)$color <- colorize_vector(V(net)$media.type)
V(net)$size <- V(net)$audience.size*0.6
V(net)$label <- V(net)$media

E(net)$width <- E(net)$weight/6
# E(net)$color <- V(net)$color[get.edges(net, 1:ecount(net))[,1]]

set.seed(10)
plot(net, layout = layout_nicely)

set.seed(10)
hchart(net)

hchart(net, minSize = 25, maxSize = 30, marker = list(fillOpacity = 0.25))

net <- remove.vertex.attribute(net, "label")
hchart(net)


#### Example 2
net <- barabasi.game(500) 
V(net)$degree <- degree(net, mode = "all")*3
V(net)$betweenness <- betweenness(net)
V(net)$color <- colorize_vector(V(net)$betweenness)
V(net)$size <- sqrt(V(net)$degree)
hchart(net, digits = 2)



library("rgexf")
library("stringr")
library("purrr")
library("resolution")

id <- 316 # Forrest
id <- 110 # BatmanReturns
id <- 92 # Babel

net <- sprintf("http://media.moviegalaxies.com/gexf/%s.gexf", id) %>% 
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
V(net)$color <- colorize_vector(V(net)$comm, option = "A")
E(net)$color <-  hex_to_rgba("#d3d3d3", 0.15)

plot(net)
hchart(net, minSize = 10, marker = list(fillOpacity = .75)) %>% 
  hc_add_theme(
    hc_theme_merge(
      hc_theme_null(),
      hc_theme_db(chart = list(backgroundColor = "black"))
      )
    ) 
