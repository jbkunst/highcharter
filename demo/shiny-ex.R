library("shiny")
library("highcharter")

data(citytemp)

ui <- fluidPage(
    h1("Highcharter Demo"),
    fluidRow(
      column(width = 4, class = "panel",
             selectInput("type", label = "Type", width = "100%",
                         choices = c("line", "column", "bar", "spline")), 
             selectInput("stacked", label = "Stacked",  width = "100%",
                         choices = c(FALSE, "normal", "percent")),
             selectInput("theme", label = "Theme",  width = "100%",
                         choices = c(FALSE, "fivethirtyeight", "economist",  "darkunica", "gridlight",
                                     "sandsignika", "null", "handdrwran", "chalk")
                           )
      ),
      column(width = 8,
             highchartOutput("hcontainer",height = "500px")
      )
    )
  )

server = function(input, output) {
  
  output$hcontainer <- renderHighchart({
    
    hc <- highcharts_demo() %>%
      hc_rm_series("Berlin") %>% 
      hc_chart(type = input$type)
      
    if (input$stacked != FALSE) hc <- hc %>% hc_plotOptions(series = list(stacking = input$stacked))
    
    if (input$theme != FALSE) {
      theme <- switch(input$theme,
                      null = hc_theme_null(),
                      darkunica = hc_theme_darkunica(),
                      gridlight = hc_theme_gridlight(),
                      sandsignika = hc_theme_sandsignika(),
                      fivethirtyeight = hc_theme_538(),
                      economist = hc_theme_economist(),
                      chalk = hc_theme_chalk(),
                      handdrwran = hc_theme_handdrawn()
      )
      
      hc <- hc %>% hc_add_theme(theme)
      
    }
      
    hc
    
  })
  
}

shinyApp(ui = ui, server = server)
