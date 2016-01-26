rm(list = ls())
library("geojsonio")
library("jsonlite")
library("highcharter")
library("jsonview")


urlwd <- "https://raw.githubusercontent.com/johan/world.geo.json/master/countries.geo.json"
tmpfile <- tempfile(fileext = ".json")
download.file(urlwd, tmpfile)
world <- geojson_read(tmpfile)
names(world)

marine <- "http://cedeusdata.geosteiniger.cl/geoserver/wfs?srsName=EPSG%3A4326&typename=geonode%3Amundo_corrientes_maritimas&outputFormat=json&version=1.0.0&service=WFS&request=GetFeature" %>% 
  readLines() %>% 
  fromJSON(simplifyVector = FALSE)

volcano <- "http://cedeusdata.geosteiniger.cl/geoserver/wfs?srsName=EPSG%3A4326&typename=geonode%3Amundo_volcanes&outputFormat=json&version=1.0.0&service=WFS&request=GetFeature" %>% 
  readLines() %>% 
  fromJSON(simplifyVector = FALSE)


marine$features[[1]]$properties
volcano$features[[1]]$properties

highchart(type = "map", debug = TRUE) %>% 
  hc_add_series(mapData = world, showInLegend = FALSE) %>% 
  hc_add_series(data = marine, type = "mapline",
                name = "Marine currents", color = 'rgba(0, 0, 80, 0.50)',
                tooltip = list(pointFormat = "{point.properties.NOMBRE}")) %>% 
  hc_add_series(data = volcano, type = "mappoint",
                name = "Volcanos", color = 'rgba(255, 0, 80, 0.25)',
                tooltip = list(pointFormat = "{point.properties.NOMBRE}")) %>% 
  hc_title(text = "Testing geojson format")

