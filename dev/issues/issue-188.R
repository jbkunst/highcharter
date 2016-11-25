library(highcharter)

data(worldgeojson, package = "highcharter")
data("GNI2014", package = "treemap")

head(GNI2014)

GNI2014$value <- GNI2014$population # to make a choropleth

highchart(type = "map") %>% 
  hc_add_series(mapData = worldgeojson, data = list_parse(GNI2014),
                joinBy = "iso3") %>% 
  hc_colorAxis() %>% 
  hc_tooltip(useHTML = TRUE, headerFormat = "",
             pointFormat = "this is {point.name} and have {point.population} people with gni of {point.GNI}")

