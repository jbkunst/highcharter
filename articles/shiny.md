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
      style = "max-width: 48rem;",
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

The [original proxy
playground](https://github.com/jbkunst/highcharter-shiny/tree/master/02-proxy-functions)
inspired these three examples. Each tab creates its chart once, then
uses
[`highchartProxy()`](https://jkunst.com/highcharter/reference/highchartProxy.md)
to change the chart already on screen.

- **Series.** Compare monthly temperatures in Santiago and Tokyo. Toggle
  Tokyo to add or remove its series. Switch from daily means to daily
  highs to replace the data by series ID with
  [`hcpxy_set_data()`](https://jkunst.com/highcharter/reference/hcpxy_set_data.md).
  A single
  [`hcpxy_redraw()`](https://jkunst.com/highcharter/reference/hcpxy_redraw.md)
  displays both changes. Try the same comparison on polar axes.
- **Points.** Add or remove a month of observed air traffic. Turn on the
  dashed forecast to repeat the last twelve observations one year ahead.
  The forecast moves with the observations, even when you switch to
  columns.
- **Layout.** Rearrange the same 592 students into a grid, semicircle or
  circle.
  [`hcpxy_update_series()`](https://jkunst.com/highcharter/reference/hcpxy_update_series.md)
  changes the item layout while preserving the counts.


    library(shiny)
    library(bslib)
    library(highcharter)

    hc_set_theme("hcrt")
    palette <- hc_theme("hcrt")$colors

    weather <- aggregate(
      cbind(temp_mean, temp_max) ~ city + month,
      transform(city_weather, month = as.integer(format(date, "%m")) - 1L),
      mean
    )
    city_months <- function(city, measure) {
      rows <- weather[weather$city == city, ]
      data.frame(x = rows$month, y = round(rows[[measure]], 1))
    }

    counts <- as.numeric(AirPassengers)
    months <- seq(
      as.Date("1949-01-01"),
      by = "month",
      length.out = length(counts) + 12L
    )
    dates <- datetime_to_timestamp(months)
    traffic <- data.frame(x = dates[seq_along(counts)], y = counts)
    initial <- 24L
    # A seasonal naive forecast repeats the last 12 observed months.
    outlook <- function(n) {
      data.frame(x = dates[n + seq_len(12L)], y = counts[(n - 11L):n])
    }

    eyes <- as.data.frame.table(
      margin.table(HairEyeColor, 2),
      responseName = "students"
    )

    ui <- page_fluid(
      title = "Proxy playground",
      theme = bs_theme(
        version = 5,
        primary = palette[1],
        base_font = c("IBM Plex Sans", "sans-serif"),
        heading_font = c("Alegreya Sans SC", "sans-serif")
      ),
      style = "max-width: 48rem;",
      tags$main(
        class = "py-2",
        navset_underline(
          nav_panel(
            "Series",
            div(
              class = "d-flex align-items-center flex-wrap gap-3 pt-3",
              selectInput(
                "measure",
                "Monthly average of",
                c("Daily mean" = "temp_mean", "Daily high" = "temp_max"),
                width = "11rem"
              ),
              checkboxInput("tokyo", "Compare with Tokyo", TRUE, width = "auto"),
              checkboxInput("polar", "Polar chart", width = "auto")
            ),
            highchartOutput("weather", height = "320px")
          ),
          nav_panel(
            "Points",
            div(
              class = "d-flex align-items-center flex-wrap gap-2 py-3",
              actionButton("add", "Add a month", class = "btn-primary"),
              actionButton("remove", "Remove last month"),
              checkboxInput("forecast", "Show seasonal forecast", width = "auto")
            ),
            radioButtons(
              "type",
              "Observed series",
              c("Line" = "line", "Columns" = "column"),
              inline = TRUE
            ),
            highchartOutput("passengers", height = "300px")
          ),
          nav_panel(
            "Layout",
            div(
              class = "pt-3",
              radioButtons(
                "shape",
                "Arrange the dots",
                c("Grid", "Semicircle", "Circle"),
                inline = TRUE
              )
            ),
            highchartOutput("students", height = "320px")
          )
        )
      )
    )

    server <- function(input, output, session) {
      output$weather <- renderHighchart({
        highchart() |>
          hc_title(text = "City temperatures, 2025") |>
          hc_xAxis(categories = month.abb) |>
          hc_yAxis(
            title = list(text = ""),
            labels = list(format = "{value}°C"),
            tickInterval = 10
          ) |>
          hc_tooltip(shared = TRUE, valueSuffix = " °C", valueDecimals = 1) |>
          hc_add_series(
            city_months("Santiago", "temp_mean"),
            "line",
            hcaes(x, y),
            id = "Santiago",
            name = "Santiago",
            color = palette[1]
          ) |>
          hc_add_series(
            city_months("Tokyo", "temp_mean"),
            "line",
            hcaes(x, y),
            id = "Tokyo",
            name = "Tokyo",
            color = palette[3]
          )
      })

      weather_proxy <- highchartProxy("weather", session)
      observeEvent(
        input$tokyo,
        {
          if (input$tokyo) {
            hcpxy_add_series(
              weather_proxy,
              city_months("Tokyo", input$measure),
              "line",
              hcaes(x, y),
              id = "Tokyo",
              name = "Tokyo",
              color = palette[3]
            )
          } else {
            hcpxy_remove_series(weather_proxy, "Tokyo")
          }
        },
        ignoreInit = TRUE
      )
      observeEvent(
        input$measure,
        {
          cities <- c("Santiago", if (input$tokyo) "Tokyo")
          for (city in cities) {
            hcpxy_set_data(
              weather_proxy,
              "line",
              city_months(city, input$measure),
              hcaes(x, y),
              id = city
            )
          }
          hcpxy_redraw(weather_proxy)
        },
        ignoreInit = TRUE
      )
      observeEvent(
        input$polar,
        {
          hcpxy_update(weather_proxy, chart = list(polar = input$polar))
        },
        ignoreInit = TRUE
      )

      output$passengers <- renderHighchart({
        hchart(
          traffic[seq_len(initial), ],
          "line",
          hcaes(x, y),
          id = "traffic",
          name = "Observed",
          showInLegend = TRUE
        ) |>
          hc_title(text = "International air passengers") |>
          hc_xAxis(type = "datetime", title = list(text = "")) |>
          hc_yAxis(title = list(text = "Passengers (thousands)")) |>
          hc_tooltip(xDateFormat = "%B %Y", valueDecimals = 0, valueSuffix = "k")
      })

      passengers <- highchartProxy("passengers", session)
      last <- reactiveVal(initial)
      observeEvent(input$add, {
        n <- last() + 1L
        req(n <= length(counts))
        hcpxy_add_point(
          passengers,
          "traffic",
          point = list(x = dates[n], y = counts[n])
        )
        last(n)
      })
      observeEvent(input$remove, {
        n <- last()
        req(n > 12L)
        hcpxy_remove_point(passengers, "traffic", i = n - 1L)
        last(n - 1L)
      })
      observeEvent(
        input$type,
        {
          hcpxy_update_series(passengers, "traffic", type = input$type)
        },
        ignoreInit = TRUE
      )
      observeEvent(
        input$forecast,
        {
          if (input$forecast) {
            hcpxy_add_series(
              passengers,
              outlook(last()),
              "line",
              hcaes(x, y),
              id = "outlook",
              name = "Seasonal forecast",
              linkedTo = "traffic",
              dashStyle = "ShortDash",
              color = palette[3],
              showInLegend = TRUE
            )
          } else {
            hcpxy_remove_series(passengers, "outlook")
          }
        },
        ignoreInit = TRUE
      )
      observeEvent(
        last(),
        {
          n <- last()
          updateActionButton(session, "add", disabled = n == length(counts))
          updateActionButton(session, "remove", disabled = n == 12L)
          if (input$forecast) {
            hcpxy_set_data(
              passengers,
              "line",
              outlook(n),
              hcaes(x, y),
              id = "outlook",
              redraw = TRUE
            )
          }
        },
        ignoreInit = TRUE
      )

      output$students <- renderHighchart({
        hchart(
          eyes,
          "item",
          hcaes(name = Eye, y = students),
          id = "eyes",
          name = "Students",
          showInLegend = TRUE,
          dataLabels = list(enabled = FALSE)
        ) |>
          hc_title(text = "Eye color of 592 students") |>
          hc_subtitle(text = "Each dot represents one student.") |>
          hc_colors(c("#80583B", "#508CC8", "#AE965E", "#57936A")) |>
          hc_legend(labelFormat = "{name} · {y}") |>
          hc_tooltip(pointFormat = "{point.y} students")
      })
      observeEvent(
        input$shape,
        {
          angles <- switch(
            input$shape,
            Grid = list(NULL, NULL),
            Semicircle = c(-90, 90),
            Circle = c(0, 360)
          )
          semicircle <- input$shape == "Semicircle"
          highchartProxy("students", session) |>
            hcpxy_update_series(
              "eyes",
              startAngle = angles[[1]],
              endAngle = angles[[2]],
              center = c("50%", if (semicircle) "88%" else "50%"),
              size = if (semicircle) "160%" else "90%"
            )
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
over a band, click it, then drag its top and release it. Each event has
its own readout. The `drag` and `mouseOver` values refresh at most once
every 150 ms. The `drop` value shows the final gain as soon as you
release the band.


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
Pause over a species for 200 ms or click it for an immediate selection.
The detail shows petal length and width for its 50 flowers in the same
color. A Shiny proxy updates the detail points, series color and title
while keeping the axes fixed for comparison.


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
      style = "max-width: 60rem;",
      tags$main(
        p(
          "Each dot represents 1 mm of mean petal length.",
          "Hover or click a species to see its 50 flowers in the same color."
        ),
        fluidRow(
          column(
            5,
            div(
              class = "mx-auto",
              style = "max-width: 24rem;",
              highchartOutput("overview", height = "295px")
            )
          ),
          column(7, highchartOutput("detail", height = "295px"))
        )
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
      requested <- reactiveVal(initial)
      selected <- reactiveVal(initial)
      settled <- debounce(requested, 200)
      observeEvent(settled(), selected(settled()), ignoreInit = TRUE)
      observeEvent(
        input$overview_point_mouseOver,
        requested(input$overview_point_mouseOver$pointid)
      )
      observeEvent(input$overview_point_click, {
        group <- input$overview_point_click$pointid
        requested(group)
        selected(group)
      })

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
examples](https://github.com/jbkunst/highcharter-shiny) also include a
[population explorer with linked
views](https://github.com/jbkunst/highcharter-shiny/tree/master/08-idb-viz).
