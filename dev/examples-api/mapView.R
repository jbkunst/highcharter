map <- hcmap()

map

map |> 
  hc_mapView(zoom = 10) |> 
  hc_mapNavigation(enabled = TRUE)
  
  
