library(highcharter)
library(gapminder)
library(tidyverse)
data(gapminder, package = "gapminder")
glimpse(gapminder)
options(highcharter.debug = TRUE)

gp <- gapminder %>% 
  arrange(desc(year)) %>% 
  distinct(country, .keep_all = TRUE)
gp

hc <- hchart(gp, "point", hcaes(lifeExp, gdpPercap, size = pop, group = continent))

hc %>% 
  hc_yAxis(type = "logarithmic")

gp3 <- gapminder %>% 
  select(country, x = lifeExp, y = gdpPercap, z = pop) %>% 
  nest(-country) %>% 
  rename(sequence = data) %>% 
  mutate(sequence = map(sequence, list_parse))

gp <- left_join(gp, gp3)

hc <- hchart(gp, "point", hcaes(lifeExp, gdpPercap, size = pop, group = continent)) %>% 
  hc_yAxis(type = "logarithmic")

hc

hc <- hc %>% 
  hc_motion(enabled = TRUE, series = 0:4, labels = sort(unique(gapminder$year)),
            loop = FALSE, autoPlay = TRUE, 
            updateInterval = 500, magnet = list(step =  1)) %>% 
  hc_xAxis(min = 20, max = 90) %>% 
  hc_yAxis(type = "logarithmic", min = 100, max = 100000)
hc
