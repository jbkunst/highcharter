library(highcharter)
library(gapminder)
library(dplyr)
library(purrr)
data(gapminder, package = "gapminder")
glimpse(gapminder)

gp <- gapminder %>% 
  arrange(desc(year)) %>% 
  distinct(country, .keep_all = TRUE)
gp

hc <- hchart(gp, "point", hcaes(lifeExp, gdpPercap, size = pop, group = continent))

hc %>% 
  hc_yAxis(type = "logarithmic")

gp2 <- gapminder %>% 
  group_by(country) %>% 
  do(lifeexpdata = .$lifeExp)
gp2

gp <- left_join(gp, gp2)


hc <- hchart(gp, "point", hcaes(lifeExp, gdpPercap, size = pop, group = continent)) %>% 
  hc_yAxis(type = "logarithmic")

hc

minichart <- "function(){
var thiz = this;
console.log(thiz);
setTimeout(function() {
$('#minichart').highcharts({
title : {
text: ''
},
subtitle: {
text: thiz.country,
align: 'left'
},
exporting: {
enabled: false
},
legend: {
enabled : false
},
series: [{
animation: false,
color: thiz.color,
pointStart: 1952,
data: thiz.lifeexpdata
}],
yAxis: {
title: ''
},
xAxis: {
}
});
}, 0);
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
