#' Function to create  waffle charts
#' 
#' @param labels A character vector
#' @param counts A integer vector
#' @param rows A integer to set 
#' @param icon A string
#' @param size Font size
#' @importFrom purrr transpose
#' @importFrom dplyr ungroup arrange desc group_by_
#' @export
hchart_waffle <- function(labels, counts, rows = NULL, icon = NULL, size = NULL){

  # data(diamonds, package = "ggplot2")
  # cnts <- count(diamonds, cut) %>%
  #   mutate(n = n/sum(n)*500,
  #          n = round(n)) %>%
  #   arrange(desc(n))
  # labels <- cnts$cut
  # counts <- cnts$n

  sizegrid <- n2mfrow(sum(counts))
  
  w <- sizegrid[1] 
  h <- sizegrid[2] 
  
  
  ds <- data_frame(x = rep(1:w, h), y = rep(1:h, each = w)) %>% 
    head(sum(counts)) %>% 
    mutate_("y" = "-y") %>% 
    mutate(gr = rep(seq_along(labels), times = counts)) %>% 
    left_join(data_frame(gr = seq_along(labels), name = as.character(labels)), by = "gr") %>% 
    group_by_("name") %>% 
    do(data = list.parse2(data_frame(.$x, .$y))) %>% 
    ungroup() %>% 
    left_join(data_frame(labels = as.character(labels), counts), by = c("name" = "labels")) %>% 
    arrange(desc(counts)) %>% 
    map(function(x) x) %>% 
    transpose()

  highchart() %>% 
    hc_chart(type = "scatter") %>% 
    hc_add_series_list(ds) %>% 
    hc_add_theme(hc_theme_null())
  
}
