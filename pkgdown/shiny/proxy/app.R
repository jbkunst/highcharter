library(shiny)
library(highcharter)

ui <- fluidPage(
  theme = bslib::bs_theme(version = 5),
  style = "max-width: 48rem;",
  actionButton("next_month", "Add a month"),
  radioButtons(
    "type",
    "Chart type",
    c("Line" = "line", "Columns" = "column"),
    inline = TRUE
  ),
  highchartOutput("passengers", height = "300px")
)

server <- function(input, output, session) {
  passengers <- as.numeric(AirPassengers)
  initial <- 12L
  output$passengers <- renderHighchart({
    highchart() |>
      hc_xAxis(title = list(text = "Month since January 1949")) |>
      hc_yAxis(title = list(text = "Passengers (thousands)")) |>
      hc_add_series(
        type = "line",
        id = "traffic",
        name = "Air passengers",
        pointStart = 1,
        data = passengers[seq_len(initial)]
      )
  })

  proxy <- highchartProxy("passengers", session)
  observeEvent(input$next_month, {
    i <- initial + input$next_month
    req(i <= length(passengers))
    hcpxy_add_point(proxy, id = "traffic", point = passengers[i])
  })
  observeEvent(
    input$type,
    {
      hcpxy_update_series(proxy, id = "traffic", type = input$type)
    },
    ignoreInit = TRUE
  )
}

shinyApp(ui, server)
