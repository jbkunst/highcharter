df <- data.frame(
  x = 1:10,
  y = 1:10
)

highchart() %>% 
  hc_add_series(data = df, hcaes(x = x, y = y), type = "area") %>% 
  hc_annotations(
    list(
      labels = list(
        list(point = list(x = 5, y = 5, xAxis = 0, yAxis = 0), text = "Middle"),
        list(point = list(x = 1, y = 1, xAxis = 0, yAxis = 0), text = "Start")
      )
    )
  )
