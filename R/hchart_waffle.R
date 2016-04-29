#' Function to create  waffle charts
#' 
#' @param labels A character vector
#' @param counts A integer vector
#' @param rows A integer to set 
#' @param icons A character vector same length (o length 1) as labels
#' @param size Font size
#' 
#' @examples
#' 
#' hchart_waffle(c("nice", "good"), c(10, 20))
#' 
#' hchart_waffle(c("nice", "good"), c(10, 20), size = 10)
#' 
#' hchart_waffle(c("nice", "good"), c(100, 200), icons = "child")
#' 
#' hchart_waffle(c("car", "truck", "plane"), c(50, 20, 10), icons = c("car", "truck", "plane"))
#' 
#' @importFrom dplyr ungroup arrange desc group_by_
#' @export
hchart_waffle <- function(labels, counts, rows = NULL, icons = NULL, size = 4){

  # library(dplyr);library(purrr)
  # data(diamonds, package = "ggplot2")
  # cnts <- count(diamonds, cut) %>%
  #   mutate(n = n/sum(n)*500,
  #          n = round(n)) %>%
  #   arrange(desc(n))
  # labels <- cnts$cut
  # counts <- cnts$n
  # size <- 4; icon <- "diamond"

  assertthat::assert_that(length(counts) == length(labels))
  
  hc <- highchart() 
  
  if (is.null(rows)) {
    
    sizegrid <- n2mfrow(sum(counts))
    w <- sizegrid[1] 
    h <- sizegrid[2]   
    
  } else {
    
    h <- rows
    w <- ceiling(sum(counts)/rows)
    
  }
  
  ds <- data_frame(x = rep(1:w, h), y = rep(1:h, each = w)) %>% 
    head(sum(counts)) %>% 
    mutate_("y" = "-y") %>% 
    mutate(gr = rep(seq_along(labels), times = counts)) %>% 
    left_join(data_frame(gr = seq_along(labels), name = as.character(labels)), by = "gr") %>% 
    group_by_("name") %>% 
    do(data = list.parse2(data_frame(.$x, .$y))) %>% 
    ungroup() %>% 
    left_join(data_frame(labels = as.character(labels), counts), by = c("name" = "labels")) %>% 
    arrange(desc(counts)) 
  
  if (!is.null(icons)) {
    
    assertthat::assert_that(length(icons) %in% c(1, length(labels)))
    
    dsmrk <- ds %>% 
      mutate(iconm = icons) %>% 
      group_by_("name") %>% 
      do(marker = list(symbol = fa_icon_mark(.$iconm)))
    
    ds <- ds %>% 
      left_join(dsmrk, by = "name") %>% 
      mutate(icon = fa_icon(icons))
      
  }
  
  hc <- hc %>% 
    hc_chart(type = "scatter") %>% 
    hc_add_series_list(list.parse3(ds)) %>% 
    hc_plotOptions(series = list(marker = list(radius = size))) %>% 
    hc_tooltip(pointFormat = "{point.series.options.counts}") %>%
    hc_add_theme(hc_theme_null())
  
  
  hc
  
  
}
