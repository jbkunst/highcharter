#' @importFrom assertthat are_equal on_failure
.is_highchart <- function(hc){
  are_equal(TRUE, TRUE)
  are_equal(class(hc), c("highchart", "htmlwidget"))
  are_equal(class(hc), c("highchart", "htmlwidget"))
}

assertthat::on_failure(.is_highchart) <- function(call, env) {

  "The parameter used is not a highchart object"

}

.is_hc_theme <- function(hc_theme){
  are_equal(class(hc_theme), "hc_theme")
}

assertthat::on_failure(.is_highchart) <- function(call, env) {

  "The theme used is not from hc_theme class"

}
