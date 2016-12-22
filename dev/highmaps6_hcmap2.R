library(httr)
library(htmltools)

hcmap2 <- function(map = "AUS",
                  download_map_data = getOption("highcharter.download_map_data"),
                  data = NULL, value = NULL, joinBy = NULL, 
                  ...) {
  
  maptxt <- "https://raw.githubusercontent.com/johan/world.geo.json/master/countries/%s.geo.json" %>% 
    sprintf(map) %>% 
    readLines() %>% 
    paste(collapse = "") %>% 
    paste("map = ", .)
  
  fname <- tempfile(fileext = ".js")
  
  writeLines(maptxt, fname)
  
  dep <- htmlDependency(
    name = basename(map),
    version = "0.1.0",
    src = c(file = dirname(fname)),
    script = basename(fname)
  )
  
  widget <- DT::datatable(mtcars)
  # hc <- highchart(type = "map")
  
  # widget$dependencies <- c(widget$dependencies, list(dep))
  widget$dependencies <- c(
    widget$dependencies,
    list(dep)
  )
  
  widget
  
  hc <- hc %>% 
      hc_add_series(
        mapData = JS("map"), ...)
  
  hc
    
  } else {
    
    data <- mutate_(data, "value" = value)
    
    hc <- hc %>% 
      hc_add_series.default(
        mapData = mapdata,
        data = list_parse(data), joinBy = joinBy, ...) %>% 
      hc_colorAxis(auxpar = NULL)
    
  }
  
  hc
  
}
