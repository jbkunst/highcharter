
library("httr")

world <- "https://raw.githubusercontent.com/johan/world.geo.json/master/countries.geo.json" %>% 
  GET() %>% 
  content() %>% 
  jsonlite::fromJSON(simplifyVector = FALSE)

# http://cedeusdata.geosteiniger.cl/layers/geonode:mundo_corrientes_maritimas
marine <- "http://cedeusdata.geosteiniger.cl/geoserver/wfs?srsName=EPSG%3A4326&typename=geonode%3Amundo_corrientes_maritimas&outputFormat=json&version=1.0.0&service=WFS&request=GetFeature" %>% 
  GET() %>% 
  content()

# http://cedeusdata.geosteiniger.cl/layers/geonode:mundo_limites_placas
plates <- "http://cedeusdata.geosteiniger.cl/geoserver/wfs?srsName=EPSG%3A4326&typename=geonode%3Amundo_limites_placas&outputFormat=json&version=1.0.0&service=WFS&request=GetFeature" %>% 
  GET() %>% 
  content()

# http://cedeusdata.geosteiniger.cl/layers/geonode:mundo_volcanes
volcano <- "http://cedeusdata.geosteiniger.cl/geoserver/wfs?srsName=EPSG%3A4326&typename=geonode%3Amundo_volcanes&outputFormat=json&version=1.0.0&service=WFS&request=GetFeature" %>% 
  GET() %>% 
  content()

highchart(type = "map") %>% 
  hc_title(text = "Marine Currents, Plates & Volcanos") %>% 
  hc_chart(backgroundColor = "#D9E9FF") %>% 
  hc_add_series(mapData = world, showInLegend = FALSE,
                nullColor = "#C0D890") %>% 
  hc_add_series(data = marine, type = "mapline",  lineWidth = 2,
                name = "Marine currents", color = 'rgba(0, 0, 80, 0.33)',
                states = list(hover = list(color = "#BADA55")),
                tooltip = list(pointFormat = "{point.properties.NOMBRE}")) %>%
  hc_add_series(data = plates, type = "mapline",
                name = "Plates", color = 'rgba(5, 5, 5, 0.5)',
                tooltip = list(pointFormat = "{point.properties.TIPO}")) %>% 
  hc_add_series(data = volcano, type = "mappoint",
                name = "Volcanos", color = 'rgba(200, 10, 80, 0.5)',
                tooltip = list(pointFormat = "{point.properties.NOMBRE}")) %>%
  hc_mapNavigation(enabled = TRUE)
