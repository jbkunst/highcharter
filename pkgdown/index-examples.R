library(highcharter)
library(htmltools)

# hchart() keeps the four measurements on each point for the second view.
iris_chart <- hchart(datasets::iris, "scatter",
  hcaes(Sepal.Length, Sepal.Width, group = Species)) |>
  hc_chart(backgroundColor = "transparent", animation = FALSE,
           spacing = c(6, 12, 0, 6),
           style = list(fontFamily = "system-ui, sans-serif")) |>
  hc_colors(c("#6AD8D2", "#AC9BFF", "#FFA681")) |>
  hc_xAxis(min = 0, max = 8, tickInterval = 1, title = list(text = "Length (cm)")) |>
  hc_yAxis(min = 0, max = 5, tickInterval = 1, title = list(text = "Width (cm)")) |>
  hc_plotOptions(series = list(animation = FALSE,
    marker = list(symbol = "circle", radius = 4))) |>
  hc_legend(align = "center", itemDistance = 14, padding = 3,
            itemStyle = list(color = "#E8E7F3", fontWeight = "normal"),
            itemHoverStyle = list(color = "#FFFFFF")) |>
  hc_tooltip(headerFormat = "<b>{series.name}</b><br>",
             pointFormat = "Length: {point.x:.1f} cm<br>Width: {point.y:.1f} cm") |>
  hc_accessibility(description = "Length and width of 150 iris flowers in centimetres. Choose sepals or petals to compare the three species.") |>
  hc_size(height = 248) |>
  htmlwidgets::onRender(paste(readLines("pkgdown/home-iris.js"), collapse = "\n"))

page <- tagList(
  tags$head(tags$title("Iris, from sepals to petals"),
    tags$meta(name = "viewport", content = "width=device-width, initial-scale=1"),
    includeCSS("pkgdown/home-iris.css")),
  tags$main(
    tags$header(
      tags$div(tags$h1("What separates an iris?"),
               tags$p("The same 150 flowers, measured two ways.")),
      tags$fieldset(tags$legend("Measurements"),
        tags$label(tags$input(type = "radio", name = "measure", value = "Sepal",
                              checked = "checked"), tags$span("Sepals")),
        tags$label(tags$input(type = "radio", name = "measure", value = "Petal"),
                   tags$span("Petals")))
    ),
    iris_chart
  )
)
save_html(page, file.path(site_dir, "home-gallery.html"), libdir = "gallery-libs")
