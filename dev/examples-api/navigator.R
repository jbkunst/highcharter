highchart(type = "stock") |> 
  hc_add_series(AirPassengers) |> 
  hc_rangeSelector(selected = 4) |> 
  hc_navigator(
    outlineColor = "gray",
    outlineWidth = 2,
    series = list(
      color = "red",
      lineWidth = 2,
      type = "areaspline", # you can change the type
      fillColor = "rgba(255, 0, 0, 0.2)"
    ),
    handles = list(
      backgroundColor = "yellow",
      borderColor = "red"
    )
  )
