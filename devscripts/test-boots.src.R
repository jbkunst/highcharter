
n <- 50000

x <- sin(4*2*pi*seq(n)/n) + rnorm(n)/10

plot(x)

highchart2() %>%
  hc_chart(zoomType = "x") %>%
  hc_add_series(data = x)




library("MASS")
n <- 100000

sigma <- matrix(c(10,3,3,2),2,2)
sigma

mvr <- round(mvrnorm(n, rep(c(0, 0)), sigma), 4)

vx <- ceiling(1+abs(max(mvr[, 1])))
vy <- ceiling(1+abs(max(mvr[, 2])))

ds <- list.parse2(as.data.frame(mvr))

highchart2() %>%
  hc_chart(zoomType = "xy") %>%
  hc_xAxis(min = -vx, max = vx) %>% 
  hc_yAxis(min = -vy, max = vy) %>% 
  hc_add_series(data = ds, type = "scatter",
                color = 'rgba(250,250,250,0.1)',
                marker = list(radius = 2),
                tooltip = list(followPointer = FALSE,
                               pointFormat =  '[{point.x:.1f}, {point.y:.1f}]')) %>% 
  hc_add_theme(hc_theme_db())


