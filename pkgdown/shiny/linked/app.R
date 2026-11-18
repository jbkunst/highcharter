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
