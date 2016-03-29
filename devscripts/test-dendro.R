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


library("ggplot2")
library("ggdendro")

hc <- hclust(dist(mtcars))
hcdata <- dendro_data(hc, type="rectangle")
ggplot() + 
  geom_segment(data=segment(hcdata), aes(x=x, y=y, xend=xend, yend=yend)) +
  geom_text(data=label(hcdata), aes(x=x, y=y, label=label, hjust=0), size=3) +
  coord_flip() + 
  scale_y_reverse(expand=c(0.2, 0))

### demonstrate plotting directly from object class hclust
ggdendrogram(hc)
ggdendrogram(hc, rotate = TRUE)

### demonstrate converting hclust to dendro using dendro_data first
hcdata <- dendro_data(hc)
ggdendrogram(hcdata, rotate=TRUE) + 
  labs(title="Dendrogram in ggplot2") + 
  coord_polar() + 
  scale_y_reverse()





hc <- hclust(dist(USArrests), "ave")
plot(hc)
### demonstrate converting hclust to dendro using dendro_data first
hcdata <- dendro_data(hc)
ggdendrogram(hcdata, rotate=FALSE, size=2) + labs(title="Dendrogram in ggplot2 - Rotate=F; segments not modified; downwards")
ggdendrogram(hcdata, rotate=TRUE, size=2) + labs(title="Dendrogram in ggplot2 - Rotate=T; segments not modified; rightwards")


hcdata$segments[["y"]] <- abs(hcdata$segments[["y"]] - max(hcdata$segments[["y"]]))
hcdata$segments[["yend"]] <- abs(hcdata$segments[["yend"]] - max(hcdata$segments[["yend"]]))

ggdendrogram(hcdata, rotate=TRUE, size=2) + labs(title="Dendrogram in ggplot2- Rotate=T; segments modified; leftwards")
ggdendrogram(hcdata, rotate=FALSE, size=2) + labs(title="Dendrogram in ggplot2- Rotate=F; segments modified; upwards")

ggdendrogram(hcdata) + labs(title="Dendrogram in ggplot2 - Fan") + coord_polar()
