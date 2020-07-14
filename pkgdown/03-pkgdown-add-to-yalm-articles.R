# packages ----------------------------------------------------------------
library(yaml)
library(tidyverse)

options(rmarkdown.html_vignette.check_title = FALSE)

# data --------------------------------------------------------------------
yml <- yaml::read_yaml("pkgdown/_pkgdown.yml")

artcls <- dir("vignettes") %>% 
  basename() %>% 
  str_remove(".Rmd")

get_started <- c("highcharter", "hchart", "highcharts-api", "showcase")

artcls <- setdiff(artcls, get_started)

extensions <- c("maps", "stock", "themes")

artcls <- setdiff(artcls, extensions)


yml[["articles"]] <- list(
  list(
    title = "Get Started",
    navbar = "Get Started",
    contents = get_started 
  ),
  list(
    title = "Extensions",
    navbar = "Extensions",
    contents = extensions
  ),
  list(
    title = "Extras",
    contents = artcls
  )
)

# write articles ----------------------------------------------------------
write_yaml(x = yml, file = "pkgdown/_pkgdown.yml")


# build articles ----------------------------------------------------------
pkgdown::build_articles()
# pkgdown::build_article("maps")
