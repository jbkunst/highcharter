# Let the terrain colors follow elevation, with units in the color legend.
hchart(datasets::volcano) |>
  hc_title(text = "Maunga Whau / Mount Eden terrain") |>
  hc_colorAxis(
    min = 90,
    max = 200,
    stops = list(
      list(0, "#FFF3CA"),
      list(0.5, "#C99A58"),
      list(1, "#843B20")
    ),
    labels = list(format = "{value} m")
  )
