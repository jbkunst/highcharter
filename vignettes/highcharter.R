## ---- warning = FALSE, message = FALSE, echo = FALSE---------------------
library(highcharter)
library(dplyr)
options(highcharter.theme = hc_theme_smpl(), highcharter.debug = TRUE)

## ------------------------------------------------------------------------
data("mpg", package = "ggplot2")
head(mpg)

## ------------------------------------------------------------------------
hchart(mpg, "point", hcaes(x = displ, y = cty))

## ------------------------------------------------------------------------
highchart() %>% 
  hc_add_series(mpg, "point", hcaes(x = displ, y = cty))

## ------------------------------------------------------------------------
data("diamonds", package = "ggplot2")
dfdiam <- diamonds %>% 
  group_by(cut, clarity) %>%
  summarize(price = median(price))

head(dfdiam)

hchart(dfdiam, "heatmap", hcaes(x = cut, y = clarity, value = price)) 

## ------------------------------------------------------------------------
data(economics_long, package = "ggplot2")

economics_long2 <- filter(economics_long,
                          variable %in% c("pop", "uempmed", "unemploy"))

head(economics_long2)

hchart(economics_long2, "line", hcaes(x = date, y = value01, group = variable))

## ------------------------------------------------------------------------
data(mpg, package = "ggplot2")

mpgman <- mpg %>% 
  group_by(manufacturer) %>% 
  summarise(n = n(),
            unique = length(unique(model))) %>% 
  arrange(-n, -unique)

head(mpgman)

hchart(mpgman, "treemap", hcaes(x = manufacturer, value = n, color = unique))

## ------------------------------------------------------------------------
mpgman2 <- count(mpg, manufacturer, year)

head(mpgman2)

hchart(mpgman2, "bar", hcaes(x = manufacturer, y = n, group = year),
       color = c("#FCA50A", "#FCFFA4"),
       name = c("Year 1999", "Year 2008"))

## ---- message=FALSE------------------------------------------------------
library(dplyr)
library(broom)


## ------------------------------------------------------------------------
data(diamonds, package = "ggplot2")

set.seed(123)
data <- diamonds %>% 
  filter(carat > 0.75, carat < 3) %>% 
  sample_n(500)

modlss <- loess(price ~ carat, data = data)
fit <- arrange(augment(modlss), carat)

head(fit)

## ------------------------------------------------------------------------
highchart() %>% 
  hc_add_series(
    data,
    type = "scatter",
    hcaes(x = carat, y = price, size = depth, group = cut),
    maxSize = 5 # max size for bubbles
    ) %>%
  hc_add_series(
    fit,
    type = "spline",
    hcaes(x = carat, y = .fitted),
    name = "Fit",
    id = "fit", # this is for link the arearange series to this one and have one legend
    lineWidth = 1 
    ) %>% 
  hc_add_series(
    fit,
    type = "arearange",
    hcaes(x = carat, low = .fitted - 3*.se.fit, high = .fitted + 3*.se.fit),
    linkedTo = "fit", # here we link the legends in one.
    color = hex_to_rgba("gray", 0.2),  # put a semi transparent color
    zIndex = -3 # this is for put the series in a back so the points are showed first
    )

