rm(list = ls())
library("highcharter")
library("purrr")

data("usgeojson")
data("uscountygeojson")


names(usgeojson$features[[1]])

usgeojson$features <- usgeojson$features %>% 
  map(function(x){
    x$drilldown <- x$properties[["code"]]
    x$value <- ceiling(abs(rnorm(1)*2))
    x$properties$code <- gsub("us-", "", x$properties$code)
    x
  })

names(usgeojson$features[[1]])
usgeojson$features[[1]][-4]

highchart(type = "map") %>% 
  hc_add_series(data = usgeojson, name = "USA", type = "map",
                dataLabels = list(enabled = TRUE, format = "{point.properties.code}")) %>% 
  hc_colorAxis(min = 0, minColor = "#E6E7E8", maxColor = "#005645") 

