items <- data.frame(
  category = c(rep("Drinks", 3), rep("Bakery", 3)),
  name = c("Espresso", "Latte", "Tea", "Croissant", "Muffin", "Cookie"),
  y = c(42, 58, 25, 35, 20, 30)
)
totals <- aggregate(y ~ category, items, sum)
detail <- lapply(totals$category, function(category) {
  rows <- items[items$category == category, c("name", "y")]
  list(id = category, name = category, data = list_parse(rows))
})

# Click a total to see the items that make it up. The breadcrumb takes you back.
highchart() |>
  hc_chart(type = "column") |>
  hc_title(text = "A day at the cafe") |>
  hc_subtitle(
    text = "Click a category to explore its orders (fictional data)"
  ) |>
  hc_xAxis(type = "category") |>
  hc_yAxis(title = list(text = "Orders")) |>
  hc_legend(enabled = FALSE) |>
  hc_add_series(
    totals,
    "column",
    hcaes(name = category, y = y, drilldown = category),
    name = "Orders",
    colorByPoint = TRUE
  ) |>
  hc_drilldown(series = detail)
