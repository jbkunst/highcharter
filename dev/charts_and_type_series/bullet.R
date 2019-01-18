library(highcharter)
library(tidyverse)

df <- data_frame(
  y = sample(5:10),
  target = sample(y),
  x = LETTERS[1:6]
)

# df <- df %>% head(1)

hchart(df, "bullet", hcaes(x = x, y = y, target = target),
       color = "black") %>% 
  hc_chart(inverted = TRUE) %>% 
  hc_yAxis(
    min = 0, max = 10,
    gridLineWidth = 0,
    plotBands = list(
      list(from = 0, to = 7, color = "#666"),
      list(from = 7, to = 9, color = "#999"),
      list(from = 9, to = 10, color = "#bbb")
    )
  ) %>% 
  hc_plotOptions(
    series = list(
      pointPadding = 0.25,
      borderWidth = 0,
      targetOptions = list(
        width = '200%'
        )
      )
  )



highchart() %>%
  hc_chart(inverted = TRUE, type="bullet") %>%
  hc_title(text="TITULO 1") %>%
  hc_xAxis(categories="X CATEGORIA") %>%
  hc_plotOptions(series = list(pointPadding = 0.25, borderWidth = 0, color = "blue", targetOptions=list(width = '100%'))) %>%
  hc_yAxis(plotBands = list(list(from = 0, to = 50,color = "red"), list(from = 50, to = 80,color = "yellow"), list(from = 80, to = 100,color = "green")), title = "TITULO 2") %>%
  hc_add_series(data=list(list(y=50, target=90)))
