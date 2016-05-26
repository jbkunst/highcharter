#' Shorcut for tidy data frame
#' 
#' @param hc A \code{highchart} \code{htmlwidget} object.
#' @param data data.frame with data.
#' @param categories bare column name of categories (one for every series)
#' @param values bare column name of values
#' 
#' @examples 
#' 
#' dat <- data.frame("id" = c(1,2,3,4,5,6), 
#'        "grp" = c("A","A","B","B","C","C"),
#'        "value" = c(10,13,9,15,11,16))
#' 
#' highchart() %>% 
#'  hc_chart(type = "column") %>% 
#'  hc_tidy_series(data = dat, categories = grp, values = value)
#'   
#' @export
hc_tidy_series <- function(hc, data, categories, values, ...){
  if("highchart" %in% class(hc)){}else{stop("hc must be highchart object")}
  if("data.frame" %in% class(data)){}else{stop("data must be data.frame or coerse object")}
  # make sure
  data <- as.data.frame(data)
  
  arguments <- as.list(match.call())
  cats <- eval(arguments$categories, data)
  
  n <- length(unique(as.character(cats)))
  if(n>0){
    for(i in 1:n){
      nm <- as.character(unique(cats)[i])
      dat <- eval(arguments$values, data)
      dat <- dat[cats == nm]
      
      hc <- hc_add_serie(hc, 
                         name = nm, 
                         data = dat, ...)
      
    }
  }else{
    return(hc)
  }
  return(hc)
}
