# packages ----------------------------------------------------------------
library(yaml)
library(tidyverse)

# buildocs ----------------------------------------------------------------
devtools::document()

# data --------------------------------------------------------------------
yml <- yaml::read_yaml("pkgdown/_pkgdown.yml")

# the package needs to be build
message(rep("the package needs to be build\n", 50))
dfun <- help.search("*", package = "highcharter") %>%
  .$matches %>% 
  tibble::as_tibble() %>%
  janitor::clean_names() %>% 
  select(name, title) %>% 
  distinct()

# api ---------------------------------------------------------------------
fun_hc_api <- read_lines("R/highcharts-api.R") %>% 
  str_subset(" <- function") %>% 
  str_remove(" <-.*") %>% 
  c("highchart", "hchart", ., "highchart2", "highchartzero")

fun_hc_api

dfun <- dfun %>%
  filter(!name %in% fun_hc_api)


# deprecated functions ----------------------------------------------------
fun_hc_dep <- c("hcparcords", "hcspark", "hctreemap", "hctreemap2",
                "hciconarray", "hcboxplot", "hc_add_dependency_fa", "fa_icon",
                "fa_icon_mark")

fun_hc_dep

dfun <- dfun %>%
  filter(!name %in% fun_hc_dep)


# theme -------------------------------------------------------------------
fun_hc_thm <- dfun %>% 
  filter(str_detect(name, "theme")) %>% 
  distinct() %>% 
  pull(name) %>% 
  c("hc_theme", "hc_add_theme", "hc_theme_merge", .) %>% 
  unique()

fun_hc_thm

dfun <- dfun %>%
  filter(!name %in% fun_hc_thm)

# add series --------------------------------------------------------------
fun_hc_add_series <- dfun %>% 
  filter(str_detect(name, "hc_add_series")) %>% 
  distinct() %>% 
  pull(name)

fun_hc_add_series

dfun <- dfun %>%
  filter(!name %in% fun_hc_add_series)

# proxy -------------------------------------------------------------------
fun_hc_prxy <- dfun %>% 
  filter(str_detect(name, "hcpxy|^render|Output")) %>% 
  distinct() %>% 
  pull(name) %>% 
  c("highchartProxy", .) %>% 
  unique()

fun_hc_prxy

dfun <- dfun %>%
  filter(!name %in% fun_hc_prxy)

# add ---------------------------------------------------------------------
fun_hc_add <- dfun %>% 
  filter(str_detect(name, "add|^hc_")) %>% 
  distinct() %>% 
  pull(name)

fun_hc_add

dfun <- dfun %>%
  filter(!name %in% fun_hc_add)


# datas -------------------------------------------------------------------
datas <- read_lines("R/data.R") %>% 
  str_subset("\".*\"") %>% 
  str_trim() %>% 
  str_remove_all("\"")

datas 

dfun <- dfun %>%
  filter(!name %in% datas)


# helpers -----------------------------------------------------------------
fun_hc_hpr <- dfun %>% 
  filter(str_detect(name, "data_to|^color|^tooltip_")) %>% 
  distinct() %>% 
  pull(name) %>% 
  c(., "hex_to_rgba", "datetime_to_timestamp", "dt_tstp", "df_to_annotations_labels")

fun_hc_hpr

dfun <- dfun %>%
  filter(!name %in% fun_hc_hpr)

# extras ------------------------------------------------------------------
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
    desc = "Helpers function to add or modify elements, like plugins (as {htmltools} dependencies), events or annotations.",
    contents = fun_hc_add
  ),
  list(
    title = "Add data",
    desc = "Functions to add data from R objects to a highcharts charts.",
    contents = fun_hc_add_series
  ),
  list(
    title = "Data helpers",
    desc = "Function to help manipulate data to use in specific arguments or
    some types of series. For example create valid arguments in `dataClasses`,
    `stops` or `pointFormatter` parameters and create the rigth type of format
    to create treemaps, sunburst or sankey charts.",
    contents = fun_hc_hpr
  ),
  list(
    title = "Shiny and proxy functions",
    desc = "Functions to create highcharts in shinyapps or rmarkdown documents.
    Proxy functions allow you maniupulate a highchart widget from server side in a
    shiny app.",
    contents = fun_hc_prxy
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
  ),
  list(
    title = "Deprecated functions",
    desc = "Functions that will be removed in the next version of the package.",
    contents = fun_hc_dep
  )
)


# write reference ---------------------------------------------------------
write_yaml(x = yml, file = "pkgdown/_pkgdown.yml")

# build reference ---------------------------------------------------------
pkgdown::build_reference_index()
pkgdown::build_reference()
pkgdown::preview_site(path = "/reference")




