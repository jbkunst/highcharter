library(shiny)
library(highcharter)

bands <- data.frame(
  band = c("60 Hz", "250 Hz", "1 kHz", "4 kHz", "16 kHz"),
  gain = c(0, 3, -2, 2, 0)
)

ui <- fluidPage(
  h2("Equalizer"),
  p("Click a band to select it. Drag it up or down to adjust its gain."),
  highchartOutput("eq", height = "320px"),
  textOutput("selected"),
  textOutput("adjusted")
)

server <- function(input, output, session) {
  output$eq <- renderHighchart({
    hchart(
      bands,
      "scatter",
      hcaes(x = band, y = gain, id = band),
      name = "Gain",
      cursor = "ns-resize",
      lineWidth = 2,
      marker = list(enabled = TRUE, radius = 8),
      dragDrop = list(
        draggableY = TRUE,
        dragMinY = -12,
        dragMaxY = 12,
        dragPrecisionY = 1
      )
    ) |>
      hc_yAxis(
        min = -12,
        max = 12,
        tickInterval = 3,
        title = list(text = "Gain (dB)")
      ) |>
      hc_tooltip(valueSuffix = " dB") |>
      hc_add_event_point(event = "drop")
  })

  output$selected <- renderText({
    point <- req(input$eq_point_click)
    sprintf("Selected band: %s", point$pointid)
  })
  output$adjusted <- renderText({
    point <- req(input$eq_point_drop)
    sprintf("Last adjustment: %s at %+d dB", point$pointid, point$y)
  })
}

shinyApp(ui, server)
