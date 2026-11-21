library(shiny)
library(highcharter)

hc_set_theme("ft")

ui <- fluidPage(
  theme = bslib::bs_theme(
    version = 5,
    bg = "#FFF1E5",
    fg = "#33302E",
    primary = "#0F5499"
  ),
  style = "max-width: 48rem;",
  sliderInput(
    "duration",
    "Eruption duration (minutes)",
    min = 1.5,
    max = 5,
    value = 4,
    step = 0.25
  ),
  highchartOutput("eruptions", height = "325px")
)

server <- function(input, output, session) {
  output$eruptions <- renderHighchart({
    nearby <- subset(faithful, abs(eruptions - input$duration) <= 0.5)
    axes <- hcaes(x = eruptions, y = waiting)
    hchart(
      faithful,
      "scatter",
      axes,
      name = "All eruptions",
      color = "#C6BAB0"
    ) |>
      hc_add_series(
        nearby,
        "scatter",
        axes,
        name = "Within half a minute",
        color = "#0F5499"
      ) |>
      hc_title(text = "When will Old Faithful erupt again?") |>
      hc_subtitle(
        text = sprintf(
          "%d similar eruptions · Median wait: %g min",
          nrow(nearby),
          median(nearby$waiting)
        )
      ) |>
      hc_xAxis(title = list(text = "Eruption duration (min)")) |>
      hc_yAxis(title = list(text = "Wait until the next eruption (min)")) |>
      hc_tooltip(
        headerFormat = "",
        pointFormat = "{point.x:.2f} min eruption · {point.y} min wait"
      )
  })
}

shinyApp(ui, server)
