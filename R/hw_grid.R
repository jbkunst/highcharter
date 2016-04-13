#' Lays out highchart widgets into a "grid", similar to
#' \code{grid.arrange} from \code{gridExtra}
#'
#' @param ... either individual \code{highchart} objects or a mixture of
#'     individual \code{highchart} objects
#' and \code{list}s of \code{highchart} objects.
#' @param ncol how many columns in the grid
#' @importFrom grDevices n2mfrow
#' @export
hw_grid <- function(..., ncol = NULL, rowheight = NULL) {
  
  input_list <- as.list(substitute(list(...)))[-1L]
  
  params <- list()
  
  for (i in 1:length(input_list)) {
    x <- eval.parent(input_list[[i]])
    if (any(class(x) == "list")) {
      for (j in 1:length(x)) {
        y <- eval(x[[j]])
        params[[length(params) + 1]] <- y
      }
    } else {
      params[[length(params) + 1]] <- x
    }
  }
  
  if (!all(sapply(params, function(x) { inherits(x, "htmlwidget") })))
    stop("All parameters must be htmlwidget objects")
  
  if (is.null(ncol))
    ncol <- n2mfrow(length(params))[1]
  
  if (ncol > 12)
    ncol <- 12
  
  # mobile?
  ncolm <- floor(ncol/2)
  
  divs <- map(params, function(x){
    
    x$width <- "100%"
    
    if (!is.null(rowheight))
      x$height <- rowheight

    tags$div(class = sprintf("col-1-%s mobile-col-1-%s", ncol, ncolm), x)
    
  })
  
  divgrid <- tags$div(class = "grid grid-pad", style = "with:100%", divs)
  
  class(divgrid) <- c(class(divgrid), "htmlwdwtgrid")
  # htmltools::browsable(divgrid)
  divgrid
  
}

#' @importFrom htmltools browsable
#' @export
print.htmlwdwtgrid <- function(x){
  browsable(x)
}
