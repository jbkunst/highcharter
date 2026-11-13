#' --- 
#' output: html_document
#' title: Issue 138
#' --- 
#'
#' From https://github.com/jbkunst/highcharter/issues/138

library(highcharter)
hc_set_theme("smpl")

data(mpg, package = "ggplot2")

hchart(mpg, type = "scatter", x = hwy, y = displ) %>% 
  hc_tooltip(
    headerFormat = "", # remove 
    pointFormat = "{point.model}<br>Actuals = {point.x}, Predicted = {point.y}"
    )


hchart(mpg, type = "scatter", x = hwy, y = displ, group = manufacturer) %>% 
  hc_tooltip(
    headerFormat = "", # remove 
    pointFormat = "<b>{point.manufacturer} {point.model}</b>
    <br>Actuals = {point.x}, Predicted = {point.y}"
  )
