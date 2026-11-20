# Shiny applications

Browse the [Shiny
gallery](https://jkunst.com/highcharter/articles/shiny-gallery.md) to
open a standalone app, or run the examples here alongside their R
source. The first launch downloads R and its dependencies. The apps use
the highcharter version documented here.

## Basics

Select **Sepal** or **Petal**. The same 150 flowers move to their new
coordinates. Put `highchartOutput("flowers")` in the UI and read
`input$measure` inside
[`renderHighchart()`](https://jkunst.com/highcharter/reference/renderHighchart.md)
to rebuild the plot when the measurement changes.

Run the iris explorer

R source


    library(shiny)
    library(highcharter)

    ui <- fluidPage(
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

Run the passenger chart

R source


    library(shiny)
    library(highcharter)

    ui <- fluidPage(
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

Click a band in the equalizer. Shiny receives its ID at
`input$eq_point_click$pointid` automatically. Drag the band and release
it. The app uses only `hc_add_event_point(event = "drop")` to send the
final gain in decibels to `input$eq_point_drop$y`.

Run the equalizer

R source


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

[Open the app in its own
tab](https://jkunst.com/highcharter/live/events/index.md)

The output ID, scope and case-sensitive Highcharts event name determine
the input. For example, `hc_add_event_series(event = "mouseOver")` would
send the hovered series to `input$eq_series_mouseOver`.

## Linked views

Click a species in the overview to see the individual flowers in the
detail chart. The server reads `input$overview_point_click$pointid` and
uses a proxy to replace the detail series and its title. This combines
the two preceding patterns and keeps both charts mounted.

Run the linked charts

R source


    library(shiny)
    library(highcharter)

    species <- aggregate(Petal.Length ~ Species, iris, mean)

    ui <- fluidPage(
      p("Click a species to see its individual flowers."),
      fluidRow(
        column(5, highchartOutput("overview", height = "295px")),
        column(7, highchartOutput("detail", height = "295px"))
      )
    )

    server <- function(input, output, session) {
      output$overview <- renderHighchart({
        hchart(
          species,
          "column",
          hcaes(x = Species, y = Petal.Length, id = Species),
          name = "Mean petal length",
          cursor = "pointer"
        ) |>
          hc_yAxis(title = list(text = "Mean petal length (cm)"))
      })
      output$detail <- renderHighchart({
        hchart(
          subset(iris, Species == "setosa"),
          "scatter",
          hcaes(x = Petal.Length, y = Petal.Width),
          id = "flowers",
          name = "Flowers"
        ) |>
          hc_title(text = "setosa") |>
          hc_xAxis(title = list(text = "Petal length (cm)")) |>
          hc_yAxis(title = list(text = "Petal width (cm)"))
      })
      observeEvent(input$overview_point_click, {
        selected <- input$overview_point_click$pointid
        highchartProxy("detail", session) |>
          hcpxy_set_data(
            "scatter",
            iris[iris$Species == selected, ],
            hcaes(x = Petal.Length, y = Petal.Width),
            id = "flowers"
          ) |>
          hcpxy_update(title = list(text = selected))
      })
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
