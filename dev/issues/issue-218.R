library(highcharter)
library(htmltools)
library(stringr)

hcmap <- function(map = "custom/world",
                  data = NULL, joinBy = "hc-key", value = NULL, 
                  showInLegend = FALSE, ...) {
  
  map <- str_replace(map, "\\.js", "")
  
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
    
    hc <- highchart(type = "map") %>% 
      highcharter:::hc_add_series.default(
        mapData = JS(sprintf("Highcharts.maps['%s']", map)),
        showInLegend = showInLegend, ...)
    
  }
  
  hc$dependencies <- c(hc$dependencies, list(dep))
  
  hc
  
}

hcmap(nullColor = "#425668")

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



