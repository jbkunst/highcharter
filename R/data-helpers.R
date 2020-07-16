#' Helper to transform data frame in sankey highcharts format
#'
#' @param data A data frame
#'
#' @examples 
#' 
#' library(dplyr) 
#' data(diamonds)
#' 
#' diamonds2 <- select(diamonds, cut, color, clarity)
#' 
#' hchart(data_to_sankey(diamonds2), "sankey", name = "diamonds")
#' 
#'
#' @export
data_to_sankey <- function(data = NULL) {
  
  # numeric to categories
  if(any(unlist(purrr::map(data, class)) %in% c("integer", "numeric"))) {
    
    warning("numeric variables were treated with cut() function")
    data <- dplyr::mutate_if(data, function(x) is.numeric(x) && length(unique(x)) > 10, ~ cut(.x, breaks = c(-Inf, quantile(.x, c(2,4,6,8)/10), Inf)))
    
  }
  
  # combintaion data
  dcmb <- tibble::tibble(
    var1 = names(data),
    var2 = dplyr::lead(var1)
    ) %>%  
    dplyr::filter(complete.cases(.))
  
  # sankey data
  dsnky <- purrr::pmap_df(dcmb, function(var1 = "cut", var2 = "color"){
      
    data %>% 
      select(all_of(var1) , all_of(var2)) %>% 
      group_by_all() %>% 
      count() %>% 
      ungroup() %>% 
      setNames(c("from", "to", "weight")) %>% 
      mutate_if(is.factor, as.character) %>% 
      mutate_at(vars(1, 2), as.character) %>% 
      mutate(id := paste0(from, to))
    
    })
  
  dsnky

}

