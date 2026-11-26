# Read CSV directly in the browser, using the first column as categories.
highchart() |>
  hc_title(text = "Orders picked up at the cafe") |>
  hc_chart(type = "column") |>
  hc_yAxis(title = list(text = "Orders")) |>
  hc_legend(enabled = FALSE) |>
  hc_data(csv = "Month,Orders\nJan,120\nFeb,180\nMar,150\nApr,210")
