library(tidyverse)

df <- tibble(
  y = sample(5:10),
  target = sample(y),
  x = LETTERS[1:6]
  )


hchart(df, "bullet", hcaes(x = x, y = y, target = target), color = "black") %>%
  hc_chart(inverted = TRUE) %>%
  hc_yAxis(
    min = 0,
    max = 10,
    gridLineWidth = 0,
    plotBands = list(
      list(from = 0, to = 7, color = "#666"),
      list(from = 7, to = 9, color = "#999"),
      list(from = 9, to = 10, color = "#bbb")
    )
  ) %>%
  hc_xAxis(
    gridLineWidth = 15,
    gridLineColor = "white"
  ) %>% 
  hc_plotOptions(
    series = list(
      pointPadding = 0.25,
      pointWidth = 15,
      borderWidth = 0,
      targetOptions = list(width = '200%')
      )
    )
