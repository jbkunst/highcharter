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

# http://cedeusdata.geosteiniger.cl/layers/geonode:mundo_corrientes_maritimas
marine <- "http://cedeusdata.geosteiniger.cl/geoserver/wfs?srsName=EPSG%3A4326&typename=geonode%3Amundo_corrientes_maritimas&outputFormat=json&version=1.0.0&service=WFS&request=GetFeature" %>% 
  readLines() %>% 
  fromJSON(simplifyVector = FALSE)

# http://cedeusdata.geosteiniger.cl/layers/geonode:mundo_limites_placas
plates <- "http://cedeusdata.geosteiniger.cl/geoserver/wfs?srsName=EPSG%3A4326&typename=geonode%3Amundo_limites_placas&outputFormat=json&version=1.0.0&service=WFS&request=GetFeature" %>% 
  readLines() %>% 
  fromJSON(simplifyVector = FALSE)

# http://cedeusdata.geosteiniger.cl/layers/geonode:mundo_volcanes
volcano <- "http://cedeusdata.geosteiniger.cl/geoserver/wfs?srsName=EPSG%3A4326&typename=geonode%3Amundo_volcanes&outputFormat=json&version=1.0.0&service=WFS&request=GetFeature" %>% 
  readLines() %>% 
  fromJSON(simplifyVector = FALSE)


# http://cedeusdata.geosteiniger.cl/layers/geonode:mundo_placas_tectonicas
# plates2 <- "http://cedeusdata.geosteiniger.cl/geoserver/wfs?srsName=EPSG%3A4326&typename=geonode%3Amundo_placas_tectonicas&outputFormat=json&version=1.0.0&service=WFS&request=GetFeature" %>% 
#   readLines() %>% 
#   fromJSON(simplifyVector = FALSE)



# http://cedeusdata.geosteiniger.cl/layers/geonode:mundo_zonas_geologicas
# http://cedeusdata.geosteiniger.cl/layers/geonode:mundo_naciones

marine$features[[1]]$properties
volcano$features[[1]]$properties
plates$features[[1]]$properties

hc <- highchart(type = "map", debug = TRUE) %>% 
  hc_add_series(mapData = world, showInLegend = FALSE) %>% 
  hc_add_series(data = marine, type = "mapline",
                name = "Marine currents", color = 'rgba(0, 0, 80, 0.75)',
                states = list(hover = list(color = "#BADA55")),
                tooltip = list(pointFormat = "{point.properties.NOMBRE}")) %>%
  hc_add_series(data = plates, type = "mapline",
                name = "Plates", color = 'rgba(10, 10, 10, 0.5)',
                tooltip = list(pointFormat = "{point.properties.TIPO}")) %>% 
  hc_add_series(data = volcano, type = "mappoint",
                name = "Volcanos", color = 'rgba(255, 0, 80, 0.5)',
                tooltip = list(pointFormat = "{point.properties.NOMBRE}")) %>%
  hc_mapNavigation(enabled = TRUE) %>% 
  hc_title(text = "Testing geojson format")


hc


