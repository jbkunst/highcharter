#' ## Tile map
#'
#' This local copy of [Maarten Lambrechts' world tile grid](https://gist.github.com/maartenzam/787498bbc07ae06b637447dbd430ea0a)
#' uses chart coordinates, with north at the top.
grid_file <- here::here("dev", "examples-charts", "data", "world-tile-grid.csv")
data <- utils::read.csv(grid_file, na.strings = character())

hchart(data, "tilemap", hcaes(x = x, y = y, name = name, group = region)) %>%
  hc_chart(type = "tilemap") %>% 
  hc_plotOptions(
    series = list(
      dataLabels = list(
        enabled = TRUE,
        format = "{point.alpha_2}",
        color = "white",
        style = list(textOutline = FALSE)
      )
    )
  ) %>% 
  hc_tooltip(
    headerFormat = "",
    pointFormat = "<b>{point.name}</b> is in <b>{point.region}</b>"
    ) %>% 
  hc_xAxis(visible = FALSE) %>% 
  hc_yAxis(visible = FALSE) %>% 
  hc_size(height = 800)
