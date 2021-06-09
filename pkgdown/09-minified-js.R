# install.packages("js")
library(js)
library(purrr)
library(stringr)

files_js <- dir("docs/", pattern = ".js$", recursive = TRUE)

files_js <- files_js %>% 
  str_subset("delay.js", negate = TRUE) %>% 
  str_subset("highcharts-regression.js", negate = TRUE) %>% 
  str_subset("docsearch.js|bootstrap", negate = TRUE)

walk(files_js, function(f =  "articles/highcharts_files/highcharts-9.1.0/plugins/draggable-legend.js"){
  
  cat(f)
  cat("\n")
  
  readLines(fs::path("docs", f)) %>% 
    js::uglify_optimize() %>% 
    writeLines(fs::path("docs", f))
  
})

