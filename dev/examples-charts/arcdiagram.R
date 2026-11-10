#' ## Arc diagram
#'
#' Each arc connects two stations. Its width represents the number of trips
#' in this example.
trips <- data.frame(
  from = c("North", "North", "Central"),
  to = c("Central", "South", "South"),
  weight = c(12, 5, 8)
)

highchart() |>
  hc_add_series(type = "arcdiagram", name = "Trips", data = list_parse(trips))
