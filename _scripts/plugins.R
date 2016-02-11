#' ---
#' layout: post
#' ---
#' 
#' ## Plugins 
#' 
#' Highcharter include some plugins for highcharts so you have almost
#' no limits to implement whatever you want.
#' 
#' ### Draggable points ####

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
  hc_title(text = "I'm a pirate looking chart") %>% 
  hc_add_series(data = c(7.0, 6.9, 9.5, 14.5, 18.2, 21.5, 25.2,
                         26.5, 23.3, 18.3, 13.9, 9.6),
                type = "column",
                color = 'url(#highcharts-default-pattern-0)') %>% 
  hc_add_theme(hc_theme_handdrawn())

highchart() %>% 
  hc_title(text = "I'm an old school school chart") %>% 
  hc_defs(patterns = list(
    list(id = 'custom-pattern',
         path = list(d = 'M 0 0 L 10 10 M 9 -1 L 11 1 M -1 9 L 1 11',
                     stroke = "white",
                     strokeWidth = 1
         )
    )
  )) %>% 
  hc_add_series(data = c(7.0, 6.9, 9.5, 14.5, 18.2, 21.5, 25.2,
                         26.5, 23.3, 18.3, 13.9, 9.6),
                type = "area",
                fillColor = 'url(#custom-pattern)') %>% 
  hc_add_theme(hc_theme_chalk())

