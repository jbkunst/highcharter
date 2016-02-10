#' ---
#' layout: post
#' ---
#+echo=FALSE
rm(list = ls())
library("highcharter")

##' ## The higcharts API
#' 
#' *Premise*: There's not default arguments. All arguments need to be named.
#' 
#' Let's use a simple plot to show how do with the differentes funcions from the package.
#' 

data(citytemp)

hc <- highchart() %>% 
  hc_xAxis(categories = citytemp$month) %>% 
  hc_add_series(name = "Tokyo", data = citytemp$tokyo) %>% 
  hc_add_series(name = "London", data = citytemp$london) %>% 
  hc_add_series(name = "Other city",
                data = (citytemp$tokyo + citytemp$london)/2)

hc

##' ### hc_chart

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

##' ### hc_xAxis and hc_yAxis

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
             list(from = 25, to = JS("Infinity"), color = "rgba(100, 0, 0, 0.1)",
                  label = list(text = "This is a plotBand")))) 

##' ### hc_add_series and hc_rm_series

hc <- highchart() %>% 
  hc_xAxis(categories = citytemp$month) %>% 
  hc_add_series(name = "Tokyo", data = citytemp$tokyo) %>% 
  hc_add_series(name = "New York", data = citytemp$new_york) 

hc 

hc %>% 
  hc_add_series(name = "London", data = citytemp$london, type = "area") %>% 
  hc_rm_series(name = "New York")

##' ### hc_title, hc_subtitle, hc_credits and hc_legend, hc_tooltip, hc_exporting

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
