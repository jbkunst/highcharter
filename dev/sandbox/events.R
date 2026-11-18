library(shiny)
library(highcharter)

if (interactive()) {
  shinyApp(
    ui = fluidPage(
      wellPanel("mouseOver and click points for additional information"),
      uiOutput("click_ui"),
      uiOutput("mouseOver_ui"),
      highchartOutput("plot_hc")
    ),
    server = function(input, output) {
      df <- data.frame(x = 1:5, y = 1:5, otherInfo = letters[11:15])

      output$plot_hc <- renderHighchart({
        highchart() |>
          hc_add_series(df, "scatter") |>
          hc_add_event_point(event = "mouseOver")
      })

      output$click_ui <- renderUI({
        if (is.null(input$plot_hc_point_click)) {
          return()
        }

        wellPanel(
          "Coordinates of clicked point: ",
          input$plot_hc_point_click$x,
          input$plot_hc_point_click$y
        )
      })

      output$mouseOver_ui <- renderUI({
        if (is.null(input$plot_hc_point_mouseOver)) {
          return()
        }

        wellPanel(
          "Coordinates of mouseOvered point: ",
          input$plot_hc_point_mouseOver$x,
          input$plot_hc_point_mouseOver$y
        )
      })
    }
  )
}
