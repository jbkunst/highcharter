rm(list = ls())
library(shiny)
library(highcharter)
library(tidyverse)

hc_add_series_event <- function(hc, series = "series", event = "click", inputanme = NULL){
  
  fun <- "function(){
  var seriesinfo = {name: this.name }
  console.log(seriesinfo);
  window.x = this;
  if (typeof Shiny != 'undefined') { Shiny.onInputChange(this.chart.renderTo.id, seriesinfo); }
  
}"
  fun <- JS(fun)
  
  eventobj <- structure(
    list(structure(
      list(structure(
        list(fun),
        .Names = event)
      ),
      .Names = "events")
    ),
    .Names = series
  )
  
  hc$x$hc_opts$plotOptions <- rlist::list.merge(
    hc$x$hc_opts$plotOptions,
    eventobj
  )
  
  hc
  
  }

hc_add_point_event <- function(hc, series = "series", event = "click", inputanme = NULL){
  
  fun <- "function(){
  var pointinfo = {series: this.series.name, seriesid: this.series.id,
  name: this.point.name, x: this.x, y: this.y, category: this.category.name }
  window.x = this;
  console.log(pointinfo);
  
  if (typeof Shiny != 'undefined') { Shiny.onInputChange(this.series.chart.renderTo.id, pointinfo); } 
}"
  
  fun <- JS(fun)
  
  eventobj <- structure(
    list(structure(
      list(structure(
        list(structure(
          list(fun),
          .Names = event)
        ),
        .Names = "events")
      ),
      .Names = "point")
    ),
    .Names = series
  )
  
  hc$x$hc_opts$plotOptions <- rlist::list.merge(
    hc$x$hc_opts$plotOptions,
    eventobj
  )
  
  hc
  
  }

hc <- highcharts_demo() 


data("mpg", package = "ggplot2")
hc_base <- hchart(mpg, "scatter", hcaes(x = cty, y = displ, group = class))


ui <- fluidPage(
  h2("Highcharter as Shiny Inputs"),
  fluidRow(
    column(6, highchartOutput("hc_1")),
    column(6, verbatimTextOutput("hc_1_input"))
    ),
  fluidRow(
    column(6, highchartOutput("hc_2")),
    column(6, verbatimTextOutput("hc_2_input"))
    )
  )

server = function(input, output) {
  
  output$hc_1 <- renderHighchart({

    hc <- hc_base %>% 
      hc_plotOptions(
        series = list(
          cursor = "pointer"
        )
      ) %>% 
      hc_add_point_event(event = "mouseOver")
    
    hc
    
  })
  
  output$hc_1_input <- renderPrint({ input$hc_1 })
  
  output$hc_2 <- renderHighchart({
    
    hc <- hc_base %>% 
      hc_plotOptions(
        series = list(
          cursor = "pointer"
          )
        ) %>%
      hc_add_series_event(event = "click")
    
    hc
    
  })
  
  output$hc_2_input <- renderPrint({ input$hc_2 })
  
  
}

shinyApp(ui = ui, server = server)


