# reference:
#   - title: "Connecting to Spark"
#    desc: >
#       Functions for installing Spark components and managing
#       connections to Spark
#     contents: 
#       - spark_config
#       - spark_connect
#       - spark_disconnect
#       - spark_install
#       - spark_log
#   - title: "Reading and Writing Data"
#     desc: "Functions for reading and writing Spark DataFrames."
#     contents:
#       - starts_with("spark_read")
#       - starts_with("spark_write")
#       - matches("saveload")

library(tidyverse)

pkgdown::template_reference()

make_reference_section <- function(ttle, desc, funs) {
  
  yml <- c(
    paste0("  - title: \"", ttle, "\""),
    paste0("    desc: \"", desc, "\""),
    "    contents:",
    str_c("      - '`", funs, "`'")
  )
  
  cat(paste(yml, collapse = "\n"))
  
   yml
  
}

# data
ttle <- "Data for examples"
desc <- "Various data frames to play and have fun with highcharter."
funs <- dir("data/") %>% 
  str_remove_all(".rda")

# theme
ttle <- ""
desc <- "Functions for create and add themes"
funs <- ""
  




