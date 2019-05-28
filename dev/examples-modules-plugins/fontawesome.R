library(tidyverse)
library(highcharter)
library(MASS)

ds1 <- as_tibble(round(mvrnorm(n = 20, mu = c(1, 1), Sigma = matrix(c(1,0,0,1),2)), 2))
ds2 <- as_tibble(round(mvrnorm(n = 10, mu = c(3, 4), Sigma = matrix(c(2,.5,2,2),2)), 2))

highchart() %>%
  hc_chart(zoomType = "xy") %>%
  hc_tooltip(
    useHTML = TRUE,
    pointFormat = paste0(
      "<span style=\"color:{series.color};\">{series.options.icon}</span>",
      "{series.name}: <b>[{point.x}, {point.y}]</b><br/>"
    )
  ) %>%
  hc_add_series(
    data = ds1,
    type = "point",
    hcaes(V1, V2), 
    marker = list(symbol = fa_icon_mark("bath")),
    icon = fa_icon("bath"),
    name = "bath"
  ) %>%
  hc_add_series(
    data = ds2,
    type = "point",
    hcaes(V1, V2), 
    marker = list(symbol = fa_icon_mark("shower")),
    icon = fa_icon("shower"),
    name = "shower"
  ) %>%
  hc_add_dependency_fa()


data <- bind_rows(
  ds1 %>% mutate(ico = "bath"),
  ds2 %>% mutate(ico = "shower")
)

hchart(data, "point", hcaes(V1, V2, group = ico))

data <- data %>% 
  mutate(
    icon = fa_icon(ico),
    marker =  map(ico, ~ list(symbol = fa_icon_mark(.x)))
  )


hchart(data, "point", hcaes(V1, V2, group = ico)) %>% 
  hc_add_dependency_fa() 
