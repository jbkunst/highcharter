library(highcharter)
library(dplyr)
library(htmltools)
library(stringr)
library(tibble)
library(purrr)
options(highcharter.debug = TRUE)

hcmap <- function(map = "custom/world",
                  data = NULL, joinBy = "hc-key", value = NULL,
                  download_map_data = FALSE, ...) {
  
  url <- "https://code.highcharts.com/mapdata"
  map <- str_replace(map, "\\.js", "")
  map <- str_replace(map, "https://code\\.highcharts\\.com/mapdata/", "")
  mapfile <- sprintf("%s.js", map)
  
  hc <- highchart(type = "map")
  
  if(download_map_data) {
    
    mapdata <- download_map_data(file.path(url, mapfile))
    
  } else {
    
    dep <-  htmlDependency(
      name = basename(map),
      version = "0.1.0",
      src = c(href = url),
      script = mapfile
    )
    
    hc$dependencies <- c(hc$dependencies, list(dep))
    
    mapdata <- JS(sprintf("Highcharts.maps['%s']", map))
    
  }
  
  if(is.null(data)) {
    
    hc <- hc %>% 
      highcharter:::hc_add_series.default(
        mapData = mapdata, ...)
    
  } else {
    
    stopifnot(joinBy %in% names(data))
    data <- mutate_(data, "value" = value)
    
    hc <- hc %>% 
      highcharter:::hc_add_series.default(
        mapData = mapdata,
        data = list_parse(data), joinBy = joinBy, ...) %>% 
      hc_colorAxis(auxpar = NULL)
    
  }
  
  hc
  
}

download_map_data <- function(url = "https://code.highcharts.com/mapdata/custom/world.js",
                              showinfo = FALSE) {
  
  tmpfile <- tempfile(fileext = ".js")
  download.file(url, tmpfile)
  mapdata <- readLines(tmpfile, warn = FALSE)
  mapdata[1] <- gsub(".* = ", "", mapdata[1])
  mapdata <- paste(mapdata, collapse = "\n")
  mapdata <- jsonlite::fromJSON(mapdata, simplifyVector = FALSE)
  
  if(showinfo) {
    glimpse(get_data_from_map(mapdata))
  }
  
  mapdata
  
}

get_data_from_map <- function(mapdata) {
  mapdata$features %>%
    map("properties") %>%
    map_df(function(x){ x[!map_lgl(x, is.null)] })
}

mapdata <- download_map_data()
mapdata <- download_map_data("https://code.highcharts.com/mapdata/countries/us/us-all.js")


get_data_from_map(download_map_data())
get_data_from_map(download_map_data("https://code.highcharts.com/mapdata/countries/us/us-all.js"))
# example 1 ---------------------------------------------------------------
hcmap(nullColor = "#DADADA")
hcmap(nullColor = "#DADADA", download_map_data = TRUE)

# example 2 ---------------------------------------------------------------
data(GNI2014, package = "treemap")
GNI2014 <- rename(GNI2014, "iso-a3" = iso3)
head(GNI2014)

hcmap(map = "custom/world", data = GNI2014, joinBy = "iso-a3", value = "GNI")
hcmap(map = "custom/world", data = GNI2014, joinBy = "iso-a3", value = "GNI", download_map_data = TRUE)
hcmap(map = "custom/world-highres3", data = GNI2014, joinBy = "iso-a3", value = "GNI")

# example 3 ---------------------------------------------------------------
data("USArrests", package = "datasets")
USArrests <- mutate(USArrests, "woe-name" = rownames(USArrests))
head(USArrests)

hcmap(map = "countries/us/us-all", data = USArrests,
      joinBy = "woe-name", value = "UrbanPop", name = "Urban Population") 
hcmap(map = "countries/us/us-all", data = USArrests,
      joinBy = "woe-name", value = "UrbanPop", name = "Urban Population",
      download_map_data = TRUE) 


# example 4 ---------------------------------------------------------------
hcmap(map = "countries/us/us-all")
hcmap(map = "countries/us/us-all-all")
hcmap(map = "countries/us/custom/us-all-territories")

hcmap("countries/us/us-ca-all") %>% 
  hc_title(text = "California")

hcmap("countries/cl/cl-all") %>% 
  hc_title(text = "Chile")

hcmap("custom/south-america")
hcmap("custom/asia")

hcmap("custom/world-highres3")



