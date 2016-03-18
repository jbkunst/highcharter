# hc <- hc_demo()
# library("jsonlite")
# library("stringr")
#  library("purrr")
#hc <- readRDS("~/hcgross1.rds")

#' Function to export to jsfiddle
#' @param hc A \code{A highcarts object}
#' @param filename A string
#' @importFrom jsonlite toJSON
#' @importFrom stringr str_split str_c str_detect
#' @export 
export_hc <- function(hc, filename = NULL) {
  
  stopifnot(!is.null(filename))
  
  if (!str_detect(filename, ".js$"))
    filename <- str_c(filename, ".js")
  . <- ""
  # http://lisperator.net/uglifyjs/walk
  # hc$x$hc_opts$series[3:10000] <- NULL
  hc$x$hc_opts %>% 
    toJSON(pretty = TRUE, auto_unbox = TRUE, force = TRUE) %>% 
    str_split("\n") %>% 
    .[[1]] %>% 
    str_replace("\"", "") %>% 
    str_replace("\":", ":") %>% 
    {
      ifelse(str_detect(., "function()"), str_replace(., "\"function", "function"), .)  
    } %>% 
    {
      ifelse(str_detect(., "function()"), str_replace(., "\",$", ","), .)  
    } %>%
    map(function(x){
      if (str_detect(x, "function()"))
        x <- str_split(x, "\\\\n") %>% unlist()
      x
    }) %>% 
    unlist() %>%
    tail(-1) %>% 
    str_c("    ", ., collapse = "\n") %>% 
    sprintf("$(function () {\n  $('#container').highcharts({\n%s\n  );\n});", .) %>% 
    writeLines(filename)
  
}

