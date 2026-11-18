library(highcharter)
library(shiny)
dates <- base::as.Date("2025-01-01") + 0:9
prices <- data.frame(day = dates, price = 20:29)

ui <- fluidPage(actionButton("update", "Update"), highchartOutput("prices"))
server <- function(input, output, session) {
  output$prices <- renderHighchart(
    highchart(type = "stock") |>
      hc_xAxis(id = "days", minRange = 86400000) |>
      hc_add_series(prices, "line", hcaes(day, price), id = "closing")
  )
  observeEvent(input$update, {
    highchartProxy("prices", session) |>
      hcpxy_set_data(
        "line",
        transform(prices, price = price + 5),
        hcaes(day, price),
        id = "closing",
        redraw = TRUE
      ) |>
      hcpxy_set_extremes(dates[3], dates[8], axis = "days")
  })
}
shinyApp(ui, server)
