# Shiny applications

Browse the [Shiny
gallery](https://jkunst.com/highcharter/articles/shiny-gallery.md) in a
new tab, or run the examples here alongside their R source. The first
launch downloads R and its dependencies. The apps use the highcharter
version documented here.

## Basics

Select **Sepal** or **Petal**. The same 150 flowers move to their new
coordinates. Put `highchartOutput("flowers")` in the UI and read
`input$measure` inside
[`renderHighchart()`](https://jkunst.com/highcharter/reference/renderHighchart.md)
to rebuild the plot when the measurement changes.


    library(shiny)
    library(highcharter)

    ui <- fluidPage(
      theme = bslib::bs_theme(version = 5),
      selectInput("measure", "Iris measurements", c("Sepal", "Petal")),
      highchartOutput("flowers", height = "310px")
    )

    server <- function(input, output, session) {
      output$flowers <- renderHighchart({
        hchart(
          iris,
          "scatter",
          hcaes_string(
            x = paste0(input$measure, ".Length"),
            y = paste0(input$measure, ".Width"),
            group = "Species"
          )
        ) |>
          hc_xAxis(title = list(text = "Length (cm)")) |>
          hc_yAxis(title = list(text = "Width (cm)"))
      })
    }

    shinyApp(ui, server)

[Open the app in its own
tab](https://jkunst.com/highcharter/live/basic/index.md)

## Proxies

Start with twelve months of air passenger counts. **Add a month**
appends one observation with
[`hcpxy_add_point()`](https://jkunst.com/highcharter/reference/hcpxy_add_point.md).
**Columns** changes the series type with
[`hcpxy_update_series()`](https://jkunst.com/highcharter/reference/hcpxy_update_series.md).
Switch back to **Line** and your added months are still there. Both
controls target the series ID `traffic` through
`highchartProxy("passengers", session)`.


    library(shiny)
    library(highcharter)

    ui <- fluidPage(
      theme = bslib::bs_theme(version = 5),
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

[Open the app in its own
tab](https://jkunst.com/highcharter/live/proxy/index.md)

To switch from weekly to daily Stock prices when the visible date range
narrows, [run the Stock proxy
app](https://jkunst.com/highcharter/live/stock/index.md) or [read the
Stock
walkthrough](https://jkunst.com/highcharter/articles/stock.html#update-a-series-and-its-visible-range-in-shiny).

## Events

Each lit segment adds 1 dB to the band’s gain, starting at −12 dB. Hover
over a band, click it, then drag its top and release it. The table keeps
the latest band and gain for each event. Watch the `drag` row change as
you move and the `drop` row update when you release.


    library(shiny)
    library(highcharter)

    bands <- data.frame(
      band = c("60 Hz", "250 Hz", "1 kHz", "4 kHz", "16 kHz"),
      gain = c(0, 5, -4, 8, 2)
    )

    ui <- fluidPage(
      theme = bslib::bs_theme(version = 5),
      tags$head(tags$style("#eq .highcharts-grid-line { pointer-events: none; }")),
      h2("Equalizer"),
      p("Hover or click a band. Drag its top to change the gain."),
      highchartOutput("eq", height = "320px"),
      h3("Latest event by type"),
      tableOutput("events")
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

      output$events <- renderTable(
        {
          rows <- lapply(c("click", "drag", "mouseOver", "drop"), function(event) {
            point <- input[[paste0("eq_point_", event)]]
            data.frame(
              Event = event,
              Band = if (is.null(point)) NA_character_ else point$pointid,
              `Gain (dB)` = if (is.null(point)) NA_real_ else point$y,
              check.names = FALSE
            )
          })
          do.call(rbind, rows)
        },
        na = "—",
        digits = 0,
        striped = TRUE
      )
    }

    shinyApp(ui, server)

[Open the app in its own
tab](https://jkunst.com/highcharter/live/events/index.md)

Point clicks arrive automatically at `input$eq_point_click`. Register
`mouseOver`, `drag` and `drop` with
[`hc_add_event_point()`](https://jkunst.com/highcharter/reference/hc_add_event_point.md)
to receive their inputs too. For example,
`input$eq_point_mouseOver$pointid` identifies the band under the pointer
and `input$eq_point_drag$y` gives its gain during a drag.

## Linked views

The dotplot shows mean petal length by species, rounded to the nearest
millimeter. With `colorByPoint = TRUE`, each species gets its own color.
Hover over a species or click it to see petal length and width for its
50 flowers in the same color. A Shiny proxy updates the detail points,
series color and title while keeping the axes fixed for comparison.


    library(shiny)
    library(highcharter)

    species <- aggregate(Petal.Length ~ Species, iris, mean)
    species$mean_mm <- round(10 * species$Petal.Length)
    colors <- setNames(
      hc_theme("hcrt")$colors[seq_len(nrow(species))],
      species$Species
    )

    ui <- fluidPage(
      theme = bslib::bs_theme(version = 5),
      p(
        "Each dot represents 1 mm of mean petal length.",
        "Hover or click a species to see its 50 flowers in the same color."
      ),
      fluidRow(
        column(5, highchartOutput("overview", height = "295px")),
        column(7, highchartOutput("detail", height = "295px"))
      )
    )

    server <- function(input, output, session) {
      output$overview <- renderHighchart({
        hchart(
          species,
          "dotplot",
          hcaes(x = Species, y = mean_mm, id = Species),
          name = "Mean petal length",
          colorByPoint = TRUE,
          slotsPerBar = 3,
          itemPadding = 0.1,
          cursor = "pointer"
        ) |>
          hc_chart(inverted = TRUE) |>
          hc_colors(unname(colors)) |>
          hc_xAxis(title = list(text = NULL)) |>
          hc_yAxis(min = 0, title = list(text = "Mean petal length (mm)")) |>
          hc_tooltip(valueDecimals = 0, valueSuffix = " mm") |>
          hc_add_event_point(event = "mouseOver")
      })

      initial <- as.character(species$Species[1])
      selected <- reactiveVal(initial)
      observeEvent(
        input$overview_point_mouseOver,
        selected(input$overview_point_mouseOver$pointid)
      )
      observeEvent(
        input$overview_point_click,
        selected(input$overview_point_click$pointid)
      )

      output$detail <- renderHighchart({
        hchart(
          subset(iris, Species == initial),
          "scatter",
          hcaes(x = Petal.Length, y = Petal.Width),
          id = "flowers",
          name = initial,
          color = colors[[initial]]
        ) |>
          hc_title(text = initial) |>
          hc_xAxis(min = 0, max = 7, title = list(text = "Petal length (cm)")) |>
          hc_yAxis(min = 0, max = 2.6, title = list(text = "Petal width (cm)"))
      })
      observeEvent(
        selected(),
        {
          group <- selected()
          highchartProxy("detail", session) |>
            hcpxy_set_data(
              "scatter",
              subset(iris, Species == group),
              hcaes(x = Petal.Length, y = Petal.Width),
              id = "flowers"
            ) |>
            hcpxy_update(
              title = list(text = group),
              series = list(list(
                id = "flowers",
                name = group,
                color = colors[[group]]
              ))
            )
        },
        ignoreInit = TRUE
      )
    }

    shinyApp(ui, server)

[Open the app in its own
tab](https://jkunst.com/highcharter/live/linked/index.md)

To run an example from a local checkout, load the package and open the
app directory:

``` r

pkgload::load_all()
shiny::runApp("pkgdown/shiny/events")
```

The [original Shiny
examples](https://github.com/jbkunst/highcharter-shiny) include the full
[proxy
playground](https://github.com/jbkunst/highcharter-shiny/tree/master/02-proxy-functions)
and a [population explorer with linked
views](https://github.com/jbkunst/highcharter-shiny/tree/master/08-idb-viz).
