#' @export
hc_add_theme <- function(hc, hc_thm){
  
  assert_that(.is_highchart(hc),
              .is_hc_theme(hc_thm))
  
  hc$x$fonts <- list(unique(c(unlist(hc$x$fonts), .hc_get_fonts(hc_thm))))
  
  hc$x$theme <- hc_thm
  
  hc
  
}

#' @export
hc_theme <- function(...){
  
  structure(list(...), class = "hc_theme")
  
}

#' @importFrom stringr str_replace_all str_replace str_trim
.hc_get_fonts <- function(lst){
  
  unls <- unlist(lst)
  unls <- unls[grepl("fontFamily", names(unls))]
  
  fonts <- unls %>% 
    str_replace_all(",\\s+sans-serif|,\\s+serif", "") %>% 
    str_replace("\\s+", "+") %>% 
    str_trim() %>% 
    unlist()
  
  fonts
  
}
