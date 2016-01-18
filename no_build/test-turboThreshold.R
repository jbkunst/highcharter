library("highcharter")
library("magrittr")
sessionInfo()


# hcopts <- getOption("highcharter.options")
# hcopts <- rlist::list.merge(
#   hcopts,
#   list(chart = list(
#     plotOptions = list(
#       series = list(
#         turboThreshold = 0
#       )
#     )
#   ))
# )
# options(highcharter.options = hcopts)

nyears <- 500

df <- expand.grid(seq(12) - 1, seq(nyears) - 1)
df$value <- abs(seq(nrow(df)) + 10 * rnorm(nrow(df))) + 10
df$value <- round(df$value, 2)

head(df)
tail(df)

nrow(df) == nyears*12

ds <- setNames(list.parse2(df), NULL)
head(ds)
tail(ds)

highchart() %>% 
  hc_chart(type = "heatmap") %>% 
  hc_title(text = "Simulated values by years and months") %>% 
  hc_xAxis(categories = month.abb) %>% 
  hc_yAxis(categories = 2016 - nyears + seq(nyears),
           showFirstLabel = FALSE,
           showLastLabel = FALSE) %>% 
  hc_add_serie(name = "value", data = ds) %>% 
  hc_colorAxis( minColor = "#FFFFFF", maxColor = "#434348")
