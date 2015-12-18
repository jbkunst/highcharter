.is_highchart <- function(hc){
  are_equal(class(hc), c("highchart", "htmlwidget"))
}

assertthat::on_failure(.is_highchart) <- function(call, env) {
  
  "The parameter is not a highchart object"
  
}
