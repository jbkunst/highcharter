#' ---
#' layout: post
#' ---
#+echo=FALSE
rm(list = ls())
library("highcharter")

#'
#' ## Highmaps Examples
#' 
#' <div id ="toc"></div>
#'
#' ### World Chart
#' 
library("viridisLite")

data(worldgeojson, package = "highcharter")
data("GNI2010", package = "treemap")

dshmstops <- data.frame(q = c(0, exp(1:5)/exp(5)),
                        c = substring(viridis(5 + 1, option = "D"), 0, 7)) %>% 
  list.parse2()

highchart() %>% 
  hc_add_series_map(worldgeojson, GNI2010, value = "population", joinBy = "iso3") %>% 
  hc_colorAxis(stops = dshmstops) %>% 
  hc_legend(enabled = TRUE) %>% 
  hc_add_theme(hc_theme_db()) %>% 
  hc_mapNavigation(enabled = TRUE)

#'
#' ### Charting county data
#' 
#' Original source: http://www.arilamstein.com/blog/2016/01/25/mapping-us-religion-adherence-county-r/
#' 
library("haven")
library("dplyr")
library("stringr")
library("viridisLite")
data("uscountygeojson")

url <- "http://www.thearda.com/download/download.aspx?file=U.S.%20Religion%20Census%20Religious%20Congregations%20and%20Membership%20Study,%202010%20(County%20File).SAV"

data <- read_sav(url)

data <- data %>% 
  mutate(CODE = paste("us",
                      tolower(STABBR),
                      str_pad(CNTYCODE, width = 3, pad = "0"),
                      sep = "-"))

n <- 32
dstops <- data.frame(q = 0:n/n, c = substring(viridis(n + 1, option = "B"), 0, 7))
dstops <- list.parse2(dstops)

highchart() %>% 
  hc_title(text = "Total Religious Adherents by County") %>% 
  hc_add_series_map(map = uscountygeojson, df = data,
                    value = "TOTRATE", joinBy = c("code", "CODE"),
                    name = "Adherents", borderWidth = 0.1) %>% 
  hc_colorAxis(stops = dstops, min = 0, max = 1000) %>% 
  hc_legend(layout = "vertical", reversed = TRUE,
            floating = TRUE, align = "right") %>% 
  hc_mapNavigation(enabled = TRUE, align = "right") %>% 
  hc_tooltip(valueDecimals = 0)

#'
#' ### geojsonio package and FontAwesome plugin
#' 
library("rvest")
library("dplyr")
library("stringr")
library("geojsonio")
library("sp")
library("purrr")
library("ggmap")

california <- geojson_read(system.file("examples/california.geojson", package = "geojsonio"))

airports <- read_html("http://www.mapsofworld.com/usa/states/california/california-airports.html") %>% 
  html_table() %>% 
  .[[3]] %>% 
  cbind(.$Coordinates %>% 
          str_split(" ") %>% 
          str_extract_all("\\d+") %>% 
          map_df(function(e){
            data_frame(x = paste0(e[1], "d", e[2], "'", e[3], "\"", " ", "N"),
                       y = paste0(e[4], "d", e[5], "'", e[6], "\"", " ", "W")) %>% 
              mutate(lon = y %>% char2dms %>% as.numeric,
                     lat = x %>% char2dms %>% as.numeric)
          })) %>% 
  tbl_df() %>% 
  setNames(str_to_id(names(.)))

parks <- read_html("http://www.theguardian.com/travel/2013/sep/17/top-10-national-parks-california") %>% 
  html_nodes(".content__article-body > h2") %>% 
  html_text() %>% 
  str_trim() %>% 
  data_frame(park = .) %>% 
  cbind(geocode(paste(.$park, "california"), messaging = FALSE))


ports <- read_html("https://en.wikipedia.org/wiki/Category:Ports_and_harbors_of_California") %>% 
  html_nodes(".mw-category-group > ul > li") %>% 
  html_text() %>% 
  str_trim() %>% 
  data_frame(port = .) %>% 
  cbind(geocode(paste(.$port, "california"), messaging = FALSE)) %>% 
  filter(!is.na(lon) & port != "Alcatraz Wharf")


airptgjs <- geojson_json(airports, lat = "lat", lon = "lon")
parksgjs <- geojson_json(parks, lat = "lat", lon = "lon")
portsgjs <- geojson_json(ports, lat = "lat", lon = "lon")


highchart(type = "map") %>% 
  hc_title(text = "California") %>% 
  hc_add_series(mapData = california, 
                nullColor = "#425668",
                showInLegend = FALSE) %>% 
  hc_add_series(data = airptgjs, type = "mappoint",
                marker = list(symbol = fa_icon_mark("plane")),
                dataLabels = list(enabled = FALSE),
                name = "Airports", color = 'rgba(250, 250, 250, 0.8)',
                tooltip = list(pointFormat = "{point.properties.airport_name}")) %>% 
  hc_add_series(data = parksgjs, type = "mappoint",
                marker = list(symbol = fa_icon_mark("tree")),
                dataLabels = list(enabled = FALSE),
                name = "National Parks", color = 'rgba(0, 250, 0, 0.8)',
                tooltip = list(pointFormat = "{point.properties.park}")) %>% 
  hc_add_series(data = portsgjs, type = "mappoint",
                marker = list(symbol = fa_icon_mark("ship")),
                dataLabels = list(enabled = FALSE),
                name = "Ports & Harbors ", color = 'rgba(100, 100, 250, 0.8)',
                tooltip = list(pointFormat = "{point.properties.port}")) %>% 
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
#' ### Charting US states
#' 
library("dplyr")
library("viridisLite")

data("USArrests", package = "datasets")
data("usgeojson")

USArrests <- USArrests %>%
  mutate(state = rownames(.))

n <- 4
colstops <- data.frame(q = 0:n/n,
                       c = substring(viridis(n + 1, option = "A"), 0, 7)) %>%
list.parse2()

highchart() %>%
  hc_title(text = "Violent Crime Rates by US State") %>%
  hc_subtitle(text = "Source: USArrests data") %>%
  hc_add_series_map(usgeojson, USArrests, name = "Murder arrests (per 100,000)",
                    value = "Murder", joinBy = c("woename", "state"),
                    dataLabels = list(enabled = TRUE,
                                      format = '{point.properties.postalcode}')) %>%
  hc_colorAxis(stops = colstops) %>%
  hc_legend(valueDecimals = 0, valueSuffix = "%") %>%
  hc_mapNavigation(enabled = TRUE)
