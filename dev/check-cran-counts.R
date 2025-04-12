library(dplyr)
library(lubridate)
library(cranlogs)
library(highcharter)
library(forcats)

pcks <- c("highcharter", "rbokeh", "dygraphs", "plotly", "ggvis", "billboarder",
          "metricsgraphics", "rAmCharts", "echarts4r", "rchess", "apexcharter") 

data <- pcks |> 
  # adjustedcranlogs::adj_cran_downloads(from = "2015-06-01", to = Sys.Date()) |> 
  cranlogs::cran_downloads(from = "2015-06-01", to = Sys.Date()) |> 
  tibble::as_tibble() |> 
  # mutate(date = floor_date(date, unit = "week")) |> 
  # mutate(date = floor_date(date, unit = "year")) |> 
  mutate(date = floor_date(date, unit = "month")) |> 
  group_by(date, package) |> 
  summarize(count = sum(count)) |> 
  ungroup() |> 
  mutate(package = fct_reorder(package, -count)) |> 
  group_by(package) |> 
  arrange(date) |> 
  filter(row_number() != n()) |>
  filter(TRUE)


hchart(data, type = "line", hcaes(x = date, y = count, group = package)) |> 
  hc_chart(zoomType = "x") |> 
  hc_tooltip(sort = TRUE, table = TRUE) |>
  hc_add_theme(hc_theme_smpl()) |> 
  hc_navigator(enabled = TRUE) |> 
  hc_yAxis(endOnTick = FALSE)

data |> 
  filter(year(date) > 2018) |> 
  hchart(type = "line", hcaes(x = date, y = count, group = package)) |> 
  hc_chart(zoomType = "x") |>
  hc_tooltip(sort = TRUE, table = TRUE) |>
  # hc_add_theme(hc_theme_smpl()) |> 
  # hc_navigator(enabled = TRUE) |> 
  hc_xAxis(title = list(text = "")) |> 
  hc_yAxis(title = list(text = "")) |> 
  hc_yAxis(endOnTick = FALSE) |> 
  hc_legend(enabled = FALSE) |> 
  hc_tooltip(
    positioner = JS("function() {return { x: this.chart.plotLeft + 300, y: this.chart.plotTop};}")
  )
