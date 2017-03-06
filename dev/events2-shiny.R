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
    column(6, h3("Point Event"), highchartOutput("hc_1")),
    column(3, h3("MouseOver"), verbatimTextOutput("hc_1_input1")),
    column(3, h3("Click"), verbatimTextOutput("hc_1_input2"))
    ),
  fluidRow(
    column(6, h3("Series Event"), highchartOutput("hc_2")),
    column(3, h3("MouseOver"), verbatimTextOutput("hc_2_input1")),
    column(3, h3("Click"), verbatimTextOutput("hc_2_input2"))
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
      hc_add_event_point(event = "mouseOver") %>% 
      hc_add_event_point(event = "click")
    hc
    
  })
  
  output$hc_1_input1 <- renderPrint({ input$hc_1_mouseOver })
  output$hc_1_input2 <- renderPrint({ input$hc_1_click })
  
  output$hc_2 <- renderHighchart({
    
    hc <- hc_base %>% 
      hc_plotOptions(
        series = list(
          cursor = "pointer"
          )
        ) %>%
      hc_add_event_series(event = "mouseOver") %>% 
      hc_add_event_series(event = "click")
    
    hc
    
  })
  
  output$hc_2_input1 <- renderPrint({ input$hc_2_mouseOver })
  output$hc_2_input2 <- renderPrint({ input$hc_2_click })
  
  
}

shinyApp(ui = ui, server = server)


