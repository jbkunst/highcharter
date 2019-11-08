# packages ----------------------------------------------------------------
library(yaml)
library(tidyverse)

# data --------------------------------------------------------------------
yml <- yaml::read_yaml("pkgdown/_pkgdown.yml")

dfun <- help.search("*", package = "highcharter") %>%
  .$matches %>% tbl_df() %>%
  janitor::clean_names() %>% 
  select(name, title) %>% 
  distinct()



# funs --------------------------------------------------------------------
fun_hc_api <- read_lines("R/highcharts-api.R") %>% 
  str_subset(" <- function") %>% 
  str_remove(" <-.*")

fun_hc_thm <- dfun %>% 
  filter(str_detect(name, "theme")) %>% 
  distinct() %>% 
  pull(name)

fun_hc_add <- dfun %>% 
  filter(str_detect(name, "add_series")) %>% 
  distinct() %>% 
  pull(name)

datas <- read_lines("R/data.R") %>% 
  str_subset("\".*\"") %>% 
  str_trim() %>% 
  str_remove_all("\"")
  

# gen reference -----------------------------------------------------------
yml[["reference"]] <- list(
  list(
    title = "Highcharts API",
    desc = "Functions to access the highcharts API and modify charts",
    contents = fun_hc_api
  ),
  list(
    title = "Add data",
    desc = "Functions to add data from R objects to a highcharts charts",
    contents = fun_hc_add
  ),
  list(
    title = "Themes",
    desc = "Functions to customize the look of your chart",
    contents = fun_hc_thm
  ),
  list(
    title = "Data",
    desc = "Data for examples",
    contents = datas
  )
)


# write reference ---------------------------------------------------------
write_yaml(x = yml, file = "pkgdown/_pkgdown.yml")


# build reference ---------------------------------------------------------
pkgdown::build_reference_index()



