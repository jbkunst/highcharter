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
diamonds$color <- NULL

hchart(data, "scatter", hcaes(x = carat, y = price))
hchart(data, "scatter", hcaes(x = carat, y = price, color = depth))
hchart(data, "scatter", hcaes(x = carat, y = price, group = cut))
hchart(data, "scatter", hcaes(x = carat, y = price, group = cut, size = z))
# hc_add_series(highchart(), data, "scatter", hcaes(x = carat, y = price, group = cut, size = z))

hchart(mpg, "scatter", hcaes(x = displ, y = cty, color = hwy))
hchart(mpg, "scatter", hcaes(x = displ, y = cty, size = hwy, group = manufacturer))
hchart(mpg, "scatter", hcaes(x = displ, y = cty, size = hwy, color = class, group = year))

mpgman <- count(mpg, manufacturer)
hchart(mpgman, "column", hcaes(x = manufacturer, y = n))
hchart(mpgman, "bar", hcaes(x = manufacturer, y = n))
hchart(mpgman, "treemap", hcaes(x = manufacturer, value = n))

mpgman2 <- count(mpg, manufacturer, year)
hchart(mpgman2, "column", hcaes(x = manufacturer, y = n, group = year))
hchart(mpgman2, "bar", hcaes(x = manufacturer, y = n, group = year))

mpgman3 <- group_by(mpg, manufacturer) %>% 
  summarise(n = n(), unique = length(unique(model))) %>% 
  arrange(-n, -unique)

hchart(mpgman3, "treemap", hcaes(x = manufacturer, value = n, color = unique))

hchart(economics, "line", hcaes(x = date, y = unemploy))
hchart(economics, "columnrange", hcaes(x = date, low = psavert - 2, high = psavert + 2, color = unemploy),
       name = "ColumRange Series")

economics_long2 <- filter(economics_long, variable %in% c("pop", "uempmed", "unemploy"))
hchart(economics_long2, "line", hcaes(x = date, y = value01, group = variable)) %>% 
  hc_tooltip(sort = TRUE, table = TRUE)



cities <- count(txhousing, city, sort = TRUE)[1:30, 1][[1]]
  

txhousing %>% 
  filter(city %in% cities) %>% 
  group_by(city, year) %>% 
  summarize(median = median(median)) %>% 
  hchart("spline", hcaes(x = year, y = median, group = city)) %>% 
  hc_legend(align = "left", layout = "vertical", verticalAlign = "top") %>% 
  hc_tooltip(sort = TRUE, table = TRUE)


dfdiam <- group_by(diamonds, cut, clarity) %>% summarize(price = median(price))
hchart(dfdiam, "heatmap", hcaes(x = cut, y = clarity, value = price)) 

dfmanclass <- count(mpg, manufacturer, class)
hchart(dfmanclass, "heatmap", hcaes(x = manufacturer, y = class, value = n))


#### BROOM A LA GGPLOT I ####
modlss <- loess(price ~ carat, data = data)
fit <- augment(modlss) %>% arrange(carat)

head(data)
head(fit)

highchart() %>% 
  hc_add_series(data, type = "scatter", hcaes(x = carat, y = price), name = "Data") %>%
  hc_add_series(fit, type = "spline", hcaes(x = carat, y = .fitted), name = "Fit",
                id = "fit") %>% 
  hc_add_series(fit, type = "arearange",
                hcaes(x = carat, low = .fitted - .se.fit*2, high = .fitted + .se.fit*2),
                linkedTo = "fit")

#### BROOM A LA GGPLOT II ####
# this can be hchart.gml
modlm <- step(lm(mpg ~ ., data = mtcars), trace = FALSE)
moddf <- tidy(modlm)

highchart() %>% 
  hc_chart(type = "bar") %>% 
  hc_xAxis(categories = moddf$term) %>% 
  hc_add_series(moddf, "point", hcaes(x = term, y = estimate), name = "Estimate") %>% 
  hc_add_series(moddf, "errorbar", hcaes(x = term, low = estimate - std.error, high = estimate + std.error),
                linkedTo = NA, showInLegend = TRUE, name = "Error")
  


