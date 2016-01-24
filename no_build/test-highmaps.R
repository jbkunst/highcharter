highchart(debug = TRUE) %>%  hc_add_series_ts(AirPassengers)

library("geojsonio")
library("V8")


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



url <- "https://code.highcharts.com/mapdata/custom/world.js"
tmpfile <- tempfile(fileext = ".json")
download.file(url, tmpfile)

world <- readLines(tmpfile)
world <- gsub(".* = ", "", world)
substr(world, 0, 20)

map <- jsonlite::fromJSON(world, simplifyVector = FALSE)

highchart(type = "map", debug = TRUE) %>% 
  hc_add_series(name = 'Basemap',
                mapData = map)



url <- "https://raw.githubusercontent.com/glynnbird/usstatesgeojson/master/california.geojson"
tmpfile <- tempfile(fileext = ".json")
download.file(url, tmpfile)
california <- geojson_read(tmpfile)


highchart(type = "map", debug = TRUE) %>% 
  hc_add_series(name = 'Basemap',
                mapData = california)



