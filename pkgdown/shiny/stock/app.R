library(highcharter)
library(shiny)

snapshot <- read.csv(system.file(
  "extdata",
  "spy-2025.csv",
  package = "highcharter"
))
daily <- data.frame(day = as.Date(snapshot$date), close = snapshot$SPY.Close)
weekly <- daily[!duplicated(cut(daily$day, "week"), fromLast = TRUE), ]

ui <- fluidPage(
  theme = bslib::bs_theme(version = 5),
  style = "max-width: 48rem;",
  p(
    "View up to six weeks for daily closing prices. Zoom out to see weekly closes."
  ),
  actionButton("april", "Explore April"),
  highchartOutput("prices")
)

server <- function(input, output, session) {
  output$prices <- renderHighchart({
    highchart(type = "stock") |>
      hc_title(text = "SPY closing price, 2025") |>
      hc_legend(enabled = TRUE) |>
      hc_xAxis(
        id = "days",
        ordinal = FALSE,
        minRange = 7 * 86400000,
        events = list(
          afterSetExtremes = JS(
            "function (e) {
              if (e.trigger !== 'updatedData') {
                Shiny.setInputValue('prices_range', [e.min, e.max]);
              }
            }"
          )
        )
      ) |>
      hc_navigator(adaptToUpdatedData = FALSE) |>
      hc_rangeSelector(
        selected = 1,
        buttons = list(
          list(type = "month", count = 1, text = "1m"),
          list(type = "all", text = "All")
        )
      ) |>
      hc_add_series(
        weekly,
        "line",
        hcaes(day, close),
        id = "closing",
        name = "Weekly close",
        dataGrouping = list(enabled = FALSE)
      ) |>
      hc_tooltip(valueDecimals = 2, valuePrefix = "$")
  })

  observeEvent(input$april, {
    highchartProxy("prices", session) |>
      hcpxy_set_extremes(
        as.Date("2025-04-01"),
        as.Date("2025-04-30"),
        axis = "days"
      )
  })

  observeEvent(input$prices_range, {
    days <- as.Date(
      unlist(input$prices_range) / 86400000,
      origin = "1970-01-01"
    )
    detail <- as.numeric(diff(days)) <= 42
    prices <- if (detail) {
      subset(daily, day >= days[1] & day <= days[2])
    } else {
      weekly
    }
    highchartProxy("prices", session) |>
      hcpxy_set_data("line", prices, hcaes(day, close), id = "closing") |>
      hcpxy_update_series(
        id = "closing",
        name = if (detail) "Daily close" else "Weekly close"
      )
  })
}

shinyApp(ui, server)
