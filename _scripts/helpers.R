get_demos <- function(){
  library("highcharter")
  library("forecast")
  
  p1 <- highchart() %>% 
    hc_yAxis(title = list(text = NULL)) %>% 
    hc_add_serie_scatter(mtcars$wt, mtcars$mpg,
                         mtcars$drat, mtcars$hp)
  
  p2 <- hchart(forecast(auto.arima(AirPassengers), level = 99.9),
               showInLegend = FALSE) %>% 
    hc_yAxis(title = list(text = NULL)) %>% 
    hc_tooltip(valueDecimals = 2) %>% 
    hc_add_theme(hc_theme_538())
  
  x <- getSymbols("USD/EUR", src = "oanda", auto.assign = FALSE)
  p3 <- hchart(x, name = "USD/EUR") %>%
    hc_navigator(enabled = FALSE) %>% 
    hc_add_theme(hc_theme_economist())
  
  
  data(worldgeojson)
  data(GNI2010, package = "treemap")
  head(GNI2010)
  
  n <- 10
  cols <- c("yellow", "black")
  
  stops <- data.frame(q = 0:n/n, c = colorRampPalette(cols)(n + 1))
  stops <- list.parse2(stops)
  
  p4 <- highchart() %>% 
    hc_add_series_map(worldgeojson, GNI2010,
                      value = "GNI", joinBy = "iso3") %>% 
    hc_legend(enabled = FALSE) %>% 
    hc_colorAxis(stops = stops) %>% 
    hc_add_theme(hc_theme_darkunica()) %>% 
    hc_mapNavigation(enabled = TRUE)
    
  H <- 250
  p1$height <- H
  p2$height <- H
  p3$height <- H
  p4$height <- H
  
  demos <- tagList(
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
