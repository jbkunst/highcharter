# Explore a packaged map with buttons, without intercepting page scrolling.
hcmap("jp", showInLegend = FALSE) |>
  hc_title(text = "Explore Japan's prefectures") |>
  hc_mapNavigation(
    enabled = TRUE,
    enableMouseWheelZoom = FALSE,
    buttonOptions = list(verticalAlign = "bottom")
  )
