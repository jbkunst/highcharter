#' ---
#' title: "highcharter: Just another Highcharts wrapper for R"
#' author: Joshua Kunst
#' date: false
#' output:
#'   html_document:
#'     theme: journal
#'     toc: yes
#' ---

#' <!-- index.html is generated from ibdex.R -->
#+ echo=FALSE
## Styles page ####
#' <script>
#'   jQuery(document).ready(function() {
#'     
#'     var offset = 220;
#'     var duration = 500;
#'     
#'     jQuery(window).scroll(function() {
#'       if (jQuery(this).scrollTop() > offset) {
#'         jQuery('.back-to-top').fadeIn(duration);
#'       } else {
#'         jQuery('.back-to-top').fadeOut(duration);
#'       }
#'     });
#'     
#'     jQuery('.back-to-top').click(function(event) {
#'       event.preventDefault();
#'       jQuery('html, body').animate({scrollTop: 0}, duration);
#'       return false;
#'     })
#'     
#'   });
#' </script>
#' <script>
#' (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
#' (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
#' m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
#' })(window,document,'script','//www.google-analytics.com/analytics.js','ga');
#' 
#' ga('create', 'UA-17670833-9', 'auto');
#' ga('send', 'pageview');
#' </script>
#' <style>
#'     h1, h2, h3, h4, .TOC > li {
#'       color: #1FA67A;
#'     } 
#'   
#'   a {
#'     color: #1FA67A;
#'   }
#'   
#'   .level2 {
#'     padding-top: 20px;
#'   }
#'   
#'   
#'   .back-to-top {
#'     position: fixed;
#'     bottom: 2em;
#'     right: 0px;
#'     text-decoration: none;
#'     color : white;
#'     background-color : #1FA67A;
#'     font-size: 12px;
#'     padding: 1em;
#'     display: none;
#'   }
#'   
#'   .back-to-top:hover {
#'     color : white;
#'   }
#'   
#'   .html-widget-static-bound {
#'     margin-left: auto;
#'     margin-right: auto;
#'   }
#'   
#'   .main-container {
#'     max-width: 850px;
#'     margin-left: auto;
#'     margin-right: auto;
#'   }
#'   
#'   .table {
#'      width: auto;
#'      margin-left:auto; 
#'      margin-right:auto;
#'   }
#'   
#' </style>
#' <a href="#" class="back-to-top">Back to Top</a>
#' <a href="https://github.com/jbkunst/highcharter" class="github-corner"><svg width="80" height="80" viewBox="0 0 250 250" style="fill:#151513; color:#fff; position: absolute; top: 0; border: 0; right: 0;"><path d="M0,0 L115,115 L130,115 L142,142 L250,250 L250,0 Z"></path><path d="M128.3,109.0 C113.8,99.7 119.0,89.6 119.0,89.6 C122.0,82.7 120.5,78.6 120.5,78.6 C119.2,72.0 123.4,76.3 123.4,76.3 C127.3,80.9 125.5,87.3 125.5,87.3 C122.9,97.6 130.6,101.9 134.4,103.2" fill="currentColor" style="transform-origin: 130px 106px;" class="octo-arm"></path><path d="M115.0,115.0 C114.9,115.1 118.7,116.5 119.8,115.4 L133.7,101.6 C136.9,99.2 139.9,98.4 142.2,98.6 C133.8,88.0 127.5,74.4 143.8,58.0 C148.5,53.4 154.0,51.2 159.7,51.0 C160.3,49.4 163.2,43.6 171.4,40.1 C171.4,40.1 176.1,42.5 178.8,56.2 C183.1,58.6 187.2,61.8 190.9,65.4 C194.5,69.0 197.7,73.2 200.1,77.6 C213.8,80.2 216.3,84.9 216.3,84.9 C212.7,93.1 206.9,96.0 205.4,96.6 C205.1,102.4 203.0,107.8 198.3,112.5 C181.9,128.9 168.3,122.5 157.7,114.1 C157.9,116.9 156.7,120.9 152.7,124.9 L141.0,136.5 C139.8,137.7 141.6,141.9 141.8,141.8 Z" fill="currentColor" class="octo-body"></path></svg></a><style>.github-corner:hover .octo-arm{animation:octocat-wave 560ms ease-in-out}@keyframes octocat-wave{0%,100%{transform:rotate(0)}20%,60%{transform:rotate(-25deg)}40%,80%{transform:rotate(10deg)}}@media (max-width:500px){.github-corner:hover .octo-arm{animation:none}.github-corner .octo-arm{animation:octocat-wave 560ms ease-in-out}}</style>
#' [![travis-status](https://api.travis-ci.org/jbkunst/highcharter.svg)](https://travis-ci.org/jbkunst/highcharter)
#' [![codecov.io](https://codecov.io/github/jbkunst/highcharter/coverage.svg?branch=master)](https://codecov.io/github/jbkunst/highcharter?branch=master)
#' [![version](http://www.r-pkg.org/badges/version/highcharter)](http://www.r-pkg.org/pkg/highcharter)
#' [![downloads](http://cranlogs.r-pkg.org/badges/highcharter)](http://www.r-pkg.org/pkg/highcharter)

#+ echo=FALSE
options(digits = 3, knitr.table.format = "markdown")
library("printr")
knitr::opts_chunk$set(collapse = TRUE, warning = FALSE)

##' # Introduction ####
#' 
#' This is just another wrapper for [highcharts](www.higcharts.com) javascript library for R. 
#' The mainly motivation to this packages is get a the all the power from HCs API *with no 
#' restrictions* and write the plots using the pipe operator just like 
#' [metricsgraphics](https://github.com/hrbrmstr/metricsgraphics) and 
#' [dygraphs](http://rstudio.github.io/dygraphs/).
#' 
#' Highcharts is very mature javascript charting library and it has a great and powerful API
#' to get a very style of charts and highly customized (see http://www.highcharts.com/demo).
#' 
#' In the package there's some partial implementation of the HC API in R like `hc_title`, 
#' `hc_add_serie`, `hc_xAxis`, and some shorcuts to made simples chart in R like 
#' `hc_add_serie_scatter`, `hc_add_serie_scatter` by if you want 
#' you can create your chart manually with all the requiriments what you need. That's the
#' package offer.
#' 
#' ## Why another?
#' 
#' - The main reasons is have a wrapper to chart data using piping style.
#' - Include other HC funcionalities like *themes* and *options*.
#' - Generate shortcuts to plots some R objects like *time series* or *treemaps*.
#' 
#' ## Next steps
#' 
#' - Add highmaps and highstocks funcionalities.
#' - Add more functions to plot most used R objects.
#' 

##' # Installation ####
#' 
#' You can install the package with the usual `install.packages("highcarter")`
#' or if you want to try new features before the updates: via devtools 
#' `devtools::install_github("jbkunst/highcharter")`.
#' 

##' # Quick Demo ####
#' Let's start doing a simple column chart:
#' 
library("highcharter")
library("magrittr")

hc <- highchart() %>% 
  hc_title(text = "A nice chart") %>% 
  hc_add_serie(data = c(7.0, 6.9, 9.5, 14.5, 18.2, 21.5, 25.2,
                        26.5, 23.3, 18.3, 13.9, 9.6))

hc

#' If you are not familiar with the magrittr pipe operator (%>%),
#' here is the equivalent without using pipes:

hc <- highchart()
hc <- hc_title(hc, text = "A nice chart")
hc <- hc_add_serie(hc, data = c(7.0, 6.9, 9.5, 14.5, 18.2, 21.5, 25.2, 
                                26.5, 23.3, 18.3, 13.9, 9.6))

hc

#' With the implemented API you can modify the previous chart in a easy way. Let's do some
#' changes:
#' 
#' - Edit style the title.
#' - Add a subtitle with some style.
#' - Add xAxis categories
#' - Add another data (in HC this is call a serie) with some customizations.
#' - Put a shared tooltip.
#' - Put some bands inspired in http://www.highcharts.com/demo/spline-plot-bands.

hc <- hc %>% 
  hc_title(style = list(color = "red")) %>% 
  hc_subtitle(text = "I want to add a subtitle too with style",
              style = list(color = "#B71C1C", fontWeight = "bold")) %>% 
  hc_xAxis(categories = c("Jan", "Feb", "Mar", "Apr", "May", "Jun",
                          "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")) %>% 
  hc_add_serie(name = "A another data", type = "column", color = "#1FA67A",
               dataLabels = list(align = "center", enabled = TRUE),
               data = c(3.9, 4.2, 5.7, 8.5, 11.9, 15.2,
                        17.0, 16.6, 14.2, 10.3, 6.6, 4.8)) %>% 
  hc_tooltip(crosshairs = TRUE, shared = TRUE) %>% 
  hc_yAxis(minorGridLineWidth = 0, gridLineWidth = 0,
           plotBands = list(
             list(from = 20, to = 30, color = "rgba(68, 170, 213, 0.1)",
                  label = list(text = "A band from 20 to 30")),
             list(from = 10, to = 20, color = "rgba(0, 0, 0, 0.1)",
                  label = list(text = "Another band"))
             ))

hc

#' Easy right? Well, it's just the Highcharts API. Thanks to the http://www.highcharts.com/ team.
#' 

##' # The higcharts API (and this wrapper) ####
#' 
#' *Premise*: There's not default arguments. All arguments need to be named.
#' 
#' Let's use a simple plot to show how do with the differentes funcions from the package.
#' 
data(citytemp)

citytemp

hc <- highchart() %>% 
  hc_xAxis(categories = citytemp$month) %>% 
  hc_add_serie(name = "Tokyo", data = citytemp$tokyo) %>% 
  hc_add_serie(name = "London", data = citytemp$london) %>% 
  hc_add_serie(name = "Other city",
               data = (citytemp$tokyo + citytemp$london)/2)

hc

##' ## hc_chart ####

#' With `hc_chart` you can define general chart options.

hc %>% 
  hc_chart(borderColor = '#EBBA95',
           borderRadius = 10,
           borderWidth = 2,
           backgroundColor = list(
             linearGradient = c(0, 0, 500, 500),
             stops = list(
               list(0, 'rgb(255, 255, 255)'),
               list(1, 'rgb(200, 200, 255)')
             )))

#' Now change type to colum and add 3d effect.

hc <- hc %>% 
  hc_chart(type = "column",
           options3d = list(enabled = TRUE, beta = 15, alpha = 15))

hc

#' Now remove 3deffect and add the original type to work with the next examples.

hc <- hc_chart(hc, type = "line", options3d = list(enabled = FALSE))

##' ## hc_xAxis and hc_yAxis ####

#' This functions allow between other things:
#' 
#' - Modify the gridlines.
#' - Add plotBands or plotLines to remark some information.
#' - Show in the opposite side the axis.
#' 

hc %>% 
  hc_xAxis(title = list(text = "Month in x Axis"),
           opposite = TRUE,
           plotLines = list(
             list(label = list(text = "This is a plotLine"),
                  color = "#FF0000",
                  width = 2,
                  value = 5.5))) %>% 
  hc_yAxis(title = list(text = "Temperature in y Axis"),
           opposite = TRUE,
           minorTickInterval = "auto",
           minorGridLineDashStyle = "LongDashDotDot",
           showFirstLabel = FALSE,
           showLastLabel = FALSE,
           plotBands = list(
             list(from = 25, to = htmlwidgets::JS("Infinity"), color = "rgba(100, 0, 0, 0.1)",
                  label = list(text = "This is a plotBand")))) 

##' ## hc_add_serie and hc_rm_serie ####

hc <- highchart() %>% 
  hc_xAxis(categories = citytemp$month) %>% 
  hc_add_serie(name = "Tokyo", data = citytemp$tokyo) %>% 
  hc_add_serie(name = "New York", data = citytemp$new_york) 

hc 

hc %>% 
  hc_add_serie(name = "London", data = citytemp$london, type = "area") %>% 
  hc_rm_serie(name = "New York")

##' ## hc_title, hc_subtitle, hc_credits and hc_legend, hc_tooltip, hc_exporting ####

#' Functions to modify the chart's main title, subtitle, credits, legend and tooltip.

hc %>% 
  hc_title(text = "This is a title with <i>margin</i> and <b>Strong or bold text</b>",
           margin = 20, align = "left",
           style = list(color = "#90ed7d", useHTML = TRUE)) %>% 
  hc_subtitle(text = "And this is a subtitle with more information",
              align = "left",
              style = list(color = "#2b908f", fontWeight = "bold")) %>% 
  hc_credits(enabled = TRUE, # add credits
             text = "www.lonk.tomy.site",
             href = "http://jkunst.com") %>% 
  hc_legend(align = "left", verticalAlign = "top",
            layout = "vertical", x = 0, y = 100) %>%
  hc_tooltip(crosshairs = TRUE, backgroundColor = "#FCFFC5",
             shared = TRUE, borderWidth = 5) %>% 
  hc_exporting(enabled = TRUE) # enable exporting option

##' # Shorcuts for add Data (data series) ####

##' ## Scatter ####

highchart() %>% 
  hc_title(text = "Simple scatter chart") %>% 
  hc_add_serie_scatter(mtcars$wt, mtcars$mpg)

highchart() %>% 
  hc_title(text = "Scatter chart with color") %>% 
  hc_add_serie_scatter(mtcars$wt, mtcars$mpg,
                       color = mtcars$hp)

highchart() %>% 
  hc_title(text = "Scatter chart with size") %>% 
  hc_add_serie_scatter(mtcars$wt, mtcars$mpg,
                       mtcars$drat)

highchart() %>% 
  hc_title(text = "Scatter chart with size and color") %>% 
  hc_add_serie_scatter(mtcars$wt, mtcars$mpg,
                       mtcars$drat, mtcars$hp)

highchart(height = 500) %>% 
  hc_title(text = "A complete example for Scatter") %>% 
  hc_add_serie_scatter(mtcars$wt, mtcars$mpg,
                       mtcars$drat, mtcars$hp,
                       rownames(mtcars),
                       dataLabels = list(
                         enabled = TRUE,
                         format = "{point.label}"
                       )) %>% 
  hc_chart(zoomType = "xy") %>% 
  hc_tooltip(useHTML = TRUE,
             headerFormat = "<table>",
             pointFormat = paste("<tr><th colspan=\"1\"><b>{point.label}</b></th></tr>",
                                 "<tr><th>Weight</th><td>{point.x} lb/1000</td></tr>",
                                 "<tr><th>MPG</th><td>{point.y} mpg</td></tr>",
                                 "<tr><th>Drat</th><td>{point.z} </td></tr>",
                                 "<tr><th>HP</th><td>{point.valuecolor} hp</td></tr>"),
             footerFormat = "</table>")

#' Or we can add series one by one.
hc <- highchart()
for (cyl in unique(mtcars$cyl)) {
  hc <- hc %>%
    hc_add_serie_scatter(mtcars$wt[mtcars$cyl == cyl],
                         mtcars$mpg[mtcars$cyl == cyl],
                         name = sprintf("Cyl %s", cyl),
                         showInLegend = TRUE)
}

hc

##' ## Time Series ####

data(economics, package = "ggplot2")

highchart() %>% 
  hc_add_serie_ts(economics$psavert, economics$date,
                  name = "Personal Savings Rate")

#' There's a `hc_add_serie_ts2` which recieve a `ts`object.

highchart() %>% 
  hc_add_serie_ts2(AirPassengers, color = "#26838E")

highchart() %>% 
  hc_title(text = "Monthly Deaths from Lung Diseases in the UK") %>% 
  hc_subtitle(text = "Deaths from bronchitis, emphysema and asthma") %>% 
  hc_add_serie_ts2(fdeaths, name = "Female") %>%
  hc_add_serie_ts2(mdeaths, name = "Male")

##' ## Treemaps ####
#'
#' Here we use the `treemap` package to create a treemap object and then
#' we create the same treemap via highcharts ;).

library("treemap")
library("viridisLite")

data(GNI2010)

tm <- treemap(GNI2010, index = c("continent", "iso3"),
              vSize = "population", vColor = "GNI",
              type = "value", palette = viridis(6))

hc_tm <- highchart(height = 800) %>% 
  hc_add_serie_treemap(tm, allowDrillToNode = TRUE,
                       layoutAlgorithm = "squarified",
                       name = "tmdata") %>% 
  hc_title(text = "Gross National Income World Data") %>% 
  hc_tooltip(pointFormat = "<b>{point.name}</b>:<br>
             Pop: {point.value:,.0f}<br>
             GNI: {point.valuecolor:,.0f}")

hc_tm

hc_tm <- hc_rm_serie(hc_tm, name = "tmdata")

#' Change the type parameter.

tm <- treemap(GNI2010, index = c("continent", "iso3"),
              vSize = "population", vColor = "GNI",
              type = "comp", palette = rev(viridis(6)))

hc_tm %>% 
  hc_add_serie_treemap(tm, allowDrillToNode = TRUE,
                       layoutAlgorithm = "squarified")

##' ## Labels & Values ####

data("favorite_bars")
data("favorite_pies")

highchart() %>% 
  hc_title(text = "This is a bar graph describing my favorite pies
                   including a pie chart describing my favorite bars") %>%
  hc_subtitle(text = "In percentage of tastiness and awesomeness") %>% 
  hc_add_serie_labels_values(favorite_pies$pie, favorite_pies$percent, name = "Pie",
                             colorByPoint = TRUE, type = "column") %>% 
  hc_add_serie_labels_values(favorite_bars$bar, favorite_bars$percent,
                             colors = substr(terrain.colors(5), 0 , 7), type = "pie",
                             name = "Bar", colorByPoint = TRUE, center = c('35%', '10%'),
                             size = 100, dataLabels = list(enabled = FALSE)) %>% 
  hc_yAxis(title = list(text = "percentage of tastiness"),
           labels = list(format = "{value}%"), max = 100) %>% 
  hc_xAxis(categories = favorite_pies$pie) %>% 
  hc_legend(enabled = FALSE) %>% 
  hc_tooltip(pointFormat = "{point.y}%")

##' # Themes ####

hc <- highchart() %>% 
  hc_title(text = "Motor Trend Car Road Tests") %>% 
  hc_subtitle(text = "Source: 1974 Motor Trend US magazine") %>% 
  hc_xAxis(title = list(text = "Weight")) %>% 
  hc_yAxis(title = list(text = "Miles/gallon")) %>% 
  hc_chart(zoomType = "xy") %>% 
  hc_add_serie_scatter(mtcars$wt, mtcars$mpg,
                       mtcars$drat, mtcars$hp,
                       rownames(mtcars),
                       dataLabels = list(
                         enabled = TRUE,
                         format = "{point.label}"
                       )) %>% 
  hc_tooltip(useHTML = TRUE,
             headerFormat = "<table>",
             pointFormat = paste("<tr><th colspan=\"1\"><b>{point.label}</b></th></tr>",
                                 "<tr><th>Weight</th><td>{point.x} lb/1000</td></tr>",
                                 "<tr><th>MPG</th><td>{point.y} mpg</td></tr>",
                                 "<tr><th>Drat</th><td>{point.z} </td></tr>",
                                 "<tr><th>HP</th><td>{point.valuecolor} hp</td></tr>"),
             footerFormat = "</table>")

##' ## Default ####

hc

##' ## Dark Unica ####

hc %>% hc_add_theme(hc_theme_darkunica())

##' ## Grid Light ####

hc %>% hc_add_theme(hc_theme_gridlight())

##' ## Sand Signika ####

hc %>% hc_add_theme(hc_theme_sandsignika())

##' ## Chalk ####
#'
#' Insipired in https://www.amcharts.com/inspiration/chalk/

hc %>% hc_add_theme(hc_theme_chalk())

##' ## Customs ####

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

##' ## Merge Themes ####

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

##' # More Examples ####

##' ## Highcharts home page example ####

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
  #
  hc_tooltip(formatter = htmlwidgets::JS("function(){
                              if('Sunshine' == this.series.name){
                                return  '<b>' + this.point.name + ': </b>' + this.y
                              } else {
                                unts = this.series.name == 'Rainfall' ? 'mm' : '&#176;C';
                                return (this.x + ': ' + this.y + ' ' + unts)
                              }
                            }"),
             useHTML = TRUE) %>% 
  hc_add_serie(name = "Rainfall", type = "column",
               data = rainfall, yAxis = 1) %>% 
  hc_add_serie(name = "Temperature", type = "spline",
               data = temperature) %>% 
  hc_add_serie(name = "Sunshine", type = "pie",
               data = list(list(y = 2020, name = "Sunshine hours",
                                sliced = TRUE, color = col1),
                           list(y = 6740, name = "Non sunshine hours (including night)",
                                color = col2,
                                dataLabels = list(enabled = FALSE))),
               center = c('20%', 45),
               size = 80)

##' ## Heatmap ####

nyears <- 5

df <- expand.grid(seq(12) - 1, seq(nyears) - 1)
df$value <- abs(seq(nrow(df)) + 10 * rnorm(nrow(df))) + 10
df$value <- round(df$value, 2)
ds <- setNames(list.parse2(df), NULL)


hc <- highchart() %>% 
  hc_chart(type = "heatmap") %>% 
  hc_title(text = "Simulated values by years and months") %>% 
  hc_xAxis(categories = month.abb) %>% 
  hc_yAxis(categories = 2016 - nyears + seq(nyears)) %>% 
  hc_add_serie(name = "value", data = ds)

hc_colorAxis(hc, minColor = "#FFFFFF", maxColor = "#434348")

require("viridisLite")

n <- 4
stops <- data.frame(q = 0:n/n,
                    c = substring(viridis(n + 1), 0, 7))
stops <- list.parse2(stops)

hc_colorAxis(hc, stops = stops, max = 75) 

##' ## Treemap ####

data(diamonds, package = "ggplot2")

df <- dplyr::count(diamonds, cut)
df

df <- setNames(df, c("name", "value"))
ds <- setNames(rlist::list.parse(df), NULL)

highchart() %>% 
  hc_title(text = "A simple Treemap") %>% 
  hc_add_serie(data = ds, type = "treemap", colorByPoint = TRUE) 

##' ## Creating a chart from a list of parameters ####

#' Similar input like chordEx1 example in http://yihui.name/recharts/
#' 

##' ### Example 1 ####
hc_opts <- list()
hc_opts$title <- list(text = "This is a title", x = -20)
hc_opts$xAxis <- list(categories = c('Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                                     'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'))
hc_opts$series <- list(list(name = "Tokyo",
                            data = c(7.0, 6.9, 9.5, 14.5, 18.2, 21.5, 25.2, 26.5, 23.3, 18.3, 13.9, 9.6)))

hc_opts$series <- append(hc_opts$series,
                         list(list(name = "New York",
                                   type = "spline",
                                   lineWidth = 5,
                                   data = c(-0.2, 0.8, 5.7, 11.3, 17.0, 22.0, 24.8, 24.1, 20.1, 14.1, 8.6, 2.5),
                                   dataLabels = list(align = "left", enabled = TRUE))))

highchart(hc_opts)

##' ### Example 2 ####

hc_opts <- list()
hc_opts$chart <- list(type = "bar")
hc_opts$title <- list(title = "Stacked bar")
hc_opts$xAxis <- list(categories = c('Apples', 'Oranges', 'Pears', 'Grapes', 'Bananas'))
hc_opts$yAxis <- list(min = 0, title = list(text = 'Total Fruit Consumtion'))
hc_opts$legend <- list(reversed = TRUE)
hc_opts$series <- list(list(name = "John", data = c(5, 3, 4, 7, 2)),
                       list(name = "Jane", data = c(2, 2, 3, 2, 1)),
                       list(name = "Joe", data = c(3, 4, 4, 2, 5)))

highchart(hc_opts, theme = hc_theme_darkunica())
