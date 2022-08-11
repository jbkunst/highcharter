#' ## solidgauge
col_stops <- data.frame(
  q = c(0.15, 0.4, .8),
  c = c('#55BF3B', '#DDDF0D', '#DF5353'),
  stringsAsFactors = FALSE
)

highchart() %>%
  hc_chart(type = "solidgauge") %>%
  hc_pane(
    startAngle = -90,
    endAngle = 90,
    background = list(
      outerRadius = '100%',
      innerRadius = '60%',
      shape = "arc"
    )
  ) %>%
  hc_tooltip(enabled = FALSE) %>% 
  hc_yAxis(
    stops = list_parse2(col_stops),
    lineWidth = 0,
    minorTickWidth = 0,
    tickAmount = 2,
    min = 0,
    max = 100,
    labels = list(y = 26, style = list(fontSize = "22px"))
  ) %>%
  hc_add_series(
    data = 90,
    dataLabels = list(
      y = -50,
      borderWidth = 0,
      useHTML = TRUE,
      style = list(fontSize = "40px")
    )
  ) %>% 
  hc_size(height = 300)
