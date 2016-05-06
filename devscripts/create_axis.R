library("highcharter")

highchart() %>%
  hc_yAxis_multiples(create_yaxis(naxis = 4, title = list(text = NULL))) %>%
  hc_add_series(data = c(1,3,2)) %>%
  hc_add_series(data = c(20, 40, 10), yAxis = 1) %>%
  hc_add_series(data = c(200, 400, 500), type = "column", yAxis = 2) %>%
  hc_add_series(data = c(500, 300, 400), type = "column", yAxis = 2) %>% 
  hc_add_series(data = c(5,4,7), type = "spline", yAxis = 3)


suppressPackageStartupMessages(library("PerformanceAnalytics"))


data(edhec)
R <- edhec[, 1:3]
hc <- highchart(type = "stock")
hc <- hc_yAxis_multiples(hc, create_yaxis(naxis = 3, heights = c(2,1,1)))

for(i in 1:ncol(R)) {
  hc <- hc_add_series_xts(hc, R[, i], yAxis = i - 1, name = names(R)[i])
}

hc <- hc_scrollbar(hc, enabled = TRUE) %>%
  hc_add_theme(hc_theme_flat())

hc
rm(list = ls())
