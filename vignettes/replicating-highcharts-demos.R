## ------------------------------------------------------------------------
library("highcharter")

highchart() %>% 
  hc_chart(type = "line") %>% 
  hc_title(text = "Monthly Average Temperature") %>% 
  hc_subtitle(text = "Source: WorldClimate.com") %>% 
  hc_xAxis(categories = c('Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                          'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec')) %>% 
  hc_yAxis(title = list(text = "Temperature (C)")) %>% 
  hc_plotOptions(line = list(
    dataLabels = list(enabled = TRUE),
    enableMouseTracking = FALSE)
    ) %>% 
  hc_series(
    list(
      name = "Tokyo",
      data = c(7.0, 6.9, 9.5, 14.5, 18.4, 21.5, 25.2, 26.5, 23.3, 18.3, 13.9, 9.6)
    ),
    list(
      name = "London",
      data = c(3.9, 4.2, 5.7, 8.5, 11.9, 15.2, 17.0, 16.6, 14.2, 10.3, 6.6, 4.8)
    )
  )

## ------------------------------------------------------------------------
hc <- highchart() %>% 
  hc_chart(type = "area") %>% 
  hc_title(text = "Historic and Estimated Worldwide Population Distribution by Region") %>% 
  hc_subtitle(text = "Source: Wikipedia.org") %>% 
  hc_xAxis(categories = c('1750', '1800', '1850', '1900', '1950', '1999', '2050'),
           tickmarkPlacement = 'on',
           title = list(enabled = FALSE)) %>% 
  hc_yAxis(title = list(text = "Percent")) %>% 
  hc_tooltip(pointFormat = '<span style="color:{series.color}">{series.name}</span>:
             <b>{point.percentage:.1f}%</b> ({point.y:,.0f} millions)<br/>',
             shared = TRUE) %>% 
  hc_plotOptions(area = list(
     stacking = "percent",
     lineColor = "#ffffff",
     lineWidth = 1,
     marker = list(
       lineWidth = 1,
       lineColor = "#ffffff"
       ))
     ) %>% 
  hc_add_series(name = "Asia", data = c(502, 635, 809, 947, 1402, 3634, 5268)) %>% 
  hc_add_series(name = "Africa", data = c(106, 107, 111, 133, 221, 767, 1766)) %>%
  hc_add_series(name = "Europe", data = c(163, 203, 276, 408, 547, 729, 628)) %>% 
  hc_add_series(name = "America", data = c(18, 31, 54, 156, 339, 818, 1201)) %>% 
  hc_add_series(name = "Oceania", data = c(2, 2, 2, 6, 13, 30, 46)) 
       
hc


## ------------------------------------------------------------------------
highchart() %>% 
  hc_chart(polar = TRUE, type = "line") %>% 
  hc_title(text = "Budget vs Spending") %>% 
  hc_xAxis(categories = c('Sales', 'Marketing', 'Development', 'Customer Support', 
                          'Information Technology', 'Administration'),
           tickmarkPlacement = 'on',
           lineWidth = 0) %>% 
  hc_yAxis(gridLineInterpolation = 'polygon',
           lineWidth = 0,
           min = 0) %>% 
  hc_series(
    list(
      name = "Allocated Budget",
      data = c(43000, 19000, 60000, 35000, 17000, 10000),
      pointPlacement = 'on'
    ),
    list(
      name = "Actual Spending",
      data = c(50000, 39000, 42000, 31000, 26000, 14000),
     pointPlacement = 'on'
    )
  )

## ------------------------------------------------------------------------
library("jsonlite")

toJSON(hc$x$hc_opts, pretty = TRUE, auto_unbox = TRUE)

