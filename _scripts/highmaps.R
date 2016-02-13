#' ---
#' layout: post
#' ---
#+echo=FALSE
rm(list = ls())
library("highcharter")

#'
#' ## Highmaps Examples
#' 
#' 
#' ### Charting Australian Airports
#' 
#' Download airports data around the globe filter them
#' and then transform to geojson data points to chart 
#' the airports over a map.
#' 
 
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

airportsmin <- airports %>% 
  filter(country == "Australia", tz_database_time_zone != "\\N") %>% 
  select(name, latitude, longitude, altitude) 

airpjson <- geojson_json(airportsmin, lat = "latitude", lon = "longitude")

highchart(type = "map") %>% 
  hc_title(text = "Airports in Australia") %>% 
  hc_add_series(mapData = map, showInLegend = FALSE,
                nullColor = "#A9CF54") %>% 
  hc_add_series(data = airpjson, type = "mappoint", dataLabels = list(enabled = FALSE),
                name = "Airports", color = 'rgba(250, 250, 250, 0.7)',
                tooltip = list(pointFormat = "{point.properties.name}: {point.properties.altitude} fts")) %>% 
  hc_mapNavigation(enabled = TRUE) %>% 
  hc_add_theme(hc_theme_db())


#' 
#' ### Charting Lines and Points 
#' 
#' Download data and plot point and lines. 
#'  


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
  hc_add_series(mapData = world, showInLegend = FALSE,
                nullColor = "#A9CF54") %>% 
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
  hc_mapNavigation(enabled = TRUE,
                   buttonOptions = list(
                     align = "right",
                     verticalAlign = "bottom")) %>% 
  hc_add_theme(hc_theme_economist())


#'
#' ### Charting county data
#' 
#' Source: http://www.arilamstein.com/blog/2016/01/25/mapping-us-religion-adherence-county-r/
#' 
#' This is a try to implement the choropleth using highcarter. Download the data:
#' 

library("haven")
library("dplyr")
library("stringr")

url <- "http://www.thearda.com/download/download.aspx?file=U.S.%20Religion%20Census%20Religious%20Congregations%20and%20Membership%20Study,%202010%20(County%20File).SAV"

data <- read_sav(url)

data[, tail(seq(ncol(data)), -560)]

data <- data %>% 
  mutate(CODE = paste("us",
                      tolower(STABBR),
                      str_pad(CNTYCODE, width = 3, pad = "0"),
                      sep = "-"))


library(highcharter)
data("uscountygeojson")

#' 
#' Adding viridis palette:
#' 
require("viridisLite")
n <- 32
dstops <- data.frame(q = 0:n/n, c = substring(viridis(n + 1), 0, 7))
dstops <- list.parse2(dstops)


highchart() %>% 
  hc_title(text = "Total Religious Adherents by County") %>% 
  hc_add_series_map(map = uscountygeojson, df = data,
                    value = "TOTRATE", joinBy = c("code", "CODE"),
                    name = "Adherents", borderWidth = 0.5) %>% 
  hc_colorAxis(stops = dstops, min = 0, max = 1000) %>% 
  hc_legend(layout = "vertical", reversed = TRUE,
            floating = TRUE, align = "right") %>% 
  hc_mapNavigation(enabled = TRUE, align = "right") %>% 
  hc_tooltip(valueDecimals = 0)
