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
