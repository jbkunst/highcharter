library(reshape2)
library(highcharter)

n <- 120
a <- matrix(rnorm(n*n), nrow = n, ncol = n)
b <- melt(a)
head(b)

t0 <- Sys.time()
hchart(b, "heatmap", hcaes(x = Var1, y = Var2, value = value))
message(Sys.time() - t0)

names(b) <- c("x", "y", "value")
b$value <- round(b$value, 3)
t0 <- Sys.time()
hchart(b, "heatmap", hcaes(x, y, value = value))
message(Sys.time() - t0)



# t0 <- Sys.time()
# hchart(a)
# print(Sys.time() - t0)

