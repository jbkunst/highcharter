get_demos <- function(){
  library("highcharter")
  library("forecast")
  data("citytemp")
  
  p1 <- highchart() %>% 
    hc_add_serie_scatter(mtcars$wt, mtcars$mpg,
                         mtcars$drat, mtcars$hp) %>% 
    hc_add_theme(hc_theme_smpl())
  
  p2 <- hchart(forecast(auto.arima(AirPassengers), level = 99.9),
               showInLegend = FALSE) %>% 
    hc_tooltip(valueDecimals = 2) %>% 
    hc_add_theme(hc_theme_538())
  
#   x <- getSymbols("USD/EUR", src = "oanda", auto.assign = FALSE)
#   p3 <- hchart(x, name = "USD/EUR") %>%
#     hc_navigator(enabled = FALSE) %>% 
#     hc_add_theme(hc_theme_economist())
  
  p3 <- highchart() %>% 
    hc_xAxis(categories = citytemp$month) %>% 
    hc_add_series(name = "Tokyo", data = citytemp$tokyo, showInLegend = FALSE) %>% 
    hc_add_series(name = "London", data = citytemp$london, showInLegend = FALSE) %>% 
    hc_add_series(name = "Berlin", data = citytemp$berlin, showInLegend = FALSE) %>% 
    hc_add_theme(hc_theme_economist())
  
  
  data(worldgeojson)
  data(GNI2014, package = "treemap")
  head(GNI2014)
  library("viridisLite")
  
  dshmstops <- data.frame(q = c(0, exp(1:5)/exp(5)), c = substring(viridis(5 + 1), 0, 7)) %>% 
    list.parse2()
  
  p4 <- highchart() %>% 
    hc_add_series_map(worldgeojson, GNI2014, name = "",
                      value = "GNI", joinBy = "iso3") %>% 
    hc_colorAxis(stops = dshmstops) %>% 
    hc_legend(enabled = FALSE) %>% 
    hc_add_theme(hc_theme_db()) %>% 
    hc_mapNavigation(enabled = FALSE)
  
    
  H <- 250
  p1$height <- H
  p2$height <- H
  p3$height <- H
  p4$height <- H
  
  demos <- htmltools::tagList(
    tags$div(
      class = "row",
      tags$div(class = "col-sm-6", p1),
      tags$div(class = "col-sm-6", p2)
    ),
    tags$div(
      class = "row",
      tags$div(class = "col-sm-6", p3),
      tags$div(class = "col-sm-6", p4)
    )
  )
  
  # browsable(demos)
  demos  
  
  
}
