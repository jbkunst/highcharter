#' ## gantt

N <- 6
set.seed(1234)

months <- seq(base::as.Date("2025-01-01"), by = "month", length.out = 26)
start_month <- sort(2 + sample(10:20, N))

df <- tibble::tibble(
  start = datetime_to_timestamp(months[start_month]),
  end = datetime_to_timestamp(months[
    start_month + sample(1:3, N, replace = TRUE)
  ]),
  name = c("Import", "Tidy", "Visualize", "Model", "Transform", "Communicate"),
  id = tolower(name),
  dependency = list(
    NA,
    "import",
    "tidy",
    "tidy",
    "tidy",
    c("visualize", "model", "transform")
  ),
  completed = c(1, 1, 0.5, 0.6, 0.9, 0)
)

highchart(type = "gantt") |>
  hc_add_series(
    name = "Program",
    data = df
  ) |>
  hc_rangeSelector(enabled = TRUE) |>
  hc_navigator(
    enabled = TRUE,
    series = list(
      type = 'gantt',
      pointPlacement = 0.5,
      pointPadding = 0.25
    ),
    yAxis = list(
      min = 0,
      max = N,
      reversed = TRUE,
      categories = c()
    )
  )
