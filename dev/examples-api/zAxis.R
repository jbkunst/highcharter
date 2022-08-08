df <- data.frame(
  x = sample(1:5),
  y = sample(1:5),
  z = sample(1:5)
)

highchart() |>
  hc_add_series(data = df, "scatter3d", hcaes(x = x, y = y, z = z)) |> 
  hc_chart(
    type = "scatter3d",
    options3d = list(
      enabled = TRUE,
      alpha = 20,
      beta = 30,
      depth = 200,
      viewDistance = 5,
      frame = list(
        bottom = list(
          size = 1,
          color = "rgba(0,0,0,0.05)"
        )
      )
    )
  ) |> 
  hc_zAxis(
    title = list(text = "Z axis is here"),
    startOnTick = FALSE,
    tickInterval = 2,
    tickLength = 4,
    tickWidth = 1,
    gridLineColor = "red",
    gridLineDashStyle = "dot"
  )
