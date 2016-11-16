#' Shorcut to make a bar chart
#' @param x A character or factor vector.
#' @param ... Aditional arguments for the data series (http://api.highcharts.com/highcharts#series).
#' @export
hcbar <- function(x, ...) {
  stopifnot(is.character(x) | is.factor(x))
  hchart(x, ...)
}

#' Shorcut to make a pie chart
#' @param x A character o factor vector.
#' @param ... Aditional arguments for the data series (http://api.highcharts.com/highcharts#series).
#' @export
hcpie <- function(x, ...) {
  stopifnot(is.character(x) | is.factor(x))
  hchart(x, type = "pie", ...)
}

#' Shorcut to make an histogram
#' @param x A numeric vector.
#' @param ... Aditional arguments for the data series (http://api.highcharts.com/highcharts#series).
#' @export
hchist <- function(x, ...) {
  stopifnot(is.numeric(x))
  hchart(x, ...)
}

#' Shorcut to make time series or line charts
#' @param x A numeric vector or a time series object.
#' @param ... Aditional arguments for the data series (http://api.highcharts.com/highcharts#series).
#' @importFrom stats as.ts
#' @export
hcts <- function(x, ...) {
  hchart(as.ts(x), ...)
}

#' Shorcut to make density charts
#' @param x A numeric vector or a density object.
#' @param ... Aditional arguments for the data series (http://api.highcharts.com/highcharts#series).
#' @importFrom stats density
#' @export
hcdensity <- function(x, ...) {
  
  stopifnot(inherits(x, "density") || inherits(x, "numeric"))
  
  if(class(x) == "numeric")
    x <- density(x)
  
  hchart(x, ...)
  
}

#' Shorcut to make spkarlines
#' @param x A numeric vector.
#' @param type Type sparkline: line, bar, etc.
#' @param ... Aditional arguments for the data series (http://api.highcharts.com/highcharts#series).
#' 
#' @examples
#' 
#' set.seed(123)
#' x <- cumsum(rnorm(10))
#' 
#' hcspark(x) 
#' hcspark(x, "column")
#' hcspark(c(1, 4, 5), "pie")
#' hcspark(x, type = "area")
#'    
#' @export
hcspark <- function(x = NULL, type = NULL, ...) {
  stopifnot(is.numeric(x))
  highchart() %>% 
    hc_plotOptions(
      series = list(showInLegend = FALSE),
      line = list(marker = list(enabled = FALSE))) %>% 
    hc_add_series(data = x, type = type, ...) %>% 
    hc_add_theme(hc_theme_sparkline())
}

#' Shortcut to make a boxplot
#' @param x A numeric vector.
#' @param by A string vector same length of x.
#' @param outliers A boolean value to show or not the outliers.
#' @param horizontal A boolean value indicating if the boxplots should be horizontal.
#' @param ... Aditional arguments for the data series (http://api.highcharts.com/highcharts#series).
#' @export
hcboxplot <- function(x, by = NULL, outliers = TRUE, horizontal = TRUE, ...) {
  stopifnot(is.numeric(x))
  hc <- highchart()
  if (is.null(by))
    hc <- hc_add_series_boxplot(hc, x, outliers = outliers, ...)
  else
    hc <- hc_add_series_boxplot(hc, x, by = by, outliers = outliers, ...)
  
  if (horizontal)
    hc <- hc_chart(hc, type = "bar")
  
  hc
  
}

#' Shorcut to make waffle charts
#' @param labels A character vector
#' @param counts A integer vector
#' @param rows A integer to set 
#' @param icons A character vector same length (o length 1) as labels
#' @param size Font size
#' 
#' @examples
#' 
#' hcwaffle(c("nice", "good"), c(10, 20))
#' 
#' hcwaffle(c("nice", "good"), c(10, 20), size = 10)
#' 
#' hcwaffle(c("nice", "good"), c(100, 200), icons = "child")
#' 
#' hcwaffle(c("car", "truck", "plane"), c(75, 30, 20), icons = c("car", "truck", "plane"))
#' 
#' @importFrom dplyr ungroup group_by_
#' @export
hcwaffle <- function(labels, counts, rows = NULL, icons = NULL, size = 4){
  
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
    w <- ceiling(sum(counts) / rows)
    
  }
  
  ds <- data_frame(x = rep(1:w, h), y = rep(1:h, each = w)) %>% 
    head(sum(counts)) %>% 
    mutate_("y" = "-y") %>% 
    mutate(gr = rep(seq_along(labels), times = counts)) %>% 
    left_join(data_frame(gr = seq_along(labels), name = as.character(labels)),
              by = "gr") %>% 
    group_by_("name") %>% 
    do(data = list_parse2(data_frame(.$x, .$y))) %>% 
    ungroup() %>% 
    left_join(data_frame(labels = as.character(labels), counts),
              by = c("name" = "labels")) %>% 
    arrange_("-counts") 
  
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
    hc_add_series_list(list_parse(ds)) %>% 
    hc_plotOptions(series = list(marker = list(radius = size))) %>% 
    hc_tooltip(pointFormat = "{point.series.options.counts}") %>%
    hc_add_theme(hc_theme_null())
  
  hc
  
}
