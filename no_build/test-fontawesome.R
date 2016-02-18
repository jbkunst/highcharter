library("shiny")
library("MASS")
title <- as.character(
  tags$div(icon("quote-left"),
           "This is a", icon("bar-chart"),
           " with a awesome icon")
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


