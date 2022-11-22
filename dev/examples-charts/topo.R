library(highcharter)

options(highcharter.debug = TRUE)
hcmap()

urlmap <- "https://code.highcharts.com/mapdata/custom/world.topo.json"

ftemp <- tempfile(fileext =".json")

download.file(urlmap, ftemp)

topo <- jsonlite::fromJSON(ftemp, simplifyVector = FALSE)

# map <- highcharter:::fix_map_name(map)

hc <- highchart(type = "map")

highchart(type = "map") |> 
  hc_chart(map = topo) |>
  hc_add_series(
    data = list()
  )  
  
highchart(type = "map") |> 
  hc_chart(map = topo) |>
  hc_add_series(data = list()) |> 
  hc_add_series(
    data = data.frame(
      lat = c(20, 30, -73),
      lon = c(10, 20, 35),
      z = c(1, 2, 3)
      ),
    minSize =  '5%',
    maxSize = '12.5%',
    type = "mapbubble"
  )
