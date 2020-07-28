library(tidyverse)
library(highcharter)

iris <- iris %>% group_by(Species) %>% sample_n(5)

options(highcharter.debug = TRUE)
options(highcharter.verbose = TRUE)

highchartProxy("hola") %>% 
  hcpxy_add_series(data = 1:10, name = "name", type = "area")

highchartProxy("hola") %>% 
  hcpxy_add_series(data = ts(1:3))

highchartProxy("hola") %>% 
  hcpxy_add_series(data = iris, "scatter", hcaes(x =  Sepal.Length, y = Sepal.Width))

highchartProxy("hola") %>% 
  hcpxy_add_series(data = iris, "scatter", hcaes(x =  Sepal.Length, y = Sepal.Width, group = Species))


# shiny examples ----------------------------------------------------------
library(shiny)

# iris <- iris %>% group_by(Species) %>% sample_n(5)

ui <- fluidPage(
  tags$hr(),
  fluidRow(
    column(6, actionButton("mkpreds", "Make predictions"),  highchartOutput("hc_ts")),
    column(6, actionButton("addpnts", "Add points")      ,  highchartOutput("hc_nd"))
  )
)

server <- function(input, output, session){
  
  output$hc_ts <- renderHighchart({ hchart(AirPassengers, name = "Passengers") })
  
  observeEvent(input$mkpreds, { 
    highchartProxy("hc_ts") %>% hcpxy_add_series(forecast::forecast(AirPassengers), name = "Supermodel")
  })
  
  output$hc_nd <- renderHighchart({ highchart() %>% hc_title(text = "No data") })
  
  observeEvent(input$addpnts, { 
    highchartProxy("hc_nd") %>% hcpxy_add_series(data = sample_n(datasets::iris, 10), "scatter", hcaes(x =  Sepal.Length, y = Sepal.Width, group = Species))
  })

 
}

if(interactive()) shiny::shinyApp(ui, server, options = list(launch.browser = .rs.invokeShinyPaneViewer))
