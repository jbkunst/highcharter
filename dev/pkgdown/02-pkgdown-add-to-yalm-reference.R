# packages ----------------------------------------------------------------
library(yaml)
library(tidyverse)

# buildocs ----------------------------------------------------------------
devtools::document()

# data --------------------------------------------------------------------
yml <- yaml::read_yaml("pkgdown/_pkgdown.yml")

# the package need to be build
dfun <- help.search("*", package = "highcharter") %>%
  .$matches %>% 
  tibble::as_tibble() %>%
  janitor::clean_names() %>% 
  select(name, title) %>% 
  distinct()

dfun <- dfun %>% 
  filter(!name %in% c("highcharter", "highcharter-exports"))

# funs --------------------------------------------------------------------
fun_hc_api <- read_lines("R/highcharts-api.R") %>% 
  str_subset(" <- function") %>% 
  str_remove(" <-.*") %>% 
  c("highchart", "hchart", ., "highchart2", "highchartzero")

dfun <- dfun %>%
  filter(!name %in% fun_hc_api)

fun_hc_thm <- dfun %>% 
  filter(str_detect(name, "theme")) %>% 
  distinct() %>% 
  pull(name) %>% 
  c("hc_theme", "hc_add_theme", "hc_theme_merge", .) %>% 
  unique()

dfun <- dfun %>%
  filter(!name %in% fun_hc_thm)

fun_hc_add_series <- dfun %>% 
  filter(str_detect(name, "hc_add_series")) %>% 
  distinct() %>% 
  pull(name)

dfun <- dfun %>%
  filter(!name %in% fun_hc_add_series)

fun_hc_add <- dfun %>% 
  filter(
    str_detect(name, "add") | 
      str_detect(name, "^hc_") |
      str_detect(name, "tooltip") |
      str_detect(name, "^color") 
    ) %>% 
  distinct() %>% 
  pull(name) %>% 
  c(., "hex_to_rgba")

dfun <- dfun %>%
  filter(!name %in% fun_hc_add)

  
datas <- read_lines("R/data.R") %>% 
  str_subset("\".*\"") %>% 
  str_trim() %>% 
  str_remove_all("\"")

dfun <- dfun %>%
  filter(!name %in% datas)

fun_extras <- dfun %>% 
  distinct() %>% 
  pull(name)
  
  
# gen reference -----------------------------------------------------------
yml[["reference"]] <- list(
  list(
    title = "Highcharts API",
    desc = "Functions to create charts and access the highcharts API (https://api.highcharts.com/highcharts/).",
    contents = fun_hc_api
  ),
  list(
    title = "Additional function to use Highcharts API",
    desc = "Helpers function to add or modify elements, like plugins (as {htmltools} dependencies), events or annotations and
    functions to create valid arguments in `dataClasses`, `stops` or `pointFormatter` parameters.",
    contents = fun_hc_add
  ),
  list(
    title = "Add data",
    desc = "Functions to add data from R objects to a highcharts charts.",
    contents = fun_hc_add_series
  ),
  list(
    title = "Themes",
    desc = "Functions to customize the look of your chart.",
    contents = fun_hc_thm
  ),
  list(
    title = "Data",
    desc = "Data for examples",
    contents = datas
  ),
  list(
    title = "Extra functions",
    contents = fun_extras
  )
)


# write reference ---------------------------------------------------------
write_yaml(x = yml, file = "pkgdown/_pkgdown.yml")

# build reference ---------------------------------------------------------
pkgdown::build_reference_index()
pkgdown::build_reference()



