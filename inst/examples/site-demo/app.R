library(shiny)
library(highcharter)

# This example uses the same typography and palette as the documentation site.
site_theme <- hc_theme(
  colors = c("#47475c", "#61BC7B", "#508CC8", "#F49952", "#9C9EDB", "#6699a1"),
  chart = list(
    backgroundColor = "transparent",
    style = list(fontFamily = "IBM Plex Sans, sans-serif")
  ),
  title = list(
    style = list(fontFamily = "Alegreya Sans SC", fontWeight = "normal")
  ),
  plotOptions = list(series = list(marker = list(symbol = "circle")))
)

ui <- fluidPage(
  tags$head(tags$link(
    rel = "stylesheet",
    href = paste0(
      "https://fonts.googleapis.com/css2?family=IBM+Plex+Sans:wght@300;400&",
      "family=Alegreya+Sans+SC&display=swap"
    )
  )),
  tags$style(
    "body { font-family: 'IBM Plex Sans', sans-serif; font-weight: 300; }"
  ),
  selectInput(
    "measurement",
    "Measurements",
    c("Sepals" = "Sepal", "Petals" = "Petal")
  ),
  highchartOutput("flowers", height = "360px")
)

server <- function(input, output, session) {
  output$flowers <- renderHighchart({
    columns <- paste0(input$measurement, c(".Length", ".Width"))
    hchart(
      iris,
      "scatter",
      hcaes_string(x = columns[1], y = columns[2], group = "Species")
    ) |>
      hc_add_theme(site_theme) |>
      hc_title(text = paste(input$measurement, "measurements"))
  })
}

shinyApp(ui, server)
