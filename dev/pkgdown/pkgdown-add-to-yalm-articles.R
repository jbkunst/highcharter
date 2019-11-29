# packages ----------------------------------------------------------------
library(yaml)
library(tidyverse)

# data --------------------------------------------------------------------
yml <- yaml::read_yaml("pkgdown/_pkgdown.yml")


yml[["articles"]] <- list(
  list(
    title = "Starting",
    content = c("charting-data-frames", "hchart", "highcharts-api")
  )
)


# write reference ---------------------------------------------------------
write_yaml(x = yml, file = "pkgdown/_pkgdown.yml")


# build reference ---------------------------------------------------------
pkgdown::build_articles()
