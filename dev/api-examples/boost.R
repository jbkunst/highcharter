#  Ex 1
n <- 50000

x <- sin(4*2*pi*seq(n)/n) + rnorm(n)/10

x <- round(x, 3)

plot(x)

highchart() %>%
  hc_chart(zoomType = "x") %>%
  hc_add_series(data = x) %>% 
  hc_title(text = "No boost") %>% 
  hc_boost(
    enabled = FALSE # Not recommended
  )

highchart() %>%
  hc_chart(zoomType = "x") %>%
  hc_add_series(data = x) %>% 
  hc_title(text = "With boost") %>% 
  hc_boost(
    enabled = TRUE # Default :D
  )

# Ex 2
library(MASS)

n <- 100000

sigma <- matrix(c(10,3,3,2),2,2)
sigma

mvr <- round(mvrnorm(n, rep(c(0, 0)), sigma), 6)

vx <- ceiling(1+abs(max(mvr[, 1])))
vy <- ceiling(1+abs(max(mvr[, 2])))

ds <- list_parse2(as.data.frame(mvr))

highchart() %>%
  hc_chart(zoomType = "xy") %>%
  hc_xAxis(min = -vx, max = vx) %>% 
  hc_yAxis(min = -vy, max = vy) %>% 
  hc_add_series(
    data = ds,
    type = "scatter",
    name = "A lot of points!",
    color = 'rgba(0,0,0,0.01)',
    marker = list(radius = 2),
    tooltip = list(
      followPointer = FALSE,
      pointFormat =  '[{point.x:.1f}, {point.y:.1f}]'
      )
    )
