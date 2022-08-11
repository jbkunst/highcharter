# from https://jsfiddle.net/gh/get/library/pure/highcharts/highcharts/tree/master/samples/highcharts/demo/variwide
# 
library(highcharter)

highchartzero() %>% 
  hc_add_series(
    name = 'Labor Costs',
    data = list(
      list('Norway', 50.2, 335504),
      list('Denmark', 42, 277339),
      list('Belgium', 39.2, 421611),
      list('Sweden', 38, 462057),
      list('France', 35.6, 2228857),
      list('Netherlands', 34.3, 702641),
      list('Finland', 33.2, 215615),
      list('Germany', 33.0, 3144050),
      list('Austria', 32.7, 349344),
      list('Ireland', 30.4, 275567),
      list('Italy', 27.8, 1672438),
      list('United Kingdom', 26.7, 2366911),
      list('Spain', 21.3, 1113851),
      list('Greece', 14.2, 175887),
      list('Portugal', 13.7, 184933),
      list('Czech Republic', 10.2, 176564),
      list('Poland', 8.6, 424269),
      list('Romania', 5.5, 169578)
    ),
    type = "variwide",
    colorByPoint = TRUE,
    dataLabels = list(
      enabled = TRUE,
      format = '€{point.y:.0f}'
    ),
    tooltip = list(
      pointFormat = paste('Labor Costs: <b>€ {point.y}/h</b><br>',
                          'GDP: <b>€ {point.z} million</b><br>')
      )
  ) %>% 
  hc_title(text = 'Labor Costs in Europe, 2016') %>% 
  hc_xAxis(type = "category") %>% 
  hc_add_dependency("modules/variwide.js")
