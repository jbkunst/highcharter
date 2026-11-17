library(ggplot2movies)

genres <- c(
  "Action",
  "Animation",
  "Comedy",
  "Drama",
  "Documentary",
  "Romance",
  "Short"
)
counts <- stats::aggregate(movies[genres], list(year = movies$year), sum)
long <- utils::stack(counts[genres])
df <- data.frame(
  year = rep(counts$year, times = length(genres)),
  genre = as.character(long$ind),
  n = long$values
)

hchart(df, "streamgraph", hcaes(year, n, group = genre)) |>
  hc_yAxis(visible = FALSE)
