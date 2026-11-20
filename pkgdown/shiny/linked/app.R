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
