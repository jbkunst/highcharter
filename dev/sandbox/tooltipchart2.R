library(highcharter)
library(tidyverse)
library(gapminder)
options(highcharter.theme = hc_theme_smpl())

gp <- gapminder %>% 
  arrange(desc(year)) %>% 
  distinct(country, .keep_all = TRUE)

gppop <- gapminder %>% 
  select(country, x = year, y = pop) %>% 
  nest(-country) %>% 
  mutate(data = map(data, list_parse)) %>% 
  rename(ttdata = data)

gptot <- left_join(gp, gppop)

hchart(gptot, "point", hcaes(lifeExp, gdpPercap, name = country, size = pop, group = continent)) %>% 
  hc_title(text = "In #rstats you can have #VizinTooltip") %>% 
  hc_yAxis(type = "logarithmic", title = list(text = "GDP per capita")) %>%
  hc_xAxis(title = list(text = "Life expectancy at birth, in years")) %>% 
  hc_tooltip(
    useHTML = TRUE,
    pointFormatter = tooltip_chart(
      accesor = "ttdata",
      hc_opts = list(
        chart = list(type = "area"),
        title = list(text = "point.name"),
        subtitle = list(text = "Population"),
        plotOptions = list(series = list(animation = 2000, name = "point.name"))
        )
      )
    )
