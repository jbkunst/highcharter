rm(list = ls())
library("dplyr")
library("readr")
library("httr")
library("rvest")
library("geojsonio")

world <- "https://raw.githubusercontent.com/johan/world.geo.json/master/countries.geo.json" %>% 
  GET() %>% 
  content() %>% 
  jsonlite::fromJSON(simplifyVector = FALSE)

# http://openflights.org/data.html
airports <- read_csv("https://raw.githubusercontent.com/jpatokal/openflights/master/data/airports.dat",
                     col_names = FALSE)

tblnames <- read_html("http://openflights.org/data.html") %>% 
  html_node("table") %>% 
  html_table(fill = TRUE)

airports <- setNames(airports, str_to_id(tblnames$X1))

airportsmin <- airports %>%
  filter(altitude >= 1500) %>% 
  select(name, latitude, longitude)

airpjson <- geojson_json(airportsmin, lat = "latitude", lon = "longitude")

highchart(type = "map") %>% 
  hc_chart(backgroundColor = "black") %>% 
  hc_add_series(mapData = world, color = "#606060", showInLegend = FALSE) %>% 
  hc_add_series(data = airpjson, type = "mappoint",
                name = "Airports", color = 'rgba(255, 0, 0, 0.5)',
                tooltip = list(pointFormat = "{point.properties.name}")) %>% 
  hc_mapNavigation(enabled = TRUE) 

