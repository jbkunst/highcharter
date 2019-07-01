rm(list = ls())
library(tidyverse)
library(httr)
library(geojsonio)
library(highcharter)

mapa <- "https://raw.githubusercontent.com/juaneladio/peru-geojson/master/peru_departamental_simple.geojson" %>% 
  GET() %>% 
  content() %>% 
  jsonlite::fromJSON(simplifyVector = FALSE)

# Extraemos lo que tiene de información
data <- map_df(mapa$features, "properties")
data <- mutate(data, value = COUNT)
data

highchart(type = "map") %>% 
  hc_add_series(mapData = mapa, showInLegend = TRUE, data = data,
                joinBy = "FIRST_IDDP", name = "Hectareas") %>% 
  hc_colorAxis(enabled = TRUE) %>% 
  # acá accedes a los valores del data frame "data"
  hc_tooltip(pointFormat = "{point.NOMBDEP}: {point.value}")


