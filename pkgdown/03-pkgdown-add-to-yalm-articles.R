# packages ----------------------------------------------------------------
library(yaml)
library(tidyverse)

options(rmarkdown.html_vignette.check_title = FALSE)

# data --------------------------------------------------------------------
yml <- yaml::read_yaml("pkgdown/_pkgdown.yml")

artcls <- dir("vignettes") |> 
  basename() |> 
  str_subset("png$", negate = TRUE) |> 
  str_remove(".Rmd")

# get_started
get_started <- c(
  "highcharter",
  "first-steps",
  "showcase",
  "hchart",
  "highcharts-api",
  "highchartsjs-api-basics"
  )

artcls <- setdiff(artcls, get_started)

# highcharts
highcharts <- c("highcharts", "maps", "stock", "themes", "modules")

artcls <- setdiff(artcls, highcharts)

# Xperiments n Xamples
# xx <- c("fontawesome", "drilldown")
xx <- artcls
xx <- unique(c("howtos", "shiny", xx))

yml[["articles"]] <- list(
  list(
    title = "Get Started",
    navbar = "Get Started",
    contents = get_started 
  ),
  list(
    title = "The highchartsJS bundle",
    navbar = "The highchartsJS bundle",
    contents = highcharts
  ),
  list(
    title = "Experiments & Examples",
    navbar = "Experiments & Examples",
    contents = xx
  )
)

yml

# write articles ----------------------------------------------------------
write_yaml(x = yml, file = "pkgdown/_pkgdown.yml")


# build articles ----------------------------------------------------------
# options(rmarkdown.html_vignette.check_title = FALSE)
# pkgdown::build_articles()
# pkgdown::build_articles_index()
# pkgdown::build_article("themes")
# pkgdown::build_article("drilldown")
# pkgdown::preview_site()
