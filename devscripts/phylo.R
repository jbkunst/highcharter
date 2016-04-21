library("ape")
library("igraph")
library("highcharter")


object <- as.phylo(hclust(dist(mtcars)))
class(object)
plot(object)
hchart(object)


hchart.phylo <- function(object, ...) {

  object <- as.igraph(object)
  
  V(object)$size <- ifelse(str_detect(V(object)$name, "Node\\d+"), 0, 1)
  
  hchart(object, minSize = 0)
    
}

tr <- rcoal(5)
(x <- evonet(tr, 6:7, 8:9))
plot(x)
