library(dplyr)
library(highcharter)
n <- 100
df <- data_frame(
  x = rnorm(n),
  y = x * 2 + rnorm(n),
  w =  x^2,
  series = sample(c("a","b","c","eee"), 100, replace = TRUE)
)

highchart() %>%
  hc_add_series_df(data = df, 
                   type = "point", 
                   x = x, 
                   y = y,
                   name = series)

hchart(df, "point", hcaes(x, y, name = series))

highchart() %>% 
  hc_add_series(df, "point", hcaes(x, y))

highchart() %>% 
  hc_add_series(df, "point", hcaes(x, y, name = series))

highcharter:::hc_add_series.data.frame
highcharter:::hchart.data.frame

