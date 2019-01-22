highchart() %>%
  hc_add_series(
    data = c(7.0, 6.9, 9.5, 14.5, 18.2, 21.5, 25.2, 26.5, 23.3, 18.3, 13.9, 9.6),
    type = "spline"
  ) %>% 
  hc_yAxis(
    title = list(text = "y Axis at right"),
    opposite = TRUE,
    minorTickInterval = "auto",
    minorGridLineDashStyle = "LongDashDotDot",
    showFirstLabel = FALSE,
    showLastLabel = FALSE,
    plotBands = list(
      list(
        from = 25,
        to = 80,
        color = "rgba(100, 0, 0, 0.1)",
        label = list(text = "This is a plotBand")
        )
      )
    ) 
