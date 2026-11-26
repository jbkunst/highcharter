# Make export menu entries easier to read and select.
highcharts_demo() |>
  hc_exporting(enabled = TRUE) |>
  hc_navigation(
    menuItemStyle = list(fontSize = "14px", padding = "10px 16px"),
    menuItemHoverStyle = list(background = "#0072B2", color = "#FFFFFF")
  )
