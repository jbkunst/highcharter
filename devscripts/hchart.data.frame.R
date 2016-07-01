#### PACAKGES ####
#+ warning=FALSE, message=FALSE
library(highcharter)
library(dplyr)
library(purrr)
library(lubridate)
library(ggplot2)
library(broom)


rm(list = ls())
options(highcharter.theme = hc_theme_smpl())

#### DATAS ####
data(diamonds, package = "ggplot2")
data(economics_long, package = "ggplot2")
data(economics, package = "ggplot2")
data(txhousing, package = "ggplot2")

#### FUNCTIONS ####
# in package

#### TESTS 1 ####
set.seed(123)
data <- sample_n(diamonds, 300)

hchart(data, "scatter", x = carat, y = price)
hchart(data, "scatter", x = carat, y = price, color = depth)
hchart(data, "scatter", x = carat, y = price, group = cut)
hchart(data, "scatter", x = carat, y = price, group = cut, size = z)

hchart(mpg, "scatter", x = displ, y = cty, color = hwy)
hchart(mpg, "scatter", x = displ, y = cty, size = hwy, group = manufacturer)
hchart(mpg, "scatter", x = displ, y = cty, size = hwy, color = class, group = year)

mpgman <- count(mpg, manufacturer)
hchart(mpgman, "column", x = manufacturer, y = n)

mpgman2 <- count(mpg, manufacturer, year)
hchart(mpgman2, "bar", x = manufacturer, y = n, group = year)

hchart(economics, "line", x = date, y = unemploy)
hchart(economics, "columnrange", x = date, low = psavert - 2, high = psavert + 2, color = unemploy)

economics_long2 <- filter(economics_long, variable %in% c("pop", "uempmed", "unemploy"))
hchart(economics_long2, "line", x = date, y = value01, group = variable)


txhousing %>% 
  group_by(city, year) %>% 
  summarize(median = median(median)) %>% 
  hchart("line", x = year, y = median, group = city) %>% 
  hc_plotOptions(series = list(marker = list(enabled = FALSE))) %>% 
  hc_legend(align = "left", layout = "vertical")

#### BROOM A LA GGPLOT ####
modlss <- loess(price ~ carat, data = data)
fit <- augment(modlss)

head(data)
head(fit)

highchart() %>% 
  hc_add_series_df(data, type = "scatter",  x = carat, y = price, group = cut) %>%
  hc_add_series_df(fit, type = "areasplinerange",x = carat,
                   low = .fitted - .se.fit, high = .fitted + .se.fit)


datalg <- read.csv("http://www.ats.ucla.edu/stat/data/binary.csv")
head(datalg)

modlg <- glm(admit ~ gre + gpa + rank, data = datalg, family = "binomial")
fit <- tidy(modlg)
head(fit)

highchart() %>% 
  hc_chart(type = "bar") %>% 
  hc_add_series_df(fit, "point", x = term, y = estimate) %>% 
  hc_add_series_df(fit, "errorbar",x = term,
                   low = estimate - std.error, high = estimate + std.error)


#### CHECK AES PARS ####
df <- data_frame(
  x = 1:10,
  y = 10 + x + 10 * sin(x)) %>% 
  mutate(
    y = round(y, 1),
    er = 10 * abs(rnorm(length(x))) + 2,
    er = round(er, 1),
    l = y - er,
    h = y + er,
    col = y,
    sz = (x*y) - median(x*y),
    nm = sample(LETTERS, size = length(y))
    )
df

##### x, y, name, color #### 
# x: 1,
# y: 9,
# name: "Point2",
# color: "#00FF00"
hchart(df, "column", x = x, y = y, color = col, name = nm)
hchart(df, "column", x = nm, y = y, color = col, name = nm)
hchart(df, "point", x = nm, y = y, color = col, name = nm)
hchart(df, "line", x = x, y = y, color = col, name = nm)
hchart(df, "scatter", x = x, y = y, color = col, name = nm)
hchart(df, "spline", x = x, y = y, color = col, name = nm)
hchart(df, "area", x = x, y = y, color = col, name = nm)
hchart(df, "areaspline", x = x, y = y, color = col, name = nm)
hchart(df, "bar", x = x, y = y, color = col, name = nm)
hchart(df, "polygon", x = x, y = y, color = col, name = nm)
hchart(df, "waterfall", x = x, y = y, color = col, name = nm)

#### x, y, z, name, color ####
# x: 1,
# y: 1,
# z: 1,
# name: "Point2",
# color: "#00FF00"
hchart(df, "bubble", x = x, y = y, size = sz, name = nm, color = col)

#### y, name, color ####
# y: 3,
# name: "Point2",
# color: "#00FF00"
hchart(df, "funnel", y = y, name = nm, color = col)
hchart(df, "pie", y = y, name = nm, color = col)
hchart(df, "pyramid", y = y, name = nm, color = col)
# hchart(df, "gauge", y = y, name = nm, color = col)
# hchart(df, "solidgauge", y = y, name = nm, color = col)

##### x, low, high, name, color ####
# x: 1,
# low: 9,
# high: 0,
# name: "Point2",
# color: "#00FF00"
hchart(df, "arearange", x = x, low = l, high = h, name = nm, color = col)
hchart(df, "areasplinerange", x = x, low = l, high = h, name = nm, color = col)
hchart(df, "columnrange", x = x, low = l, high = h, name = nm, color = col)
hchart(df, "errorbar", x = x, low = l, high = h, name = nm, color = col)
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
hchart(df %>% mutate(qq1 = y - er/2, qq3 = y + er/2), "boxplot",
     x = x, low = l, median = y, high = h, name = nm, q1 = qq1, q3 = qq3, color = y)

hchart(df %>% mutate(qq1 = y - er/2, qq3 = y + er/2), "boxplot",
     x = nm, low = l, median = y, high = h, name = nm, q1 = qq1, q3 = qq3, color = y)


# x, y, value, name, color ####
# x: 1,
# y: 3,
# value: 10,
# name: "Point2",
# color: "#00FF00"
hchart(df, "heatmap", x = x, y = y, value = sqrt(abs(sz)))

hchart(df, "heatmap", x = nm, y = y, value = sqrt(abs(sz))) %>% 
  hc_yAxis(type = "category")

#### value, name, color ####
# value: 7,
# name: "Point2",
# color: "#00FF00"
hchart(df, "treemap", value = y, name = nm, color = col)
