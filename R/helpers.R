#' Convert an object to list with identical structure
#'
#' This function is similiar to \code{rlist::list.parse} but this removes names. 
#' 
#' @param df A data frame to 
#' 
#' @export
list.parse2 <- function(df) {
  
  setNames(apply(df, 1, function(r) as.list(as.vector(r))), NULL)
  
}
