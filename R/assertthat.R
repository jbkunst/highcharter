#' @importFrom assertthat are_equal on_failure assert_that
.is_hc_theme <- function(hc_theme) {
  are_equal(class(hc_theme), "hc_theme")
}

assertthat::on_failure(.is_hc_theme) <- function(call, env) {
  "The theme used is not from hc_theme class"
}
