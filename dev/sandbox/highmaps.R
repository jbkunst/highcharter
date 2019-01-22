rm(list = ls())


#### EX 0  ####
data(worldgeojson)
data(GNI2010, package = "treemap")

head(GNI2010)

highchart() %>% 
  hc_add_series_map(worldgeojson, GNI2010,
                    value = "GNI", joinBy = "iso3")

#### EX 0 ####
data(unemployment)
data(uscountygeojson)

require("viridisLite")
dclass <- data_frame(from = seq(0, 10, by = 2),
                     to = c(seq(2, 10, by = 2), 50),
                     color = substring(viridis(length(from), option = "C"), 0, 7))
dclass <- list_parse(dclass)


highchart() %>% 
  hc_add_series_map(uscountygeojson, unemployment,
                    value = "value", joinBy = "code") %>% 
  hc_colorAxis(dataClasses = dclass) %>% 
  hc_tooltip(layout = "vertical", align = "right",
             floating = TRUE, valueDecimals = 0,
             valueSuffix = "%")

#### EX 1 ####
library("purrr")
library("dplyr")

data(GNI2010, package = "treemap")

head(GNI2010)

url <- "https://code.highcharts.com/mapdata/custom/world.js"
tmpfile <- tempfile(fileext = ".json")
download.file(url, tmpfile)

world <- geojson_read(tmpfile)
world <- gsub(".* = ", "", world)

map <- geo
# map <- jsonlite::fromJSON(world, simplifyVector = FALSE)


head(GNI2010)

ddta <- GNI2010 %>% 
  select(iso3, value = GNI) %>% 
  list_parse()

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

#### EX 1.3 ####
url <- "https://code.highcharts.com/mapdata/countries/us/us-all.js"
tmpfile <- tempfile(fileext = ".json")
download.file(url, tmpfile)
us <- readLines(tmpfile)
us <- gsub(".* = ", "", us)
us <- jsonlite::fromJSON(us, simplifyVector = FALSE)


url <- "https://code.highcharts.com/mapdata/countries/us/us-all-all.js"
tmpfile <- tempfile(fileext = ".json")
download.file(url, tmpfile)
uscities <- readLines(tmpfile)
uscities <- gsub(".* = ", "", uscities)
uscities <- jsonlite::fromJSON(uscities, simplifyVector = FALSE)

url <- "https://www.highcharts.com/samples/data/jsonp.php?filename=us-counties-unemployment.json"
tmpfile <- tempfile(fileext = ".json")
download.file(url, tmpfile)

unemployment <- readLines(tmpfile)
unemployment <- gsub("callback\\(|\\);$", "", unemployment)
unemployment <- jsonlite::fromJSON(unemployment, simplifyVector = FALSE)

require("viridisLite")

dclass <- data_frame(from = seq(0, 10, by = 2),
                     to = c(seq(2, 10, by = 2), 50),
                     color = substring(viridis(length(from), option = "B"), 0, 7))
dclass <- setNames(rlist::list.parse(dclass), NULL)

highchart(type = "map", debug = TRUE) %>% 
  hc_title(text = "US Counties unemployment rates") %>% 
  hc_colorAxis(dataClasses = dclass) %>% 
  hc_mapNavigation(enabled = TRUE) %>% 
  hc_add_series(mapData = us, color = "white", width = 20) %>% 
  hc_add_series(mapData = uscities, data = unemployment,
                joinBy = c("hc-key", "code"), name = "Unemployment rate",
                borderWidth = 0.5, tootlip = list(valueSuffix = "%"),
                states = list(hover = list(color = "#BADA55"))) %>% 
  hc_legend(layout = "vertical", align = "right",
            valueDecimals = 0, valueSuffix = "%")

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
url <- "https://raw.githubusercontent.com/johan/world.geo.json/master/countries.geo.json"
tmpfile <- tempfile(fileext = ".json")
download.file(url, tmpfile)
world <- geojson_read(tmpfile)

highchart(type = "map", debug = TRUE) %>% 
  hc_add_series(name = "worldgeojson", mapData = world)





