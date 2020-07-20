# example 1
# http://www.maartenlambrechts.com/2017/10/22/tutorial-a-worldtilegrid-with-ggplot2.html
library(tidyverse)

url <- "https://gist.githubusercontent.com/maartenzam/787498bbc07ae06b637447dbd430ea0a/raw/9a9dafafb44d8990f85243a9c7ca349acd3a0d07/worldtilegrid.csv"

data <- read_csv(url)
data <- data %>% 
  rename_all(str_replace_all, "\\.", "_") %>% 
  select(x, y, name, region)

glimpse(data)

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
  hc_yAxis(visible = FALSE) %>% 
  hc_size(height = 600)
