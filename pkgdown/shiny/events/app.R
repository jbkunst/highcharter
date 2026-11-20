library(shiny)
library(highcharter)

bands <- data.frame(
  band = c("60 Hz", "250 Hz", "1 kHz", "4 kHz", "16 kHz"),
  gain = c(0, 5, -4, 8, 2)
)
events <- c("click", "drag", "mouseOver", "drop")

ui <- fluidPage(
  theme = bslib::bs_theme(version = 5),
  style = "max-width: 48rem;",
  tags$head(tags$style(
    "
    #eq .highcharts-grid-line { pointer-events: none; }
    #readings { font-variant-numeric: tabular-nums; }
    #readings .recalculating { opacity: 1; }
  "
  )),
  tags$main(
    h2("Equalizer"),
    p("Hover or click a band. Drag its top to change the gain."),
    highchartOutput("eq", height = "320px"),
    h3("Latest event by type"),
    tags$dl(
      id = "readings",
      class = "row row-cols-2 row-cols-sm-4",
      lapply(events, function(event) {
        div(
          class = "col",
          tags$dt(event),
          tags$dd(textOutput(event, inline = TRUE))
        )
      })
    )
  )
)

server <- function(input, output, session) {
  output$eq <- renderHighchart({
    hchart(
      bands,
      "column",
      hcaes(x = band, y = gain, id = band),
      name = "Gain",
      color = "#39d9f5",
      zIndex = 1,
      cursor = "ns-resize",
      dragDrop = list(
        draggableY = TRUE,
        dragMinY = -12,
        dragMaxY = 12,
        dragPrecisionY = 1
      )
    ) |>
      hc_add_series(
        type = "column",
        name = "Band range",
        data = rep(12, nrow(bands)),
        color = "#203245",
        enableMouseTracking = FALSE,
        accessibility = list(enabled = FALSE),
        zIndex = 0
      ) |>
      hc_plotOptions(
        column = list(
          grouping = FALSE,
          threshold = -12,
          borderWidth = 0,
          borderRadius = 0,
          maxPointWidth = 54,
          minPointLength = 4
        )
      ) |>
      hc_chart(backgroundColor = "#101a29") |>
      hc_legend(enabled = FALSE) |>
      hc_xAxis(
        title = list(text = NULL),
        gridLineWidth = 0,
        labels = list(style = list(color = "#e4ecf4"))
      ) |>
      hc_yAxis(
        min = -12,
        max = 12,
        tickInterval = 1,
        labels = list(step = 6, style = list(color = "#e4ecf4")),
        title = list(text = "Gain (dB)", style = list(color = "#e4ecf4")),
        gridLineColor = "#101a29",
        gridLineWidth = 2,
        gridZIndex = 4
      ) |>
      hc_tooltip(valueSuffix = " dB", valueDecimals = 0) |>
      hc_add_event_point(event = "mouseOver") |>
      hc_add_event_point(event = "drag") |>
      hc_add_event_point(event = "drop")
  })

  lapply(events, function(event) {
    point <- reactive(input[[paste0("eq_point_", event)]])
    reading <- if (event %in% c("drag", "mouseOver")) {
      throttle(point, 150)
    } else {
      point
    }
    output[[event]] <- renderText({
      value <- reading()
      if (is.null(value)) {
        return("—")
      }
      sprintf("%s · %+d dB", value$pointid, as.integer(value$y))
    })
  })
}

shinyApp(ui, server)
