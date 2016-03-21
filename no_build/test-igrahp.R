rm(list = ls())

library("igraph")
library("plyr")

dataSet <- read.table("http://www.vesnam.com/Rblog/wp-content/uploads/2013/07/lesmis.txt", header = FALSE, sep = "\t")
gD <- simplify(graph.data.frame(dataSet, directed=FALSE))

degAll <- degree(gD, v = V(gD), mode = "all")
betAll <- betweenness(gD, v = V(gD), directed = FALSE) / (((vcount(gD) - 1) * (vcount(gD)-2)) / 2)
betAll.norm <- (betAll - min(betAll))/(max(betAll) - min(betAll))
rm(betAll)
dsAll <- similarity.dice(gD, vids = V(gD), mode = "all")

gD <- set.vertex.attribute(gD, "degree", index = V(gD), value = degAll)
gD <- set.vertex.attribute(gD, "betweenness", index = V(gD), value = betAll.norm)


F1 <- function(x) {data.frame(V4 = dsAll[which(V(gD)$name == as.character(x$V1)), which(V(gD)$name == as.character(x$V2))])}
dataSet.ext <- ddply(dataSet, .variables=c("V1", "V2", "V3"), function(x) data.frame(F1(x)))

gD <- set.edge.attribute(gD, "weight", index = E(gD), value = 0)
gD <- set.edge.attribute(gD, "similarity", index = E(gD), value = 0)

E(gD)[as.character(dataSet.ext$V1) %--% as.character(dataSet.ext$V2)]$weight <- as.numeric(dataSet.ext$V3)
E(gD)[as.character(dataSet.ext$V1) %--% as.character(dataSet.ext$V2)]$similarity <- as.numeric(dataSet.ext$V4)


library("dplyr")
library("purrr")
library("highcharter")
plot.igraph(gD, layout = layout_nicely)

str(gD)

object <- gD
layout <- layout_nicely

lyout <- layout(object)


dfvertex <- object %>% 
  get.vertex.attribute() %>%
  as.data.frame() %>% 
  dplyr::tbl_df() %>% 
  mutate(x = lyout[, 1],
         y = lyout[, 2]) 

dfedge <-  object %>%
  get.edgelist %>% 
  as.data.frame() %>% 
  dplyr::tbl_df() %>% 
  setNames(c("from", "to"))

dfedgeextra <- object %>% 
  get.edge.attribute() %>% 
  as.data.frame() %>% 
  dplyr::tbl_df()
 
dfedge <- dfedge %>% 
  cbind(dfedgeextra) %>% 
  dplyr::tbl_df() %>% 
  left_join(dfvertex %>% select(name, x, y) %>% setNames(c("from", "xf", "yf"))) %>% 
  left_join(dfvertex %>% select(name, x, y) %>% setNames(c("to", "xt", "yt")))
  

hc <- highchart() %>% 
  hc_add_serie(data = list.parse3(dfvertex), type = "scatter",
               name = "nodes", zIndex = 3) %>% 
  hc_add_series(data = NULL, name = "edges", id = "e") %>% 
  hc_mapNavigation(enabled = TRUE) %>% 
  hc_add_theme(
    hc_theme_null(
      legend = list(
        enabled = TRUE
      )
    )
  )

dsedges <- dfedge %>%
  list.parse3() %>% 
  map(function(x) {
    # x <- sample( dfedge %>% list.parse3(), 1)[[1]]
    y <- list(
      data = list(
        list(x = x$xf, y = x$yf),
        list(x = x$xt, y = x$yt)
        ),
      linkedTo = "e"
      )
    
    y
    
  })

hc$x$hc_opts$series <- append(
  hc$x$hc_opts$series,
  dsedges
  )

hc

# plot.igraph(gD, layout = lyout)

