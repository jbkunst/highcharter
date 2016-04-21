rm(list = ls())
library("dplyr")
library("readr")
library("httr")
library("rvest")
library("geojsonio")

map <- "https://raw.githubusercontent.com/johan/world.geo.json/master/countries/AUS.geo.json" %>% 
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

colalt <- function(x){
  colorRamp(viridisLite::plasma(10), alpha = FALSE)(x) %>% 
    {./255} %>%
    rgb()
  }

airportsmin <- airports %>% 
  filter(country == "Australia", tz_database_time_zone != "\\N") %>% 
  select(name, latitude, longitude, altitude) 

airpjson <- geojson_json(airportsmin, lat = "latitude", lon = "longitude")

highchart(type = "map") %>% 
  hc_title(text = "Airports in Australia") %>% 
  hc_chart(backgroundColor = "#D9E9FF") %>% 
  hc_add_series(mapData = map, showInLegend = FALSE,
                nullColor = "#C0D890") %>% 
  hc_add_series(data = airpjson, type = "mappoint", dataLabels = list(enabled = FALSE),
                name = "Airports", color = 'rgba(57, 86, 139, 0.5)',
                tooltip = list(pointFormat = "{point.properties.name}: {point.properties.altitude} fts")) %>% 
  hc_mapNavigation(enabled = TRUE) 


