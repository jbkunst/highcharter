highchart(type = "stock") |> 
  hc_add_series(AirPassengers) |> 
  hc_rangeSelector(selected = 4) |> 
  hc_scrollbar(
    barBackgroundColor = "gray",
    barBorderRadius = 7,
    barBorderWidth = 0,
    buttonBackgroundColor = "gray",
    buttonBorderWidth = 0,
    buttonArrowColor = "yellow",
    buttonBorderRadius = 7,
    rifleColor = "yellow",
    trackBackgroundColor = "white",
    trackBorderWidth = 1,
    trackBorderColor = "silver",
    trackBorderRadius = 7
  )
