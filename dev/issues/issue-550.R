# Grouped-series benchmark from https://github.com/jbkunst/highcharter/pull/550
library(highcharter)

set.seed(2019)
d <- data.frame(
  month = rep(1:120, 50),
  sim = rep(1:50, each = 120),
  n = runif(6000)
)

system.time({
  chart <- hchart(d, "line", hcaes(month, n, group = sim)) |>
    hc_legend(enabled = FALSE)
  htmltools::as.tags(chart)
})
