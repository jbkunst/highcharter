highchart() %>%
  hc_chart(
    type = "scatter3d",
    options3d = list(
      enabled = TRUE,
      alpha = 20,
      beta = 30,
      depth = 200,
      viewDistance = 5
    )
  ) %>% 
  hc_add_series(
    data = list(
      list(
        list(1, 2, 3),
        list(2, 3, 4)
      )
    )
  ) %>% 
  hc_zAxis(
    startOnTick = FALSE,
    tickInterval = 2,
    tickLength = 4,
    tickWidth = 1,
    gridLineColor = "#A00000",
    gridLineDashStyle = "dot"  
  )
