library("shiny")
library("highcharter")

title <- tags$div(icon("quote-left"), "This is a h1 title with a awesome icon", icon("bar-chart"))
title <- as.character(title)

subtitle <- tags$div("This can be", icon("thumbs-o-up"), "wait for it... awesome")
subtitle <- as.character(subtitle)

# https://github.com/FortAwesome/Font-Awesome/blob/master/less/variables.less

highchart() %>%
  hc_title(text = title, useHTML = TRUE) %>% 
  hc_subtitle(text = subtitle, useHTML = TRUE) %>% 
  hc_tooltip(
    useHTML = TRUE,
    pointFormat = '<span style="color:{series.color};">{series.options.icon}</span> {series.name}: <b>[{point.x}, {point.y}]</b><br/>'
  ) %>% 
  hc_add_series_scatter(mtcars$mpg[1:16], mtcars$disp[1:16],
                        marker = list(symbol = "text:f1b9"),
                        icon = as.character(shiny::icon("car")),
                        name = "cars", showInLegend = TRUE) %>% 
  hc_add_series_scatter(mtcars$mpg[17:32], mtcars$disp[17:32],
                        marker = list(symbol = "text:f1ba"),
                        icon = as.character(shiny::icon("taxi")),
                        name = "cabs", showInLegend = TRUE)  %>% 
  hc_add_theme(hc_theme_google()) %>% 
  hc_chart(zoomType = "xy")
