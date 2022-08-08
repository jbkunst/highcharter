library(viridisLite)

cols <- viridis(3)
cols <- substr(cols, 0, 7)

highchart() |> 
  hc_add_series(data = sample(1:12)) |> 
  hc_add_series(data = sample(1:12) + 10) |> 
  hc_add_series(data = sample(1:12) + 20) |> 
  hc_colors(cols)
