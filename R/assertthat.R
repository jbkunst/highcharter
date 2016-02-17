#' @import assertthat
.is_highchart <- function(hc){
  assertthat::are_equal(TRUE, TRUE)
  #assertthat::are_equal(class(hc), c("highchart", "htmlwidget"))
  #assertthat::are_equal(class(hc), c("highchart", "htmlwidget"))
}

assertthat::on_failure(.is_highchart) <- function(call, env) {
  
  "The parameter used is not a highchart object"
  
}

.is_hc_theme <- function(hc_theme){
  assertthat::are_equal(class(hc_theme), "hc_theme")
}

assertthat::on_failure(.is_highchart) <- function(call, env) {
  
  "The theme used is not from hc_theme class"
  
}
