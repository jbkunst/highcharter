library("dplyr")
library("readr")
library("lubridate")
library("stringr")

df <- read_csv("https://raw.githubusercontent.com/hrbrmstr/hadcrut/master/data/temps.csv")

df <- select(df, -year, -decade, -month) %>% 
  mutate(year_mon = as.Date(year_mon)) %>% 
  rename(date = year_mon)
  
globaltemp <- df
devtools::use_data(globaltemp, overwrite = TRUE)

# EXAMPLES ----------------------------------------------------------------
library(highcharter)
data("globaltemp")
hchart(globaltemp, type = "spline", x = date, y = median)

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


hchart(globaltemp, type = "columnrange", x = date, low = lower, high = upper,
       color = median) %>% 
  hc_yAxis(tickPositions = c(-2, 0, 1.5, 2)) %>% 
  hc_tooltip(
    useHTML = TRUE,
    headerFormat = as.character(tags$small("{point.x: %Y %b}")),
    pointFormat = tltip
  ) %>% 
  hc_add_theme(thm)
