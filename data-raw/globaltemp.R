library("dplyr")
library("readr")
lib
library("lubridate")
library("stringr")

df <- read_csv("https://raw.githubusercontent.com/hrbrmstr/hadcrut/master/data/temps.csv")

df <- df %>% 
  mutate(date = ymd(year_mon),
         year = year(date),
         month = month(date, label = TRUE))

globaltemp <- globaltemp %>% 
  group_by(year) %>% 
  summarise(lower = min(lower),
            median = median(median),
            upper = max(upper)) %>% 
  ungroup() 

devtools::use_data(globaltemp, overwrite = TRUE)

# EXAMPLES ----------------------------------------------------------------
library(highcharter)
hchart(globaltemp, type = "spline", x = year, y = median)


# setting theme
thm <- hc_theme_darkunica(
  chart  = list(
    style = list(fontFamily = "Roboto Condensed"),
    backgroundColor = "#323331"
  ),
  yAxis = list(
    gridLineColor = "#B71C1C",
    labels = list(format = "{value} C", useHTML = TRUE)
  ),
  plotOptions = list(series = list(showInLegend = FALSE))
)

x <- c("Min", "Median", "Max")
y <- sprintf("{point.%s}", c("lower", "median", "upper"))
tltip <- tooltip_table(x, y)


hchart(globaltemp, type = "columnrange", x = year, low = lower, high = upper,
       color = median) %>% 
  hc_yAxis(tickPositions = c(-2, 0, 1.5, 2)) %>% 
  hc_tooltip(
    useHTML = TRUE,
    headerFormat = as.character(tags$small("{point.x:%Y}")),
    pointFormat = tltip
  ) %>% 
  hc_add_theme(thm)
