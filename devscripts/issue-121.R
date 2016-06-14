library(highcharter)

suppressPackageStartupMessages(library(dplyr))
suppressPackageStartupMessages(library(purrr))

n <- 10

hc <- highchart() %>% 
  hc_add_series(data = rnorm(n), name = "s1", id = "g1") %>% 
  hc_add_series(data = rnorm(n), name = "s2", id = "g2")

hc

series <- data_frame(
  name = paste0("series", seq(1:n)),
  linkedTo = ifelse(runif(n) < 0.5, "g1", "g2"),
  data = map(1:10, rnorm, n = 10)) %>%
  list.parse3()

series[[1]]

hc %>% 
  hc_add_series_list(series)
