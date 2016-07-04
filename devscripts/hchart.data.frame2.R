#' ---
#' output: html_document
#' ---
#+ warning=FALSE, message=FALSE
#+ warning=FALSE, message=FALSE
#### PACAKGES ####
library(highcharter)
library(dplyr)
options(highcharter.theme = hc_theme_smpl())

#### DATA ####
df <- data_frame(xval = 1:10) %>% 
  mutate(
    yval = 10 + xval + 10 * sin(xval),
    yval = round(yval, 1),
    zval = (xval*yval) - median(xval*yval),
    er = 10 * abs(rnorm(length(xval))) + 2,
    er = round(er, 1),
    l = yval - er,
    h = yval + er,
    col = yval,
    nm = paste("point", xval)
  )
df

##### x, y, name, color #### 
# x: 1,
# y: 9,
# name: "Point2",
# color: "#00FF00"
hchart(df, "column", x = xval, y = yval, color = col, name = nm)
hchart(df, "column", x = nm, y = yval, color = col, name = nm)

hchart(df, "point", x = xval, y = yval, color = col, name = nm)
hchart(df, "point", x = nm, y = yval, color = col, name = nm)

hchart(df, "line", x = xval, y = yval, color = col, name = nm)

hchart(df, "scatter", x = xval, y = yval, color = col, name = nm)
hchart(df, "point", x = xval, y = yval, color = col, name = nm)

hchart(df, "spline", x = xval, y = yval, color = col, name = nm)
hchart(df, "area", x = xval, y = yval, color = col, name = nm)
hchart(df, "areaspline", x = xval, y = yval, color = col, name = nm)

hchart(df, "bar", x = xval, y = yval, color = col, name = nm)
hchart(df, "bar", x = nm, y = yval, color = col, name = nm)

hchart(df, "polygon", x = xval, y = yval, color = col, name = nm)

hchart(df, "waterfall", x = xval, y = yval, color = col, name = nm)

#### x, y, z, name, color ####
# x: 1,
# y: 1,
# z: 1,
# name: "Point2",
# color: "#00FF00"
hchart(df, "bubble", x = xval, y = yval, size = zval, name = nm, color = col)
hchart(df, "point", x = xval, y = yval, size = zval, name = nm, color = col)
hchart(df, "scatter", x = xval, y = yval, size = zval, name = nm, color = col)

#### y, name, color ####
# y: 3,
# name: "Point2",
# color: "#00FF00"
hchart(df, "funnel", y = yval, name = nm, color = col)
hchart(df, "pie", y = yval, name = nm, color = col)
hchart(df, "pyramid", y = yval, name = nm, color = col)

# hchart(df, "gauge", y = yval, name = nm, color = col)
# hchart(df, "solidgauge", y = yval, name = nm, color = col)

##### x, low, high, name, color ####
# x: 1,
# low: 9,
# high: 0,
# name: "Point2",
# color: "#00FF00"
hchart(df, "arearange", x = xval, low = l, high = h, name = nm, color = col)
hchart(df, "areasplinerange", x = xval, low = l, high = h, name = nm, color = col)
hchart(df, "columnrange", x = xval, low = l, high = h, name = nm, color = col)
hchart(df, "errorbar", x = xval, low = l, high = h, name = nm, color = col)
hchart(df, "errorbar", x = nm, low = l, high = h, name = nm, color = col)

#### x, low, q1, median, q3, high, name, color #### 
# x: 1,
# low: 4,
# q1: 9,
# median: 9,
# q3: 1,
# high: 10,
# name: "Point2",
# color: "#00FF00"
hchart(df %>% mutate(qq1 = yval - er/2, qq3 = yval + er/2), "boxplot",
       x = xval, low = l, median = yval, high = h, name = nm, q1 = qq1, q3 = qq3, color = yval)

hchart(df %>% mutate(qq1 = yval - er/2, qq3 = yval + er/2), "boxplot",
       x = nm, low = l, median = yval, high = h, name = nm, q1 = qq1, q3 = qq3, color = yval)

#### x, y, value, name, color ####
# x: 1,
# y: 3,S
# value: 10,
# name: "Point2",
# color: "#00FF00"
data(diamonds, package = "ggplot2")
df2 <- group_by(diamonds, cut, color) %>% summarize(price = median(price))
hchart(df2, "heatmap", x = cut, y = color, value = price) 

data(mpg, package = "ggplot2")
df2 <- count(mpg, manufacturer, class)
# data <- mutate(df2, x = manufacturer, y = class, value = hwy)
hchart(df2, "heatmap", x = manufacturer, y = class, value = n) 

#### value, name, color ####
# value: 7,
# name: "Point2",
# color: "#00FF00"
hchart(df, "treemap", value = yval, name = nm, color = col)
hchart(df, "treemap", value = yval, name = nm)
