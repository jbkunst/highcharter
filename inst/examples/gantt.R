#' ## Gantt schedules
tasks <- data.frame(
  name = c("Import", "Clean", "Explore", "Model", "Review", "Publish"),
  id = c("import", "clean", "explore", "model", "review", "publish"),
  start = datetime_to_timestamp(as.Date("2025-06-02") + c(0, 2, 5, 5, 10, 12)),
  end = datetime_to_timestamp(as.Date("2025-06-02") + c(2, 5, 8, 10, 12, 13)),
  completed = c(1, 1, 1, 0.6, 0, 0)
)
tasks$dependency <- list(
  NA,
  "import",
  "clean",
  "clean",
  c("explore", "model"),
  "review"
)
tasks$color <- c(
  "#326b65",
  "#326b65",
  "#326b65",
  "#4678a8",
  "#ac7955",
  "#ac7955"
)

hchart(tasks, "gantt", name = "Release plan") |>
  hc_title(text = "From raw data to release") |>
  hc_subtitle(
    text = "Exploration and modelling run in parallel before review"
  ) |>
  hc_yAxis(
    labels = list(
      levels = list(list(level = 1, style = list(fontWeight = "normal")))
    )
  ) |>
  hc_plotOptions(
    gantt = list(
      completed = list(fill = "#21434c"),
      dataLabels = list(
        style = list(
          fontWeight = "normal",
          color = "#FFFFFF",
          textOutline = "none"
        )
      )
    )
  ) |>
  hc_size(height = 355)
