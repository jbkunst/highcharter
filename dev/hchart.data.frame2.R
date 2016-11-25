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

head(df)

##### x, y, name, color #### 
# x: 1,
# y: 9,
# name: "Point2",
# color: "#00FF00"
hchart(df, "column", hcaes(x = xval, y = yval, color = col, name = nm))
hchart(df, "column", hcaes(x = nm, y = yval, color = col, name = nm))

hchart(df, "point", hcaes(x = xval, y = yval, color = col, name = nm))
hchart(df, "point", hcaes(x = nm, y = yval, color = col, name = nm))

hchart(df, "line", hcaes(x = xval, y = yval, color = col, name = nm))

hchart(df, "scatter", hcaes(x = xval, y = yval, color = col, name = nm))
hchart(df, "point", hcaes(x = xval, y = yval, color = col, name = nm))

hchart(df, "spline", hcaes(x = xval, y = yval, color = col, name = nm))
hchart(df, "area", hcaes(x = xval, y = yval, color = col, name = nm))
hchart(df, "areaspline", hcaes(x = xval, y = yval, color = col, name = nm))

hchart(df, "bar", hcaes(x = xval, y = yval, color = col, name = nm))
hchart(df, "bar", hcaes(x = nm, y = yval, color = col, name = nm))

hchart(df, "polygon", hcaes(x = xval, y = yval, color = col, name = nm))

hchart(df, "waterfall", hcaes(x = xval, y = yval, color = col, name = nm))

#### x, y, z, name, color ####
# x: 1,
# y: 1,
# z: 1,
# name: "Point2",
# color: "#00FF00"
hchart(df, "bubble", hcaes(x = xval, y = yval, size = zval, name = nm, color = col))
hchart(df, "point", hcaes(x = xval, y = yval, size = zval, name = nm, color = col))
hchart(df, "scatter", hcaes(x = xval, y = yval, size = zval, name = nm, color = col))

#### y, name, color ####
# y: 3,
# name: "Point2",
# color: "#00FF00"
hchart(df, "funnel", hcaes(y = yval, name = nm, color = col))
hchart(df, "pie", hcaes(y = yval, name = nm, color = col))
hchart(df, "pyramid", hcaes(y = yval, name = nm, color = col))

# hchart(df, "gauge", y = yval, name = nm, color = col)
# hchart(df, "solidgauge", y = yval, name = nm, color = col)

##### x, low, high, name, color ####
# x: 1,
# low: 9,
# high: 0,
# name: "Point2",
# color: "#00FF00"
hchart(df, "arearange", hcaes(x = xval, low = l, high = h, name = nm, color = col))
hchart(df, "areasplinerange", hcaes(x = xval, low = l, high = h, name = nm, color = col))
hchart(df, "columnrange", hcaes(x = xval, low = l, high = h, name = nm, color = col))
hchart(df, "errorbar", hcaes(x = xval, low = l, high = h, name = nm, color = col))
hchart(df, "errorbar", hcaes(x = nm, low = l, high = h, name = nm, color = col))

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
       hcaes(x = xval, low = l, median = yval, high = h, name = nm, q1 = qq1, q3 = qq3, color = yval))

hchart(df %>% mutate(qq1 = yval - er/2, qq3 = yval + er/2), "boxplot",
       hcaes(x = nm, low = l, median = yval, high = h, name = nm, q1 = qq1, q3 = qq3, color = yval))

#### x, y, value, name, color ####
# x: 1,
# y: 3,S
# value: 10,
# name: "Point2",
# color: "#00FF00"
data(diamonds, package = "ggplot2")
df2 <- group_by(diamonds, cut, color) %>% summarize(price = median(price))
hchart(df2, "heatmap", hcaes(x = cut, y = color, value = price))

data(mpg, package = "ggplot2")
df2 <- count(mpg, manufacturer, class)
# data <- mutate(df2, x = manufacturer, y = class, value = hwy)
hchart(df2, "heatmap", hcaes(x = manufacturer, y = class, value = n))

#### value, name, color ####
# value: 7,
# name: "Point2",
# color: "#00FF00"
hchart(df, "treemap", hcaes(value = yval, name = nm, color = col))
hchart(df, "treemap", hcaes(value = yval, name = nm))
