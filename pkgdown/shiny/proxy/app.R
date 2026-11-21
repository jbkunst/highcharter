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
