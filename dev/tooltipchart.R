library(highcharter)
library(gapminder)
library(dplyr)
library(purrr)
library(tidyr)
library(rlang)
data(gapminder, package = "gapminder")
glimpse(gapminder)


# data --------------------------------------------------------------------
gp <- gapminder %>% 
  arrange(desc(year)) %>% 
  distinct(country, .keep_all = TRUE)
gp


gpmini <- ""

data <- gapminder

mppng <- hcaes(x = year, y = lifeExp)


gpmini <- gapminder %>% 
  arrange(year) %>%
  nest(-country) %>% 
  mutate(data = map(data, mutate_mapping, hcaes(x = year, y = lifeExp), drop = TRUE),
         data = map(data, list_parse)) %>% 
  rename(tooltipdata = data)

gptot <- left_join(gp, gpmini)

gptot

hchart(gp, "point", hcaes(lifeExp, gdpPercap, size = pop, group = continent)) %>% 
  hc_yAxis(type = "logarithmic") %>% 

hc

point_formatter_minichart <- 
  function(
    hc_opts = list(
      series = list(list(data = JS("thiz.tooltipdata"))),
      legend = list(enabled = FALSE)
      ),
    width = 250,
    height = 150
    ) {
  
  
  id <- highcharter:::random_id()
  
  hcopts <- toJSON(hc_opts, pretty = TRUE, auto_unbox = TRUE, force = TRUE, null = "null", na = "null")
  hcopts <- as.character(hcopts)
  
  jss <- sprintf("function() {
  var thiz = this;
  setTimeout(function() {

    $('tooltipchart-%s').highcharts({%s})

  }, 0)

  return '<div id=\"tooltipchart-%s\" style=\"width: %s; height: %s;\"></div>';

  }", id, hcopts, id, width, height)
  
  jss
  
}

library(highcharter)
point_formatter_minichart()




minichart <- "function(){
var thiz = this;
console.log(thiz);
setTimeout(function() {$('#minichart').highcharts({});}, 0);
return '<div id=\"minichart\" style=\"width: 250px; height: 150px;\"></div>';
}                        
"

hc <- hc %>% 
  hc_tooltip(
    useHTML = TRUE,
    positioner = JS("function () { return { x: this.chart.plotLeft + 0, y: 0 }; }"),
    headerFormat = "{point.country}",
    pointFormatter = JS(minichart)
  )
hc

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
  hc_yAxis(type = "logarithmic", min = 100, max = 100000) %>% 
  hc_tooltip(
    useHTML = TRUE,
    positioner = JS("function () { return { x: this.chart.plotLeft + 0, y: 0 }; }"),
    headerFormat = "{point.country}",
    pointFormatter = JS(minichart)
  )
hc
