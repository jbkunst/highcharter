# Use actual flower measurements and label the third dimension with its units.
hchart(
  datasets::iris,
  "scatter3d",
  hcaes(x = Sepal.Length, y = Sepal.Width, z = Petal.Length, group = Species)
) |>
  hc_title(text = "Iris flowers in three dimensions") |>
  hc_chart(
    options3d = list(enabled = TRUE, alpha = 15, beta = 30, depth = 250)
  ) |>
  hc_xAxis(title = list(text = "Sepal length (cm)")) |>
  hc_yAxis(title = list(text = "Sepal width (cm)")) |>
  hc_zAxis(
    title = list(text = "Petal length (cm)"),
    labels = list(format = "{value} cm"),
    min = 0
  ) |>
  hc_tooltip(
    pointFormat = paste(
      "Sepal: {point.x:.1f} \u00d7 {point.y:.1f} cm<br/>",
      "Petal length: {point.z:.1f} cm"
    )
  )
