#' ---
#' layout: post
#' toc: true
#' ---
#+echo=FALSE
rm(list = ls())
library("highcharter")

#'
#' ## Highcharts Examples
#' 
#' <div id ="toc"></div>
#' 
#' ### Highcharts home page demo
#'
#' Example in http://www.highcharts.com/

rainfall <- c(49.9, 71.5, 106.4, 129.2, 144, 176,
              135.6, 148.5, 216.4, 194.1, 95.6, 54.4)

temperature <- c(7, 6.9, 9.5, 14.5, 18.2, 21.5,
                 25.2, 26.5, 23.3, 18.3, 13.9, 9.6)

col1 <- hc_get_colors()[3]
col2 <- hc_get_colors()[2]

highchart() %>% 
  hc_title(text = "Tokyo Climate") %>% 
  hc_legend(enabled = FALSE) %>% 
  hc_xAxis(categories = month.abb) %>% 
  hc_yAxis(
    list(
      title = list(text = "Temperature"),
      align = "left",
      showFirstLabel = FALSE,
      showLastLabel = FALSE,
      labels = list(format = "{value} &#176;C", useHTML = TRUE)
    ),
    list(
      title = list(text = "Rainfall"),
      align = "right",
      showFirstLabel = FALSE,
      showLastLabel = FALSE,
      labels = list(format = "{value} mm"),
      opposite = TRUE
    )
  ) %>% 
  hc_tooltip(formatter = JS("function(){
                             if('Sunshine' == this.series.name){
                             return  '<b>' + this.point.name + ': </b>' + this.y
                             } else {
                             unts = this.series.name == 'Rainfall' ? 'mm' : '&#176;C';
                             return (this.x + ': ' + this.y + ' ' + unts)
                             }}"),
             useHTML = TRUE) %>% 
  hc_add_series(name = "Rainfall", type = "column",
                data = rainfall, yAxis = 1) %>% 
  hc_add_series(name = "Temperature", type = "spline",
                data = temperature) %>% 
  hc_add_series(name = "Sunshine", type = "pie",
                data = list(list(y = 2020, name = "Sunshine hours",
                                 sliced = TRUE, color = col1),
                            list(y = 6740, name = "Non sunshine hours (including night)",
                                 color = col2,
                                 dataLabels = list(enabled = FALSE))),
                center = c('20%', 45),
                size = 80)

#'
#' ### Chart Color Gradient
#'
#' Idea from http://jsfiddle.net/bilelz/sxy1cwnv/
#' 

highchart() %>% 
  hc_chart(backgroundColor = "#") %>% 
  hc_title(text = "Chart color gradient it's on fire", style = list(color = "#CCC")) %>% 
  # hc_xAxis(categories = month.abb) %>% 
  hc_yAxis(labels = list(style = list(color = "#CCC")),
           gridLineColor = "#111111") %>% 
  hc_series(
    list(
      data =  abs(rnorm(100)) + 1,
      type = "areaspline",
      marker = list(enabled = FALSE),
      color =  list(
        linearGradient = list(x1 = 0, y1 = 1, x2 = 0, y2 = 0),
        stops = list(
          list(0, "transparent"),
          list(0.33, "yellow"),
          list(0.66, "red"),
          list(1, "#ccc")
        )
      ),
      fillColor = list(
        linearGradient = list(x1 = 0, y1 = 1, x2 = 0, y2 = 0),
        stops = list(
          list(0, "transparent"),
          list(0.1, "yellow"),
          list(0.5, "red"),
          list(1, "black")
          )
        )
      )
    )

#'
#' ### Creating Annotations
#' 
#' You can use `type = 'scatter'` to add annotations.
#' 

n <- 50
df <- data.frame(x = rnorm(n), y = rnorm(n))
ds <- list.parse2(df)

df2 <- data.frame(x = c(1, -1, -1, 1)*2,
                  y = c(1, 1, -1, -1)*2,
                  text = paste("Quadrant", letters[1:4]))

ds2 <- list.parse3(df2)

highchart() %>% 
  hc_add_theme(hc_theme_538()) %>% 
  hc_add_serie(data = ds, name = "data", type = "scatter") %>% 
  hc_add_serie(data = ds2,
               name = "annotations",
               type = "scatter",
               color = "transparent",
               showInLegend = FALSE,
               enableMouseTracking = FALSE,
               dataLabels = list(enabled = TRUE, y = 10, format = "{point.text}",
                                 style = list(fontSize = "20px",
                                              color =  'rgba(0,0,0,0.70)')))

#'
#' ### A spiderweb chart 
#'
#' Highcharts support a range of different chart types so data 
#' can be displayed in a meaningfull way. Highcharter inherit
#' all this awesome features. Here's is an example how make a 
#' spiderweb chart^[Example proposed by
#' @johnstantongeddes (https://github.com/johnstantongeddes)].
#' 

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
