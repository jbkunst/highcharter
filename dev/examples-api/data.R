# The Data module reads CSV text directly and builds the series in the browser.
highchart() |>
  hc_chart(type = "column") |>
  hc_data(csv = "Month,Orders\nJan,12\nFeb,18\nMar,15")
