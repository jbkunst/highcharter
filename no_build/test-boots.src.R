
n <- 50000

x <- sin(4*2*pi*seq(n)/n) + rnorm(n)/10

plot(x)

highchart() %>% 
  hc_title(text = sprintf("Drawin %s points", n)) %>% 
  hc_chart(zoomType = "x") %>% 
  hc_tooltip(valueDecimals = 2) %>% 
  hc_add_series(data = x, lineWidth = 0.5)


library("MASS")

# n <- 4999
n <- 5000

sigma <- matrix(c(10,3,3,2),2,2)
sigma

mvr <- round(mvrnorm(n, rep(0, 2), sigma), 4)

ds <- list.parse2(as.data.frame(mvr))

head(ds)

highchart() %>% 
  hc_xAxis(min = min(mvr[, 1]), max = max(mvr[, 1])) %>% 
  hc_yAxis(min = min(mvr[, 2]), max = max(mvr[, 2])) %>% 
  hc_chart(zoomType = "xy") %>% 
  hc_legend(enabled = FALSE) %>% 
  hc_add_series(data = ds,
                type = "scatter",
                color = 'rgba(152,0,67,0.9)',
                marker = list(radius =  0.8),
                tooltip = list(
                  followPointer = FALSE,
                  pointFormat = '[{point.x:.1f}, {point.y:.1f}]'
                )) %>% 
  hc_plotOptions(series =
                   list(
                     turboThreshold = 5000,
                     enableMouseTracking = FALSE
                   )
  )

