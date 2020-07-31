library(tidyverse)
library(highcharter)
library(shiny)

column <- purrr::partial(shiny::column, width = 6)

ui <- fluidPage(
  tags$hr(),
  actionButton("reset", "Reset charts", class = "btn-danger"),
  tags$hr(),
  fluidRow(
    column(
      actionButton("addpnts", "Add Series"),
      highchartOutput("hc_nd")
      ),
    column(
      actionButton("mkpreds", "Add Series linkedTo existing one"),
      highchartOutput("hc_ts")
      ),
    column(
      actionButton("loading", "Loading"),
      highchartOutput("hc_ld")
      ),
    column(
      actionButton("remove", "Remove series"),
      highchartOutput("hc_rm")
    ),
    column(
      actionButton("remove_all", "Remove all series"),
      highchartOutput("hc_rm_all")
    ),
    column(
      actionButton("update1", "Update options"),
      actionButton("update2", "Update options 2"),
      highchartOutput("hc_opts")
    ),
    column(
      actionButton("update3", "Update series data"), 
      actionButton("update4", "Update series options"),
      highchartOutput("hc_opts2")
    ),
    column(
      actionButton("addpoint", "Add point"),
      actionButton("addpoint_w_shift", "Add point with shift"),
      actionButton("rmpoint", "Remove point"),
      highchartOutput("hc_addpoint")
    )
  )
)

server <- function(input, output, session){
  
  output$hc_nd <- renderHighchart({ 
    input$reset
    highchart() %>%
      hc_title(text = "Empty chart")
  })
  
  observeEvent(input$addpnts, { 
    highchartProxy("hc_nd") %>%
      hcpxy_add_series(
        data = datasets::iris, 
        "scatter",
        hcaes(x =  Sepal.Length, y = Sepal.Width, group = Species)
      )
  })
  
  output$hc_ts <- renderHighchart({ 
    input$reset
    hchart(AirPassengers, name = "Passengers", id = "data") 
  })
  
  observeEvent(input$mkpreds, { 
    highchartProxy("hc_ts") %>%
      hcpxy_add_series(
        forecast::forecast(AirPassengers), name = "Supermodel",
        showInLegend = FALSE, linkedTo = "data")
  })
  
  output$hc_ld <- renderHighchart({ 
    input$reset
    hchart(cars, "scatter", hcaes(dist, speed))
  })
  
  observeEvent(input$loading, { 
    
    highchartProxy("hc_ld") %>%
      hcpxy_loading(action = "show")
    
    Sys.sleep(2)
    
    highchartProxy("hc_ld") %>%
      hcpxy_loading(action = "hide")
    
  })
  
  output$hc_rm <- renderHighchart({ 
    input$reset
    hchart(ggplot2::mpg %>% count(year, class), "column", hcaes(class, n, group = year), id = c("y1999", "y2008"))
  })
  
  observeEvent(input$remove, { 
    
    highchartProxy("hc_rm") %>%
      hcpxy_remove_series(id = "y1999")
    
  })
  
  output$hc_rm_all <- renderHighchart({ 
    input$reset
    hchart(
      ggplot2::mpg %>% select(displ, cty, cyl), 
      "scatter",
      hcaes(x = displ, y = cty, group = cyl)
      )
  })
  
  observeEvent(input$remove_all, { 
    
    highchartProxy("hc_rm_all") %>%
      hcpxy_remove_series(all = TRUE)
    
  })
  
  output$hc_opts <- renderHighchart({
    input$reset
    highchart() %>% 
      hc_title(text = "The first title") %>% 
      hc_add_series(data = highcharter::citytemp$london, name = "London", type = "column", colorByPoint = TRUE) %>% 
      hc_add_series(data = highcharter::citytemp$tokyo, name = "Tokio", type = "line") %>% 
      hc_xAxis(categories = highcharter::citytemp$month)
    
  })
  
  observeEvent(input$update1, { 
    
    highchartProxy("hc_opts") %>%
      hcpxy_update(
        title = list(text = "A new title"),
        chart = list(inverted = FALSE, polar = FALSE),
        xAxis = list(gridLineWidth =  1),
        yAxis = list(endOnTick = FALSE)
      )
    
  })
  
  observeEvent(input$update2, { 
    
    highchartProxy("hc_opts") %>%
      hcpxy_update(
        title = list(text = "I´m a polar chart"),
        chart = list(inverted = FALSE, polar = TRUE)
      )
    
  })
  
  output$hc_opts2 <- renderHighchart({
    input$reset
    highchart() %>% 
      hc_add_series(data = highcharter::citytemp$london, id = "london", name = "London", type = "line", colorByPoint = TRUE) %>% 
      hc_xAxis(categories = highcharter::citytemp$month)
    
  })
  
  observeEvent(input$update3, { 
    
    highchartProxy("hc_opts2") %>%
      hcpxy_update_series(
        id = "london",
        data = round(highcharter::citytemp$london + rnorm(12), 1)
      )
    
  })
  
  observeEvent(input$update4, { 
    
    highchartProxy("hc_opts2") %>%
      hcpxy_update_series(
        id = "london",
        type = sample(c('line', 'column', 'spline', 'area', 'areaspline', 'scatter', 'lollipop', 'bubble'), 1),
        name = str_c("London ", sample(1:10, 1)),
        dataLabels = list(enabled = sample(c(TRUE, FALSE), 1))
      )
    
  })
  
  output$hc_addpoint <- renderHighchart({
    input$reset
    
    df <- tibble::tibble(
      x = datetime_to_timestamp(Sys.time() - lubridate::seconds(10:1)),
      y = rnorm(length(x))
    )
    
    highchart() %>% 
      hc_xAxis(type = "datetime") %>% 
      hc_add_series(df, "line", hcaes(x, y), id = "ts", name = "A real time value") %>% 
      hc_navigator(enabled = TRUE)
    
  })
  
  observeEvent(input$addpoint, { 
    
    highchartProxy("hc_addpoint") %>%
      hcpxy_add_point(
        id = "ts",
        point = list(x = datetime_to_timestamp(Sys.time()), y = rnorm(1))
      )
    
  })
  
  observeEvent(input$addpoint_w_shift, { 
    
    highchartProxy("hc_addpoint") %>%
      hcpxy_add_point(
        id = "ts",
        point = list(x = datetime_to_timestamp(Sys.time()), y = rnorm(1)),
        shift = TRUE
        )
    
  })
  
  observeEvent(input$rmpoint, { 
    
    highchartProxy("hc_addpoint") %>%
      hcpxy_remove_point(
        id = "ts",
        i = 0
        )
    
  })
  
  
  
}

if(interactive()) shiny::shinyApp(ui, server, options = list(launch.browser = .rs.invokeShinyPaneViewer))


shiny::shinyApp(ui, server)
