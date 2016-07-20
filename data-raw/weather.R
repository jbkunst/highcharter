library("dplyr")
library("readr")
library("lubridate")
library("stringr")

weather <- read_csv("http://bl.ocks.org/bricedev/raw/458a01917183d98dff3c/sf.csv")

names(weather) <- names(weather) %>% 
  str_to_lower() %>% 
  str_replace("\\s+", "_")

weather <- weather %>% 
  select(date, min_temperaturec, max_temperaturec, mean_temperaturec)

devtools::use_data(weather, overwrite = TRUE)

# EXAMPLES ----------------------------------------------------------------
hchart(weather, type = "spline", x = date, y = mean_temperaturec)


x <- c("Min", "Mean", "Max")
y <- sprintf("{point.%s}",
             c("min_temperaturec", "mean_temperaturec", "max_temperaturec"))
tltip <- tooltip_table(x, y)

hchart(weather, type = "columnrange",
       x = date,
       low = min_temperaturec,
       high = max_temperaturec,
       color = mean_temperaturec) %>% 
  hc_chart(polar = TRUE) %>%
  hc_yAxis(
    max = 30,
    min = -10,
    labels = list(format = "{value} C"),
    showFirstLabel = FALSE
  ) %>% 
  hc_xAxis(
    title = list(text = ""),
    gridLineWidth = 0.5,
    labels = list(format = "{value: %b}")
  ) %>% 
  hc_tooltip(
    useHTML = TRUE,
    headerFormat = as.character(tags$small("{point.x:%d %B, %Y}")),
    pointFormat = tltip
  )
