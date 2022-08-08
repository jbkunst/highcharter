highchart() |> 
  hc_xAxis(categories = month.abb) |> 
  hc_add_series(name = "Tokyo", data = sample(1:12)) |> 
  hc_exporting(
    enabled = TRUE, # always enabled
    filename = "custom-file-name"
    )
