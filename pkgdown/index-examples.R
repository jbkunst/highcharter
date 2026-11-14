library(highcharter)
library(htmltools)

# Rendered by dev/build-site.R. All four widgets share the same runtime.
charts <- list(
  hc_title(highcharts_demo(), text = "Monthly temperatures"),
  hchart(iris, "scatter", hcaes(Sepal.Length, Petal.Length, group = Species)) |>
    hc_title(text = "Iris measurements"),
  hchart(as.matrix(datasets::ability.cov$cov)) |> hc_title(text = "Ability test covariance"),
  hchart(mtcars$mpg, breaks = 7) |> hc_title(text = "Fuel economy")
)
cards <- lapply(charts, function(chart) {
  chart |> hc_chart(animation = FALSE) |>
    hc_plotOptions(series = list(animation = FALSE)) |>
    hc_size(height = 200)
})
page <- tagList(
  tags$head(tags$title("Highcharter examples"),
    tags$meta(name = "viewport", content = "width=device-width,initial-scale=1"),
    tags$style(HTML("body{margin:0}main{display:grid;grid-template-columns:1fr 1fr;gap:8px}main>div{min-width:0}@media(max-width:600px){main{grid-template-columns:1fr}}"))),
  tags$main(lapply(cards, tags$div))
)
save_html(page, file.path(site_dir, "home-gallery.html"), libdir = "gallery-libs")
