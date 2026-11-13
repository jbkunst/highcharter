library(ggplot2)
library(highcharter)
library(dplyr)

data(mpg)

cc <- count(mpg, class, sort = TRUE)
cc

mpg <- filter(mpg, class %in% head(cc$class, 4))

qplot(displ, cty, color = class, data = mpg, geom = "point")

# gg_color_hue <- function(n) {
#   hues = seq(15, 375, length = n + 1)
#   hcl(h = hues, l = 65, c = 100)[1:n]
# }
# dput(gg_color_hue(5))

hchart(mpg, "point", hcaes(displ, cty)) %>% 
  hc_add_theme(hc_theme("ggplot2")) %>%
  hc_title(text = "asd")


hchart(mpg, "point", hcaes(displ, cty, group = class)) %>% 
  hc_add_theme(hc_theme("ggplot2"))


data(mpg)
mpg

dens <- mpg %>% 
  group_by(cyl) %>% 
  do(den = density(.$cty)) %>% 
  { .$den }

library(purrr)

reduce(dens, hc_add_series, .init = highchart(), type = "area", fillOpacity = 0.25) %>% 
  hc_add_theme(hc_theme("ggplot2"))

ggplot(mpg) + 
  geom_density(aes(cty, fill = as.factor(cyl)), alpha = 0.25)


