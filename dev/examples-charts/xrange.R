#' ## xrange
#'

N <- 7

set.seed(1234)

months <- seq(as.Date("2025-01-01"), by = "month", length.out = 26)
start_month <- sample(10:20, N)

df <- tibble::tibble(
  start = months[start_month],
  end = months[start_month + sample(1:3, N, replace = TRUE)],
  cat = rep(1:5, length.out = N) - 1,
  progress = round(stats::runif(N), 1)
)

hchart(
  df,
  "xrange",
  hcaes(x = start, x2 = end, y = cat, partialFill = progress),
  dataLabels = list(enabled = TRUE)
  ) |>
  hc_xAxis(
    title = FALSE,
    type = "datetime"
    ) |>
  hc_yAxis(
    title = FALSE,
    categories = c("Prototyping", "Development", "Testing", "Validation", "Modelling")
    )
