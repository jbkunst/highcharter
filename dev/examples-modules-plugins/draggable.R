library("highcharter")
data("citytemp")

highchart() %>% 
  hc_chart(animation = FALSE) %>% 
  hc_title(text = "draggable points demo") %>% 
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
  hc_add_series(data = sample(1:12),
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
