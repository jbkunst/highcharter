# Map elevation to a continuous color scale for the built-in volcano matrix.
hchart(volcano) |>
  hc_colorAxis(min = 90, max = 200, minColor = "#FFF3CA", maxColor = "#843B20")
