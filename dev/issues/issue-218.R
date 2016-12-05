library(highcharter)
library(dplyr)
library(htmltools)
library(stringr)

hcmap <- function(map = "custom/world",
                  data = NULL, joinBy = "hc-key", value = NULL, 
                  showInLegend = FALSE, ...) {
  
  map <- str_replace(map, "\\.js", "")
  map <- str_replace(map, "https://code\\.highcharts\\.com/mapdata/", "")
  
  url <- "https://code.highcharts.com/mapdata/"
  
  dep <-  htmlDependency(
    name = basename(map),
    version = "0.1.0",
    src = c(href = url),
    script = sprintf("%s.js", map)
  )
  
  if(is.null(data)) {
    
    hc <- highchart(type = "map") %>% 
      highcharter:::hc_add_series.default(
        mapData = JS(sprintf("Highcharts.maps['%s']", map)),
        showInLegend = showInLegend, ...)
    
  } else {
    
    stopifnot(joinBy %in% names(data))
    data <- mutate_(data, "value" = value)
    
    hc <- highchart(type = "map") %>% 
      highcharter:::hc_add_series.default(
        mapData = JS(sprintf("Highcharts.maps['%s']", map)),
        data = list_parse(data),
        joinBy = joinBy,
        showInLegend = showInLegend, ...) %>% 
      hc_colorAxis(auxpar = NULL)
    
  }
  
  hc$dependencies <- c(hc$dependencies, list(dep))
  
  hc
  
}

hcmap(nullColor = "#425668")

data(GNI2014, package = "treemap")
GNI2014 <- rename(GNI2014, "iso-a3" = iso3)
head(GNI2014)

hcmap(map = "custom/world", data = GNI2014,
      joinBy = "iso-a3", value = "GNI")

hcmap(map = "custom/world-highres3", data = GNI2014,
      joinBy = "iso-a3", value = "GNI")


data("USArrests", package = "datasets")
USArrests <- mutate(USArrests, "woe-name" = rownames(USArrests))
head(USArrests)

hcmap(map = "countries/us/us-all", data = USArrests,
      joinBy = "woe-name", value = "UrbanPop", name = "Urban Population") %>% 
  hc_colorAxis(stops = color_stops())


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



