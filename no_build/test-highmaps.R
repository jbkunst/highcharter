rm(list = ls())


#### EX 1  ####
library("purrr")
library("dplyr")

url <- "https://code.highcharts.com/mapdata/custom/world.js"
tmpfile <- tempfile(fileext = ".json")
download.file(url, tmpfile)

world <- readLines(tmpfile)
world <- gsub(".* = ", "", world)

map <- jsonlite::fromJSON(world, simplifyVector = FALSE)

data(GNI2010, package = "treemap")

head(GNI2010)

ddta <- GNI2010 %>% 
  select(iso3, value = GNI) %>% 
  rlist::list.parse() %>% 
  setNames(NULL)

head(ddta)

highchart(type = "map", debug = TRUE) %>% 
  hc_title(text = "Gross national income") %>% 
  hc_colorAxis(min = 0, minColor = "#440154", maxColor = "#FDE725") %>% 
  hc_mapNavigation(enabled = TRUE) %>% 
  hc_add_series(mapData = map, data = ddta,
                joinBy = c("iso-a3", "iso3"), name = "GNI",
                states = list(hover = list(color = "#BADA55")),
                dataLabels = list(enabled = TRUE,
                                  format = "{point.name}"))

#### EX 2 ####

url <- "https://code.highcharts.com/mapdata/countries/us/us-all.js"
tmpfile <- tempfile(fileext = ".json")
download.file(url, tmpfile)
us <- readLines(tmpfile)
us <- gsub(".* = ", "", us)
substr(us, 0, 20)
map <- jsonlite::fromJSON(us, simplifyVector = FALSE)

highchart(type = "map", debug = TRUE) %>% 
  hc_add_series(name = 'Basemap',
                mapData = map)

#### EX 3 ####

library("geojsonio")
url <- "https://raw.githubusercontent.com/glynnbird/usstatesgeojson/master/california.geojson"
tmpfile <- tempfile(fileext = ".json")
download.file(url, tmpfile)
california <- geojson_read(tmpfile)


highchart(type = "map", debug = TRUE) %>% 
  hc_add_series(name = 'Basemap',
                mapData = california)



