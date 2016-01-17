

server = function(input, output) {
  
  output$hcontainer <- renderHighchart({
    
    hc <- highchart() %>% 
      hc_chart(type = input$type) %>%
      hc_xAxis(categories = citytemp$month) %>% 
      hc_add_series(name = "Tokyo", data = citytemp$tokyo) %>% 
      hc_add_series(name = "London", data = citytemp$london) %>% 
      hc_add_series(name = "New York", data = abs(citytemp$new_york))
      
    if(input$ena) hc <- hc %>% hc_chart(options3d = list(enabled = TRUE, beta = input$beta, alpha = input$alpha))
    
    if(input$stacked != FALSE) hc <- hc %>% hc_plotOptions(series = list(stacking = input$stacked))
    
    if(input$theme != FALSE) {
      theme <- switch (input$theme,
        darkunica = hc_theme_darkunica(),
        gridlight = hc_theme_gridlight(),
        sandsignika = hc_theme_sandsignika()
      )
      
      hc <- hc %>% hc_add_theme(theme)
      
    }
      
    hc
    
  })
  
}

shinyApp(ui = ui, server = server)
