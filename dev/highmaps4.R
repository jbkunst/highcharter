rm(list = ls())

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

