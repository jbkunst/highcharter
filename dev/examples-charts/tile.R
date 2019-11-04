df <- data.frame(
  stringsAsFactors = FALSE,
  x = c(1, 2, 2, 3, 4, 4, 5, 6, 6, 7, 7, 7, 8, 8, 8, 8, 8, 9, 9, 9),
  y = c(6, 6, 7, 7, 7, 8, 8, 8, 9, 1, 2, 9, 1, 2, 4, 5, 9, 1, 2, 3),
  value = c(7, 7, 7, 7, 7, 7, 6.8, 6, 5.8, 11.7, 9.4, 6, 10.3, 8, 17.7, 2.8, 6.1, 9.9, 10.3, 8.7),
  name = c("point 1", "point 2", "point 3", "point 4", "point 5",
           "point 6", "point 7", "point 8", "point 9", "point 10",
           "point 11", "point 12", "point 13", "point 14", "point 15",
           "point 16", "point 17", "point 18", "point 19", "point 20")
)


df

hc <- highchart() %>%
  hc_add_series(data = df, name = "") %>%
  hc_title(text = "test") %>%
  hc_chart(type = "tilemap") %>%
  hc_colorAxis(dataClasses = list(
    list(
      from = 0,
      to = 10,
      color = "#ffff00",
      name = "0°C - 10°C"
    ),
    list(
      from = 10,
      to = 20,
      color = "#FFA500",
      name = "10°C - 20°C"
    ),
    list(
      from = 20,
      to = 30,
      color = "#e50000",
      name = "20°C - 30°C"
    )
  )) %>%
  hc_tooltip(headerFormat = "",
             pointFormat = "Average temperature: {point.value}") %>%
  hc_plotOptions(
    series = list(
      enabled = T,
      format = "{point.value}",
      color = "#000000",
      turboThreshold = 1000,
      style = list(textOutline = F)
    )
  ) %>% 
  hc_xAxis(visible = FALSE) %>% 
  hc_yAxis(visible = FALSE)

hc


# example 2
library(tidyverse)

# http://www.maartenlambrechts.com/2017/10/22/tutorial-a-worldtilegrid-with-ggplot2.html
url <- "https://gist.githubusercontent.com/maartenzam/787498bbc07ae06b637447dbd430ea0a/raw/9a9dafafb44d8990f85243a9c7ca349acd3a0d07/worldtilegrid.csv"

data <- read_csv(url)
data <- rename_all(data, str_replace_all, "\\.", "_")
data

hchart(data, "tilemap", hcaes(x = x, y = -y, name = name, group = region)) %>% 
  hc_chart(type = "tilemap") %>% 
  hc_plotOptions(
    series = list(
      dataLabels = list(
        enabled = TRUE,
        format = "{point.alpha_2}",
        color = "white",
        style = list(textOutline = FALSE)
      )
    )
  ) %>% 
  hc_tooltip(
    headerFormat = "",
    pointFormat = "<b>{point.name}</b> is in <b>{point.region}</b>"
    ) %>% 
  hc_xAxis(visible = FALSE) %>% 
  hc_yAxis(visible = FALSE)

