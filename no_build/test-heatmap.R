library("plotly")

m <- matrix(rnorm(6), nrow = 3, ncol = 2)
plot_ly(z = m, x = c("a", "b"), y = c("d", "e", "f"), type = "heatmap")


