#' ---
#' title: "highcharter: Just another Highcharts wrapper for R"
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
#'     max-width: 700px;
#'     margin-left: auto;
#'     margin-right: auto;
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
#' `hc_add_serie`, `hc_xAxis`, and some shorcuts to made simples chart in R by if you want 
#' you can create your chart manually with all the requiriments what you need. That's the
#' package offer.
#' 

##' # Installation ####
#' 
#' You can install the package via devtools: `devtools::install_github("jbkunst/rchess")`.
#' 

##' # Quick Demo ####
#' Let's start doing a simple column chart:
#' 
library("highcharter")
library("magrittr")

hc <- highchart(debug = TRUE) %>% 
  hc_title(text = "A nice chart") %>% 
  hc_chart(type = "column") %>% 
  hc_xAxis(categories = c("Jan", "Feb", "Mar", "Apr", "May", "Jun",
                          "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")) %>% 
  hc_add_serie(data = c(7.0, 6.9, 9.5, 14.5, 18.2, 21.5, 25.2,
                        26.5, 23.3, 18.3, 13.9, 9.6))

hc

#' With the implemented API you can modify the previous chart in a easy way. Let's do some
#' changes:
#' 
#' - Edit style the title.
#' - Add a subtitle with some style.
#' - Add another data (in HC this is call a serie) with some customizations.
#' 
hc <- hc %>% 
  hc_title(style = list(color = "red")) %>% 
  hc_subtitle(text = "I want to add a subtitle too with style",
              style = list(color = "#B71C1C", fontWeight = "bold")) %>% 
  hc_add_serie(name = "A another data", type = "line", color = "#1FA67A",
               dataLabels = list(align = "center", enabled = TRUE),
               data = c(3.9, 4.2, 5.7, 8.5, 11.9, 15.2,
                        17.0, 16.6, 14.2, 10.3, 6.6, 4.8))

hc 

#' And finally:
#' 
#' - Put a shared tooltip ([reference](http://jsfiddle.net/gh/get/jquery/1.7.2/highslide-software/highcharts.com/tree/master/samples/highcharts/tooltip/shared-x-crosshair/)).
#' - Put some bands inspired in http://www.highcharts.com/demo/spline-plot-bands.
#' 

hc <- hc %>% 
  hc_tooltip(crosshairs = TRUE, shared = TRUE) %>% 
  hc_yAxis(minorGridLineWidth = 0, gridLineWidth = 0,
           plotBands = list(
             list(from = 10, to = 20, color = "rgba(68, 170, 213, 0.1)",
                  label = list(text = "A low band")),
             list(from = 20, to = 25, color = "rgba(0, 0, 0, 0.1)",
                  label = list(text = "A medium band")),
             list(from = 25, to = 30, color = "rgba(68, 170, 213, 0.1)",
                  label = list(text = "A high band"))
             ))

hc

#' Easy right? Well, it's just the Highcharts API. Thanks to the HC team.
#' 

##' # Functions to work with HC API ####
#' 
#' *Premise*: There's not default arguments. All arguments need to be named.
#' 
#' Let's use a simple plot to show how do with the differentes funcions from the package.
#' 
data(citytemp)

citytemp

hc <- highchart(debug = TRUE) %>% 
  hc_xAxis(categories = citytemp$month) %>% 
  hc_add_serie(name = "Tokyo", data = citytemp$tokyo) %>% 
  hc_add_serie(name = "London", data = citytemp$london)

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

#' Now remove 3deffect and add the original type

hc <- hc %>%
  hc_chart(type = "line", options3d = list(enabled = FALSE))

hc

##' ## hc_title, hc_tooltip, hc_subtitle, hc_credits and hc_legend ####

#' Options to add the chart's main title and subtitle.

hc %>% 
  hc_title(text = "This is a title with <i>margin</i> at <b>bottom</b>",
           useHTML = TRUE) %>% 
  hc_subtitle(text = "A detailed description",
              align = "right",
              style = list(color = "#2b908f", fontWeight = "bold")) %>% 
  hc_title(margin = 50,
           align = "left",
           style = list(color = "#90ed7d"))

##' ## hc_xAxis and hc_yAxis ####

hc 

##' ## hc_plotOptions ####

hc

##' ## hc_add_serie and hc_rm_serie ####

hc

##' # Shorcuts ####

##' ## Time Series ####

highchart() %>% 
  hc_add_serie_ts(AirPassengers)

highchart() %>% 
  hc_title(text = "Monthly Deaths from Lung Diseases in the UK") %>% 
  hc_subtitle(text = "Deaths from bronchitis, emphysema and asthma") %>% 
  hc_add_serie_ts(fdeaths, name = "Female") %>%
  hc_add_serie_ts(mdeaths, name = "Male")

##' ## Scatter plot ####

highchart() %>% 
  hc_add_serie_scatter(cars$speed, cars$dist)
  
highchart() %>% 
  hc_add_serie_scatter(mtcars$wt, mtcars$mpg, mtcars$cyl) %>% 
  hc_title(text = "Motor Trend Car Road Tests") %>% 
  hc_xAxis(title = list(text = "Weight")) %>% 
  hc_yAxis(title = list(text = "Miles/gallon")) %>% 
  hc_tooltip(headerFormat = "<b>{series.name} cylinders</b><br>",
             pointFormat = "{point.x} (lb/1000), {point.y} (miles/gallon)")

##' ## Labels/Values ####

data(favorite_bars)

favorite_bars

highchart() %>% 
  hc_title(text = "My favorite Bars") %>%
  hc_subtitle(text = "(In percentage of awesomeness)") %>% 
  hc_tooltip(pointFormat = "{point.percentage:.1f}%") %>% 
  hc_add_serie_labels_values(favorite_bars$bar, favorite_bars$percent,
                             colorByPoint = TRUE, type = "pie") %>% 
  hc_legend(enabled = FALSE)

data(favorite_pies)

highchart() %>%
  hc_title(text = "My favorite Pies") %>% 
  hc_subtitle(text = "(In percentage of tastiness)") %>% 
  hc_tooltip(pointFormat = "{point.y:.1f}%") %>% 
  hc_add_serie_labels_values(favorite_pies$pie, favorite_pies$percent,
                             colorByPoint = TRUE, type = "column") %>% 
  hc_xAxis(categories = favorite_pies$pie) %>% 
  hc_legend(enabled = FALSE)

##' ## Drilldown ####

##' # Themes ####

hc <- highchart(debug = TRUE) %>% 
  hc_add_serie_scatter(mtcars$wt, mtcars$mpg, mtcars$cyl) %>% 
  hc_chart(zoomType = "xy") %>% 
  hc_title(text = "Motor Trend Car Road Tests") %>% 
  hc_subtitle(text = "Motor Trend Car Road Tests") %>% 
  hc_xAxis(title = list(text = "Weight")) %>% 
  hc_yAxis(title = list(text = "Miles/gallon")) %>% 
  hc_tooltip(headerFormat = "<b>{series.name} cylinders</b><br>",
             pointFormat = "{point.x} (lb/1000), {point.y} (miles/gallon)")

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
