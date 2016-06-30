library(highcharter)
library(dplyr)
library(purrr)
library(lubridate)


data(economics_long, package = "ggplot2")
data(economics, package = "ggplot2")

data <- economics_long 
data <- mtcars 


hcdy <- function(data, type = NULL, ...){
  
  data <- mutate(data, ...)
  data <- ungroup(data)
  
  hc <- highchart()
  
  # Check if x is date
  if(is.Date(data[["x"]])) {
    hc <- hc_xAxis(hc, type = "datetime")
    data <- mutate(data, x = datetime_to_timestamp(x))
  }
  
  # Color
  if("color" %in% names(data))
    data  <- mutate(data, color = colorize(color))
  
  # Size
  if("size" %in% names(data)) {
    data <- mutate(data, z = size)
    type <- ifelse(type == "scatter", "bubble", type)
  }
    
  hc <- hc_add_series(hc, data = list.parse3(data), type = type)
  
  hc
  
}

options(highcharter.theme = hc_theme_smpl())

hcdy(mtcars, "scatter", x = mpg, y = hp)
hcdy(mtcars, "scatter", x = mpg, y = hp, color = am)
hcdy(mtcars, "scatter", x = mpg, y = hp, color = drat)
hcdy(mtcars, "scatter", x = mpg, y = hp, size = drat)
hcdy(mtcars, "scatter", x = mpg, y = hp, size = drat, color = am)
hcdy(mtcars, "scatter", x = mpg, y = hp, size = drat, color = drat)


hcdy(economics, "line", x = date, y = unemploy)
hcdy(economics, "columrange", x = date, low = unemploy -4, high = unemploy + 5, color = pop)
hcdy(economics, "scatter", x = pop, y = unemploy)


df <- data_frame(x = 1:10,
                 y = 10 + x + 10 * sin(x),
                 er = 10 * abs(rnorm(length(x))) + 2,
                 l = y - er,
                 h = y + er,
                 col = y,
                 sz = (x*y) - median(x*y),
                 nm = sample(LETTERS, size = length(y)))
df

##### x, y, name, color #### 
# x: 1,
# y: 9,
# name: "Point2",
# color: "#00FF00"
hcdy(df, "column", x = x, y = y, color = col, name = nm)
hcdy(df, "line", x = x, y = y, color = col, name = nm)
hcdy(df, "scatter", x = x, y = y, color = col, name = nm)
hcdy(df, "spline", x = x, y = y, color = col, name = nm)
hcdy(df, "area", x = x, y = y, color = col, name = nm)
hcdy(df, "areaspline", x = x, y = y, color = col, name = nm)
hcdy(df, "bar", x = x, y = y, color = col, name = nm)
hcdy(df, "polygon", x = x, y = y, color = col, name = nm)
hcdy(df, "waterfall", x = x, y = y, color = col, name = nm)

#### x, y, z, name, color ####
# x: 1,
# y: 1,
# z: 1,
# name: "Point2",
# color: "#00FF00"
hcdy(df, "bubble", x = x, y = y, size = sz, name = nm, color = col)

#### y, name, color ####
# y: 3,
# name: "Point2",
# color: "#00FF00"
hcdy(df, "funnel", y = y, name = nm, color = col)
hcdy(df, "pie", y = y, name = nm, color = col)
hcdy(df, "pyramid", y = y, name = nm, color = col)
hcdy(df, "gauge", y = y, name = nm, color = col)
hcdy(df, "solidgauge", y = y, name = nm, color = col)


##### x, low, high, name, color ####
# x: 1,
# low: 9,
# high: 0,
# name: "Point2",
# color: "#00FF00"
hcdy(df, "arearange", x = x, low = l, high = h, name = nm, color = col)
hcdy(df, "areasplinerange", x = x, low = l, high = h, name = nm, color = col)
hcdy(df, "columnrange", x = x, low = l, high = h, name = nm, color = col)
hcdy(df, "errorbar", x = x, low = l, high = h, name = nm, color = col)

#### x, low, q1, median, q3, high, name, color #### 
# x: 1,
# low: 4,
# q1: 9,
# median: 9,
# q3: 1,
# high: 10,
# name: "Point2",
# color: "#00FF00"
hcdy(df %>% mutate(qq1 = y - er/2, qq3 = y + er/2), "boxplot",
     x = x, low = l, median = y, high = h, name = nm, q1 = qq1, q3 = qq3, color = y)


# x, y, value, name, color ####
# x: 1,
# y: 3,
# value: 10,
# name: "Point2",
# color: "#00FF00"
hcdy(df, "heatmap", x = x, y = y, value = sqrt(sz))

#### value, name, color ####
# value: 7,
# name: "Point2",
# color: "#00FF00"
hcdy(df, "treemap", value = y, name = nm, color = col)
