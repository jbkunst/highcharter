library("ape")
library("ggdendro")

hc <- hclust(dist(mtcars))

plot(hc)
plot(as.dendrogram(hc))
plot(as.dendrogram(hc), type = "triangle")
plot(as.phylo(hc))
plot(as.phylo(hc), type = "cladogram")
plot(as.phylo(hc), type = "unrooted")
plot(as.phylo(hc), type = "fan")
plot(as.phylo(hc), type = "radial")
