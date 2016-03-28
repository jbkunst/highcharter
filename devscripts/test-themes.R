rm(list = ls())

hc <- highchart(debug = TRUE) %>% 
  hc_add_series_scatter(mtcars$wt, mtcars$mpg, mtcars$cyl, mtcars$cyl) %>% 
  hc_chart(zoomType = "xy") %>% 
  hc_title(text = "Motor Trend Car Road Tests") %>% 
  hc_subtitle(text = "Motor Trend Car Road Tests") %>% 
  hc_xAxis(title = list(text = "Weight")) %>% 
  hc_yAxis(title = list(text = "Miles/gallon")) %>% 
  hc_tooltip(headerFormat = "<b>{series.name} cylinders</b><br>",
             pointFormat = "{point.x} (lb/1000), {point.y} (miles/gallon)")

hc

# hc <- hc_demo()

##' ## Dark Unica ####

hc %>% hc_add_theme(hc_theme_darkunica())

##' ## Grid Light ####

hc %>% hc_add_theme(hc_theme_gridlight())

##' ## Sand Signika ####

hc %>% hc_add_theme(hc_theme_sandsignika())

##' ## Fivethirtyeight ####

hc %>% hc_add_theme(hc_theme_538())

##' ## Economist ####

hc %>% hc_add_theme(hc_theme_economist())

##' ## Chalk ####
#'
#' Insipired in https://www.amcharts.com/inspiration/chalk/.

hc %>% hc_add_theme(hc_theme_chalk())

##' ## Hand Drawn ####
#'
#' Insipired in https://www.amcharts.com/inspiration/hand-drawn/ (again!).

hc %>% hc_add_theme(hc_theme_handdrawn())

##' ## Null ####

hc %>% hc_add_theme(hc_theme_null())

thm <- hc_theme(
  colors = c('red', 'green', 'blue'),
  chart = list(
    backgroundColor = NULL,
    divBackgroundImage = "http://media3.giphy.com/media/FzxkWdiYp5YFW/giphy.gif"
  ),
  title = list(
    style = list(
      color = '#333333',
      fontFamily = "Erica One"
    )
  ),
  subtitle = list(
    style = list(
      color = '#666666',
      fontFamily = "Shadows Into Light"
    )
  ),
  legend = list(
    itemStyle = list(
      fontFamily = 'Tangerine',
      color = 'black'
    ),
    itemHoverStyle = list(
      color = 'gray'
    )   
  )
)

hc %>% hc_add_theme(thm)


thm <- hc_theme_merge(
  hc_theme_darkunica(),
  hc_theme(
    chart = list(
      backgroundColor = "transparent",
      divBackgroundImage = "http://cdn.wall-pix.net/albums/art-3Dview/00025095.jpg"
      ),
    title = list(
      style = list(
        color = 'white',
        fontFamily = "Erica One"
        )
      )
    )
  )

hc %>% hc_add_theme(thm)

