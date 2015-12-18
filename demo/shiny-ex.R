library("shiny")
library("highcharter")
library("magrittr")
rm(list = ls())
data(citytemp)


ui = shinyUI(
  fluidPage(
    tags$link(rel = "stylesheet", type = "text/css", href = "https://bootswatch.com/paper/bootstrap.css"),
    fluidRow(
      column(width = 3, class = "panel",
             selectInput("type", label = "Type", choices = c("line", "column", "bar", "spline")),
             selectInput("stacked", label = "Stacked", choices = c(FALSE, "normal", "percent")),
             selectInput("ena", label = "3d enabled", choices = c(FALSE, TRUE)),
             sliderInput("alpha", "Alpha Angle", min = 0, max = 45, value = 15),
             sliderInput("beta", "Beta Angle", min = 0, max = 45, value = 15)
      ),
      column(width = 9,
             highchartOutput("hcontainer", width = "80%", height = "600px")
             )
      )
    )
  ) 
  

server = function(input, output) {
  
  output$hcontainer <- renderHighchart({
    
    hc <- highchart() %>% 
      hc_chart(type = input$type) %>%
      hc_xAxis(categories = citytemp$month) %>% 
      hc_add_serie(name = "Tokyo", data = citytemp$tokyo) %>% 
      hc_add_serie(name = "London", data = citytemp$london) %>% 
      hc_add_serie(name = "New York", data = abs(citytemp$new_york))
      
    if(input$ena) hc <- hc %>% hc_chart(options3d = list(enabled = TRUE, beta = input$beta, alpha = input$alpha))
    
    if(input$stacked != FALSE) hc <- hc %>% hc_plotOptions(series = list(stacking = input$stacked))
      
    hc
    
  })
  
}

shinyApp(ui = ui, server = server)
