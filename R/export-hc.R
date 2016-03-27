. <- NULL
#' Function to export js file the configuration options
#' @param hc A \code{A highcarts object}
#' @param filename A string 
#' 
#' @examples 
#' 
#' fn <- "function(){
#'   console.log('Category: ' + this.category);
#'   alert('Category: ' + this.category);
#' }"
#' 
#' hc <- hc_demo() %>% 
#'   hc_plotOptions(
#'     series = list(
#'       cursor = "pointer",
#'         point = list(
#'           events = list(
#'             click = JS(fn)
#'          )
#'        )
#'    )
#'  )
#' 
#' @importFrom jsonlite toJSON
#' @importFrom stringr str_split str_c str_detect
#' @importFrom utils head
#' @export 
export_hc <- function(hc, filename = NULL) {
  
  # filename <- "~/tets.js"
  # load("~/hc.Rdata")
  stopifnot(!is.null(filename))
  
  if (!str_detect(filename, ".js$"))
    filename <- str_c(filename, ".js")

  jslns <- hc$x$hc_opts %>% 
    toJSON(pretty = TRUE, auto_unbox = TRUE, force = TRUE) %>% 
    str_split("\n") %>% 
    head(1) %>%
    unlist() %>% 
    str_replace('"', "") %>% 
    str_replace("\":", ":")
  
  # function thing 
  fflag <- str_detect(jslns, "function()")
  if (any(fflag)) {
    jslns <- ifelse(fflag, str_replace(jslns, "\"function", "function"), jslns)  
    jslns <- ifelse(fflag, str_replace(jslns, "\",$", ","), jslns)
    jslns <- ifelse(fflag, str_replace(jslns, "\"$", ""), jslns)
    jslns <- ifelse(fflag,
                    str_replace_all(jslns, "\\\\n", str_c("\\\\n", str_extract(jslns, "^\\s+") )),
                    jslns)  
  }
  
  jslns <- jslns %>% 
    # str_split("\\\\n") %>% 
    unlist() %>% 
    tail(-1) %>% 
    str_c("    ", ., collapse = "\n") %>%
    str_replace_all("\n\\s{4,}\\]\\,\n\\s{4,}\\[\n\\s{4,}", "],[") %>% 
    sprintf("$(function () {\n  $('#container').highcharts({\n%s\n  );\n});", .)
  
    writeLines(jslns, filename)
  
}

