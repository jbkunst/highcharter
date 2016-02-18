#' ---
#' layout: post
#' ---
#+echo=FALSE
rm(list = ls())
library("highcharter")

#' ## Plugins 
#' 
#' Highcharter include some plugins for highcharts so you have almost
#' no limits to implement whatever you want.
#' 

#' ### FontAwesome Integration ####

library("shiny")
library("MASS")

title <- as.character(
  tags$div(icon("quote-left"),
           "This is a", icon("bar-chart"),
           " with an awesome icon")
)

subtitle <- as.character(
  tags$div("This can be",
           icon("thumbs-o-up"),
           "wait for it... awesome")
)

dscars <- round(mvrnorm(n = 20, mu = c(1, 1), Sigma = matrix(c(1,0,0,1),2)), 2)
dsplan <- round(mvrnorm(n = 10, mu = c(3, 4), Sigma = matrix(c(2,.5,2,2),2)), 2)
dstrck <- round(mvrnorm(n = 15, mu = c(5, 1), Sigma = matrix(c(1,.5,.5,1),2)), 2)

highchart() %>%
  hc_title(text = title, useHTML = TRUE) %>% 
  hc_subtitle(text = subtitle, useHTML = TRUE) %>% 
  hc_chart(type = "scatter") %>% 
  hc_tooltip(
    useHTML = TRUE,
    pointFormat = paste0("<span style=\"color:{series.color};\">{series.options.icon}</span>",
                         "{series.name}: <b>[{point.x}, {point.y}]</b><br/>")
  ) %>% 
  hc_add_series(data = list.parse2(as.data.frame(dscars)),
                marker = list(symbol = fa_icon_mark("car")),
                icon = fa_icon("car"), name = "car",
                color = "rgba(250, 250, 250, 0.75)") %>% 
  hc_add_series(data = list.parse2(as.data.frame(dsplan)),
                marker = list(symbol = fa_icon_mark("plane")),
                icon = fa_icon("plane"), name = "plane",
                color = "rgba(169, 207, 84, 0.75)") %>% 
  hc_add_series(data = list.parse2(as.data.frame(dstrck)),
                marker = list(symbol = fa_icon_mark("truck")),
                icon = fa_icon("truck"), name = "truck",
                color = "rgba(194, 60, 42, 0.75)") %>% 
  hc_add_theme(hc_theme_db()) %>% 
  hc_chart(zoomType = "xy")


#' ### Draggable points ####
#' 
data("citytemp")

highchart() %>% 
  hc_chart(animation = FALSE) %>% 
  hc_title(text = "draggable points demo") %>% 
  hc_subtitle(text = "Drang my points plz") %>% 
  hc_xAxis(categories = month.abb) %>% 
  hc_plotOptions(
    series = list(
      point = list(
        events = list(
          drop = JS("function(){
                    alert(this.series.name + ' ' + this.category + ' ' + Highcharts.numberFormat(this.y, 2))
                    }")
        )
          ),
      stickyTracking = FALSE
        ),
    column = list(
      stacking = "normal"
    ),
    line = list(
      cursor = "ns-resize"
    )
    ) %>% 
  hc_tooltip(yDecimals = 2) %>% 
  hc_add_series(
    data = citytemp$tokyo,
    draggableY = TRUE,
    dragMinY = 0,
    type = "column",
    minPointLength = 2
  ) %>% 
  hc_add_series(
    data = citytemp$new_york,
    draggableY = TRUE,
    dragMinY = 0,
    type = "column",
    minPointLength = 2
  ) %>% 
  hc_add_series(
    data = citytemp$berlin,
    draggableY = TRUE
  )

#' ### Pattern fill

highchart() %>% 
  hc_title(text = "I'm an old school school chart") %>% 
  hc_xAxis(categories = month.abb) %>% 
  hc_add_series(data = c(7.0, 6.9, 9.5, 14.5, 18.2, 21.5, 25.2,
                         26.5, 23.3, 18.3, 13.9, 9.6),
                type = "column",
                color = 'url(#highcharts-default-pattern-0)') %>% 
  hc_add_theme(hc_theme_chalk())

highchart() %>% 
  hc_title(text = "I'm a pirate looking chart") %>% 
  hc_xAxis(categories = month.abb) %>% 
  hc_defs(patterns = list(
    list(id = 'custom-pattern',
         path = list(d = 'M 0 0 L 10 10 M 9 -1 L 11 1 M -1 9 L 1 11',
                     stroke = "black",
                     strokeWidth = 1
         )
    )
  )) %>% 
  hc_add_series(data = c(7.0, 6.9, 9.5, 14.5, 18.2, 21.5, 25.2,
                         26.5, 23.3, 18.3, 13.9, 9.6),
                type = "area",
                fillColor = 'url(#custom-pattern)') %>% 
  hc_add_theme(hc_theme_handdrawn())

