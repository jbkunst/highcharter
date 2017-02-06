rm(list = ls())
library(shiny)
library(highcharter)
library(tidyverse)

options(highcharter.theme = hc_theme_smpl())

hc <- highcharts_demo() 

hc_base <- hchart(mpg, "scatter", hcaes(x = cty, y = displ, group = class, name = model))


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
      hc_add_event_point(event = "mouseOver")
    
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
      hc_add_event_series(event = "click")
    
    hc
    
  })
  
  output$hc_2_input <- renderPrint({ input$hc_2 })
  
  
}

shinyApp(ui = ui, server = server)


