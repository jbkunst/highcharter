library(ggplot2)
library(highcharter)
library(dplyr)

data(mpg)

cc <- count(mpg, class, sort = TRUE)
cc

mpg <- filter(mpg, class %in% head(cc$class, 4))

qplot(displ, cty, color = class, data = mpg, geom = "point")

hc_theme_ggplot2 <- function(...) {
  
  hc_theme(
    chart = list(
      plotBackgroundColor = "#EBEBEB",
      style = list(
        fontFamily = "Arial, sans-serif"
      )
    ),
    colors = c("#595959", "#F8766D", "#A3A500", "#00BF7D", "#00B0F6", "#E76BF3"),
    xAxis = list(
      gridLineColor = "#FFFFFF",
      gridLineWidth = 1.5,
      minorTickInterval = 0,
      minorGridLineColor = "#FFFFFF",
      minorGridLineWidth = 0.5
    ),
    yAxis = list(
      gridLineColor = "#FFFFFF",
      gridLineWidth = 1.5,
      minorTickInterval = 0,
      minorGridLineColor = "#FFFFFF",
      minorGridLineWidth = 0.5
    ),
    legendBackgroundColor = "rgba(0, 0, 0, 0.5)",
    background2 = "#505053",
    dataLabelsColor = "#B0B0B3",
    textColor = "#C0C0C0",
    contrastTextColor = "#F0F0F3",
    maskColor = "rgba(255,255,255,0.3)"
  )
  
}

# gg_color_hue <- function(n) {
#   hues = seq(15, 375, length = n + 1)
#   hcl(h = hues, l = 65, c = 100)[1:n]
# }
# dput(gg_color_hue(5))

hchart(mpg, "point", hcaes(displ, cty)) %>% 
  hc_add_theme(hc_theme_ggplot2())


hchart(mpg, "point", hcaes(displ, cty, group = class)) %>% 
  hc_add_theme(hc_theme_ggplot2())


data(mpg)
mpg

dens <- mpg %>% 
  group_by(cyl) %>% 
  do(den = density(.$cty)) %>% 
  { .$den }

library(purrr)

reduce(dens, hc_add_series, .init = highchart(), type = "area", fillOpacity = 0.25) %>% 
  hc_add_theme(hc_theme_ggplot2())

ggplot(mpg) + 
  geom_density(aes(cty, fill = as.factor(cyl)), alpha = 0.25)


