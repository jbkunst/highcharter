items <- data.frame(
  category = c(rep("Animals", 5), rep("Fruits", 2)),
  name = c("Cats", "Dogs", "Cows", "Sheep", "Pigs", "Apples", "Oranges"),
  y = c(4, 3, 1, 2, 1, 4, 2)
)
totals <- aggregate(y ~ category, items, sum)
detail <- lapply(totals$category, function(category) {
  rows <- items[items$category == category, c("name", "y")]
  list(id = category, name = category, data = list_parse(rows))
})

# Click a total to see the items that make it up. The breadcrumb takes you back.
highchart() |>
  hc_chart(type = "column") |>
  hc_title(text = "Item counts by category") |>
  hc_xAxis(type = "category") |>
  hc_yAxis(title = list(text = "Count")) |>
  hc_legend(enabled = FALSE) |>
  hc_add_series(totals, "column", hcaes(name = category, y = y, drilldown = category),
                name = "Items", colorByPoint = TRUE) |>
  hc_drilldown(series = detail)
