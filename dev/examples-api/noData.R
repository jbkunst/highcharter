# Give the empty state a specific message instead of a generic "No data".
highchart(
  hc_opts = list(
    lang = list(noData = "No orders recorded for this period.")
  )
) |>
  hc_title(text = "Daily orders") |>
  hc_noData(style = list(color = "#526472", fontSize = "16px"))
