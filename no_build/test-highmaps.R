highchart(debug = TRUE) %>%  hc_add_series_ts(AirPassengers)

library("geojsonio")
library("V8")



url <- "https://raw.githubusercontent.com/glynnbird/usstatesgeojson/master/california.geojson"
tmpfile <- tempfile(fileext = ".json")
download.file(url, tmpfile)
california <- geojson_read(tmpfile)


url <- "https://code.highcharts.com/mapdata/countries/us/us-all.js"
tmpfile <- tempfile(fileext = ".json")
download.file(url, tmpfile)

us <- readLines(tmpfile)
us <- gsub(".* = ", "", us)
head(us)

map <- jsonlite::fromJSON(us)


highchart(type = "map", debug = TRUE) %>% 
  hc_add_series(name = 'Basemap',
                mapData = map)
