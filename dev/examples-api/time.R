# The first observation is midnight UTC and 21:00 the previous day in Santiago.
highchart() |>
  hc_add_series(
    name = "Orders",
    data = c(12, 18, 15),
    pointStart = datetime_to_timestamp(as.Date("2025-01-01")),
    pointInterval = 3600000
  ) |>
  hc_title(text = "Hourly orders in Santiago") |>
  hc_xAxis(type = "datetime", labels = list(format = "{value:%H:%M}")) |>
  hc_yAxis(title = list(text = "Orders")) |>
  hc_tooltip(xDateFormat = "%e %b %Y, %H:%M") |>
  hc_time(timezone = "America/Santiago")
