library(highcharter)
library(tidyverse)
library(geojsonio)
library(httr)

dataTable <- "code	latitude	longitude	z
AAA	30.322500	-9.411388	1200
BBB	50.901390	4.484444	9120
CCC	25.252777	55.364445	41200" 

dataTable <- textConnection(dataTable)
dataTable <- read.table(dataTable, sep = "\t", stringsAsFactors = FALSE, header = TRUE)
dataTable <- as.tbl(dataTable)
dataTable


world <- "https://raw.githubusercontent.com/johan/world.geo.json/master/countries.geo.json" %>% 
  GET() %>% 
  content() %>% 
  jsonlite::fromJSON(simplifyVector = FALSE)

parksgjs <- geojson_json(dataTable, lat = "latitude", lon = "longitude")
# parksgjs <- list_parse(dataTable)

highchart(type = "map") %>% 
  hc_title(text = "Most frequented place") %>% 
  hc_add_series(mapData = world,  nullColor = "#425668", showInLegend = FALSE) %>% 
  hc_add_series(data = parksgjs , type = "mappoint",
                color = "yellow", dataLabels = list(enabled = FALSE),
                minSize= 4, maxSize= 20) %>%
  hc_mapNavigation(enabled = TRUE,
                   buttonOptions = list(
                     align = "right",
                     verticalAlign = "bottom"))


