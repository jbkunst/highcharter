#' http://stackoverflow.com/questions/41533909/how-to-make-synchronized-charts-for-highcharts-in-r
library(highcharter)
library(dplyr)
options(highcharter.theme = hc_theme_smpl())


d <- data_frame(week = rep(1:5, 2),
                value = sample(1:10),
                key = rep(c("days", "proc"), each = 5))


hchart(d, "column", hcaes(x = week, y = value, group = key))

hchart(d, "column", hcaes(x = week, y = value, group = key), yAxis = c(0, 1)) %>% 
  hc_yAxis_multiples(create_yaxis(2)) %>% 
  hc_tooltip(shared = TRUE)

