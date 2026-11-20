library(shiny)
library(bslib)
library(highcharter)

observations <- window(sunspot.month, start = c(1950, 1), end = c(2019, 12))
annual <- aggregate(observations, nfrequency = 1, FUN = mean)
sunspots <- data.frame(
  year = as.integer(time(annual)),
  count = as.numeric(annual)
)

hc_set_theme("bslib")
observatory <- bs_theme(
  version = 5,
  bg = "#FFF4DE",
  fg = "#38261F",
  primary = "#9C3C16",
  base_font = "Georgia, serif"
) |>
  bs_add_rules(
    "
    [data-bs-theme='dark'] {
      --bs-body-bg: #101D30;
      --bs-body-color: #F3E6CD;
      --bs-primary: #FFBC65;
      --bs-border-color: #40516A;
    }
  "
  )

ui <- page_fluid(
  theme = observatory,
  title = "Solar cycles",
  div(
    class = "d-flex justify-content-end align-items-center gap-2 py-2",
    "Color mode",
    input_dark_mode(mode = "light")
  ),
  highchartOutput("cycles", height = "320px")
)

server <- function(input, output, session) {
  output$cycles <- renderHighchart({
    hchart(
      sunspots,
      "area",
      hcaes(x = year, y = count),
      name = "Annual mean",
      fillOpacity = 0.18,
      marker = list(enabled = FALSE)
    ) |>
      hc_title(text = "Solar cycles, 1950–2019") |>
      hc_xAxis(
        title = list(text = NULL),
        labels = list(format = "{value:.0f}")
      ) |>
      hc_yAxis(min = 0, title = list(text = "Mean sunspot number")) |>
      hc_legend(enabled = FALSE) |>
      hc_tooltip(headerFormat = "<b>{point.x:.0f}</b><br/>", valueDecimals = 1)
  })
}

shinyApp(ui, server)
