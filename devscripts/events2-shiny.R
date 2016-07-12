rm(list = ls())
library("shiny")
library("highcharter")
library("purrr")

ui <- fluidPage(
  theme = shinytheme("flatly"),
  h2("Highcharter as Shiny Inputs"),
  tabsetPanel(
    tabPanel("Draggable",
             fluidRow(
               column(width = 6, highchartOutput("hcontainer")),
               column(width = 6, verbatimTextOutput("hcinputout"))
               )
             ),
    tabPanel("Scatter",
             fluidRow(
               column(width = 6, highchartOutput("hcontainer2")),
               column(width = 6, verbatimTextOutput("hcinputout2"))
               )
             )
    )
  )

server = function(input, output) {
  
  output$hcontainer <- renderHighchart({
    fn <- "function(){
       console.log('Category: ' + this.category + ', value: ' + this.y + ', series: ' + this.series.name);
       ds = this.series.data.map(function(e){ return {x: e.x, y: e.y  }  }); 
       Shiny.onInputChange('hcinput', {category: this.category, name: this.series.name, data: ds, type: this.series.type})
       }"

    hc <- highchart() %>%
      hc_add_series(data = c(3.9,  4.2, 5.7, 8.5), type = "column",
                    name = "draggable", draggableY = TRUE, dragMinY = 0) %>% 
      hc_add_series(data = 2*c(7, 6.9,  9.5, 14), type = "scatter",
                    name = "draggable too!", draggableX = TRUE, draggableY = TRUE) %>%
      hc_add_series(data = 3*c(2,  0.6, 3.5, 8), type  = "spline") %>% 
      hc_plotOptions(
        series = list(
          cursor = "pointer",
          point = list(
            events = list(
              click = JS(fn),
              drop = JS(fn)
            )
          )
        )
      ) 
    
    hc
    
  })
  
  output$hcinputout <- renderPrint({
    
    inputaux <- input$hcinput
    
    if (!is.null(inputaux))
      inputaux$data <- map_df(inputaux$data, as_data_frame)
    
    inputaux
    
  })
  
  output$hcontainer2 <- renderHighchart({
    
    ds <- mtcars %>% 
      mutate(x = mpg, y = wt, name = rownames(.)) %>% 
      list_parse()
    
    nms <- names(ds[[1]])
    obj <- paste("{", paste0(nms, ": this.", nms, collapse = ", "), "}")
    
    fn <- "function() {
                console.log(this);                
                console.log(typeof(this)); 
                Shiny.onInputChange('hcinput2',  %s)
            }" %>% sprintf(obj)
    
    # highchart() %>%
    #   hc_add_series(data = ds, type = "scatter") %>%
    #   hc_plotOptions(
    #     series = list(
    #       cursor = "pointer",
    #       point = list(
    #         events = list(
    #           click = JS(fn)
    #         )
    #       )
    #     )
    #   )
    
    highchart() %>%
      hc_add_series(data = ds, type = "scatter") %>%
      hc_plotOptions(
        series = list(
          cursor = "pointer",
          point = list(
            events = list(
              click = JS(fn)
            )
          )
        )
      )
  })
  
  output$hcinputout2 <- renderPrint({
    
    inputaux <- input$hcinput2
    
    if (!is.null(inputaux))
      inputaux <- as_data_frame(inputaux) %>% tidyr::gather(key, values)
    
    inputaux
    
  })
  
  
}

shinyApp(ui = ui, server = server, options = list(launch.browser = FALSE))
