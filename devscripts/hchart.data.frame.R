#' ---
#' output: html_document
#' ---
#+ warning=FALSE, message=FALSE
#### PACAKGES ####
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
hchart(mpgman, "bar", x = manufacturer, y = n)
hchart(mpgman, "treemap", x = manufacturer, value = n)

mpgman2 <- count(mpg, manufacturer, year)
hchart(mpgman2, "bar", x = manufacturer, y = n, group = year)

mpgman3 <- group_by(mpg, manufacturer) %>% 
  summarise(n = n(), unique = length(unique(model))) %>% 
  arrange(-n, -unique)
hchart(mpgman3, "treemap", x = manufacturer, value = n, color = unique)


hchart(economics, "line", x = date, y = unemploy)
hchart(economics, "columnrange", x = date, low = psavert - 2, high = psavert + 2, color = unemploy)

economics_long2 <- filter(economics_long, variable %in% c("pop", "uempmed", "unemploy"))
hchart(economics_long2, "line", x = date, y = value01, group = variable)

txhousing %>% 
  filter(city %in% sample(city, size = 20)) %>% 
  group_by(city, year) %>% 
  summarize(median = median(median)) %>% 
  hchart("spline", x = year, y = median, group = city) %>% 
  hc_legend(align = "left", layout = "vertical")

dfdiam <- group_by(diamonds, cut, color) %>% summarize(price = median(price))
hchart(dfdiam, "heatmap", x = cut, y = color, value = price) 

dfmanclass <- count(mpg, manufacturer, class)
hchart(dfmanclass, "heatmap", x = manufacturer, y = class, value = n) 


#### BROOM A LA GGPLOT I ####
modlss <- loess(price ~ carat, data = data)
fit <- augment(modlss) %>% arrange(carat)

head(data)
head(fit)

hchart(data, type = "scatter", x = carat, y = price) %>%
  hc_add_series_df(fit, type = "arearange",x = carat,
                   low = .fitted - .se.fit, high = .fitted + .se.fit)

#### BROOM A LA GGPLOT II ####
# this can be hchart.gml
modlm <- step(lm(mpg ~ ., data = mtcars), trace = FALSE)
moddf <- tidy(modlm)

hchart(moddf, "errorbar",
       x = term, low = estimate - std.error, high = estimate + std.error) %>% 
  hc_add_series_df(moddf, "point", x = term, y = estimate) %>% 
  hc_chart(type = "bar")


