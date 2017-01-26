#' Shortcut to make a bar chart
#' @param x A character or factor vector.
#' @param ... Additional arguments for the data series \url{http://api.highcharts.com/highcharts#series}.
#' @export
hcbar <- function(x, ...) {
  stopifnot(is.character(x) | is.factor(x))
  hchart(x, ...)
}

#' Shortcut to make a pie chart
#' @param x A character o factor vector.
#' @param ... Additional arguments for the data series \url{http://api.highcharts.com/highcharts#series}.
#' @export
hcpie <- function(x, ...) {
  stopifnot(is.character(x) | is.factor(x))
  hchart(x, type = "pie", ...)
}

#' Shortcut to make an histogram
#' @param x A numeric vector.
#' @param ... Additional arguments for the data series \url{http://api.highcharts.com/highcharts#series}.
#' @export
hchist <- function(x, ...) {
  stopifnot(is.numeric(x))
  hchart(x, ...)
}

#' Shortcut to make time series or line charts
#' @param x A numeric vector or a time series object.
#' @param ... Additional arguments for the data series \url{http://api.highcharts.com/highcharts#series}.
#' @importFrom stats as.ts
#' @export
hcts <- function(x, ...) {
  hchart(as.ts(x), ...)
}

#' Shortcut to make density charts
#' @param x A numeric vector or a density object.
#' @param ... Additional arguments for the data series \url{http://api.highcharts.com/highcharts#series}.
#' @importFrom stats density
#' @export
hcdensity <- function(x, ...) {
  
  stopifnot(inherits(x, "density") || inherits(x, "numeric"))
  
  if (class(x) == "numeric")
    x <- density(x)
  
  hchart(x, ...)
  
}

#' Shortcut to make spkarlines
#' @param x A numeric vector.
#' @param type Type sparkline: line, bar, etc.
#' @param ... Additional arguments for the data series \url{http://api.highcharts.com/highcharts#series}.
#' 
#' @examples
#' 
#' set.seed(123)
#' x <- cumsum(rnorm(10))
#' 
#' hcspark(x) 
#' hcspark(x, "columnn")
#' hcspark(c(1, 4, 5), "pie")
#' hcspark(x, type = "area")
#'    
#' @export
hcspark <- function(x = NULL, type = NULL, ...) {
  stopifnot(is.numeric(x))
  highchart() %>% 
    hc_plotOptions(
      series = list(showInLegend = FALSE, dataLabels = list(enabled = FALSE)),
      line = list(marker = list(enabled = FALSE))) %>% 
    hc_add_series(data = x, type = type, ...) %>% 
    hc_add_theme(hc_theme_sparkline())
}

#' Shortcut to make a boxplot
#' @param x A numeric vector.
#' @param var A string vector same length of x.
#' @param var2 A string vector same length of x.
#' @param outliers A boolean value to show or not the outliers.
#' @param ... Additional arguments for the data series \url{http://api.highcharts.com/highcharts#series}.
#' @examples 
#' hcboxplot(x = iris$Sepal.Length, var = iris$Species, color = "red")
#' @importFrom dplyr rename_ data_frame_
#' @importFrom tidyr unnest
#' @export
hcboxplot <- function(x = NULL, var = NULL, var2 = NULL, outliers = TRUE, ...) {
  
  stopifnot(is.numeric(x))
  
  if (is.null(var))
    var <- NA
  if (is.null(var2))
    var2 <- NA
  
  df <- data_frame(x, g1 = var, g2 = var2)
  
  get_box_values <- function(x){ 
    
    boxplot.stats(x)$stats %>% 
      t() %>% 
      as.data.frame() %>% 
      setNames(c("low", "q1", "median", "q3", "high"))
    
  }
  
  get_outliers_values <- function(x) {
    boxplot.stats(x)$out
  }
  
  series_box <- df %>%
    group_by_("g1", "g2") %>%  
    do(data = get_box_values(.$x)) %>% 
    unnest() %>% 
    group_by_("g2") %>% 
    do(data = list_parse(rename_(select_(., "-g2"), "name" = "g1"))) %>% 
    # rename(name = g2) %>% 
    mutate(type = "boxplot") %>% 
    mutate_("id" = "as.character(g2)")
  
  if (length(list(...)) > 0)
    series_box <- add_arg_to_df(series_box, ...)
  
  series_out <- df %>% 
    group_by_("g1", "g2") %>%  
    do(data = get_outliers_values(.$x)) %>% 
    unnest() %>% 
    group_by_("g2") %>% 
    do(data = list_parse(select_(., "name" = "g1", "y" = "data"))) %>% 
    # rename(name = g2) %>% 
    mutate(type = "scatter") %>% 
    mutate("linkedTo" = "as.character(g2)")
  
  if (length(list(...)) > 0)
    series_out <- add_arg_to_df(series_out, ...)
  
  if (!has_name(list(...), "color")) {
    colors <- colorize(seq(1, nrow(series_box)))
    colors <- hex_to_rgba(colors, alpha = 0.75)  
  }
  
  if (!has_name(list(...), "name")) {
    series_box <- rename_(series_box, "name" = "g2")
    series_out <- rename_(series_out, "name" = "g2")
  }
  
  
  hc <- highchart() %>% 
    hc_chart(type = "bar") %>% 
    # hc_colors(colors) %>% 
    hc_xAxis(type = "category") %>% 
    hc_plotOptions(series = list(
      marker = list(
        symbol = "circle"
      )
    )) 
  
  hc <- hc_add_series_list(hc, list_parse(series_box))
  
  if(is.na(var2) || is.na(var)) {
    hc <- hc %>% 
      hc_xAxis(categories = "") %>% 
      hc_plotOptions(series = list(showInLegend = FALSE))
  }
  
  
  if(outliers)
    hc <- hc_add_series_list(hc, list_parse(series_out))
  
  hc
}


#' Shortcut to make icon arrays charts
#' @param labels A character vector
#' @param counts A integer vector
#' @param rows A integer to set 
#' @param icons A character vector same length (o length 1) as labels
#' @param size Font size
#' @param ... Additional arguments for the data series \url{http://api.highcharts.com/highcharts#series}.
#' @examples
#' 
#' hciconarray(c("nice", "good"), c(10, 20))
#' 
#' hciconarray(c("nice", "good"), c(10, 20), size = 10)
#' 
#' hciconarray(c("nice", "good"), c(100, 200), icons = "child")
#' 
#'  hciconarray(c("car", "truck", "plane"), c(75, 30, 20), icons = c("car", "truck", "plane")) %>%
#'    hc_add_theme(
#'      hc_theme_merge(
#'        hc_theme_flatdark(),
#'        hc_theme_null(chart = list(backgroundColor = "#34495e"))
#'      )
#'    )
#' 
#' @importFrom dplyr ungroup group_by_
#' @export
hciconarray <- function(labels, counts, rows = NULL, icons = NULL, size = 4,
                        ...){
  
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
    arrange_("-counts") %>% 
    mutate_("percent" = "counts/sum(counts)*100")
  
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
  
  ds <- mutate(ds, ...)
  
  hc <- highchart()  %>% 
    hc_chart(type = "scatter") %>% 
    hc_add_series_list(ds) %>% 
    hc_plotOptions(series = 
                     list(
                       cursor = "default",
                       marker = list(radius = size),
                       states = list(hover = list(enabled = FALSE)),
                       events = list(
                         legendItemClick = JS("function () { return false; }")
                       )
                     )) %>%  
    hc_tooltip(pointFormat = "{point.series.options.counts} ({point.series.options.percent:.2f}%)") %>%
    hc_add_theme(
      hc_theme_merge(
        getOption("highcharter.theme"),
        hc_theme_null()
        )
      )
  hc
  
}

#' Shortcut for create treemaps
#'
#' This function helps to create highcharts treemaps from \code{treemap} objects
#' from the package \code{treemap}.
#' 
#' @param tm A \code{treemap} object from the treemap package.
#' @param ... Additional shared arguments for the data series
#'   (\url{http://api.highcharts.com/highcharts#series}).
#' 
#' @examples 
#'  
#' \dontrun{
#' 
#' library("treemap")
#' library("viridis")
#' 
#' data(GNI2014)
#' head(GNI2014)
#' 
#' tm <- treemap(GNI2014, index = c("continent", "iso3"),
#'               vSize = "population", vColor = "GNI",
#'               type = "comp", palette = rev(viridis(6)),
#'               draw = FALSE)
#' 
#' hctreemap(tm, allowDrillToNode = TRUE, layoutAlgorithm = "squarified") %>% 
#'    hc_title(text = "Gross National Income World Data") %>% 
#'    hc_tooltip(pointFormat = "<b>{point.name}</b>:<br>
#'                              Pop: {point.value:,.0f}<br>
#'                              GNI: {point.valuecolor:,.0f}")
#' 
#' }
#' 
#' @importFrom dplyr filter_ mutate_ rename_ select_ tbl_df
#' @importFrom purrr map map_df map_if 
#' 
#' @export 
hctreemap <- function(tm, ...) {
  
  assertthat::assert_that(is.list(tm))
  
  df <- tm$tm %>% 
    tbl_df() %>% 
    select_("-x0", "-y0", "-w", "-h", "-stdErr", "-vColorValue") %>% 
    rename_("value" = "vSize", "valuecolor" = "vColor") %>% 
    purrr::map_if(is.factor, as.character) %>% 
    data.frame(stringsAsFactors = FALSE) %>% 
    tbl_df()
  
  ndepth <- which(names(df) == "value") - 1
  
  ds <- map_df(seq(ndepth), function(lvl) {
    
    # lvl <- sample(seq(ndepth), size = 1)
    
    df2 <- df %>% 
      filter_(sprintf("level == %s", lvl)) %>% 
      rename_("name" = names(df)[lvl]) %>% 
      mutate_("id" = "highcharter::str_to_id(name)")
    
    if (lvl > 1) {
      df2 <- df2 %>% 
        mutate_("parent" = names(df)[lvl - 1],
                "parent" = "highcharter::str_to_id(parent)")
    } else {
      df2 <- df2 %>% 
        mutate_("parent" = NA)
    }
    
    df2 
    
  })
  
  ds <- list_parse(ds)
  
  ds <- map(ds, function(x){
    if (is.na(x$parent))
      x$parent <- NULL
    x
  })
  
  hc_add_series(highchart(), data = ds, type = "treemap", ...)
  
}

#' Shortcut for create parallel coordinates
#' @param df A data frame object.
#' @param ... Additional shared arguments for the data series
#'   (\url{http://api.highcharts.com/highcharts#series}) for the
#'   \code{hchar.data.frame} function.
#' @examples 
#' require(viridisLite)
#' 
#' n <- 15
#' 
#' hcparcords(head(mtcars, n), color = hex_to_rgba(magma(n), 0.5))
#' 
#' require(dplyr)
#' data(iris)
#' set.seed(123)
#' 
#' iris <- sample_n(iris, 60)
#' 
#' hcparcords(iris, color = colorize(iris$Species))
#' @importFrom purrr dmap_if
#' @export
hcparcords <- function(df, ...) {
  
  stopifnot(is.data.frame(df))
  
  # df <- mtcars
  # df <- mpg
  
  rescale01 <- function(x) {
    rng <- range(x, na.rm = TRUE)
    (x - rng[1]) / (rng[2] - rng[1])
  }
  
  df <- df[map_lgl(df, is.numeric)]
  
  # Add row identifier
  df <- rownames_to_column(df, ".row")
  
  df <- dmap_if(df, is.numeric, rescale01)
  
  df <- tidyr::gather_(df, "var", "val", setdiff(names(df), ".row"))
  
  hchart(df, "line", hcaes_(x = "var", y = "val", group = ".row"), ...) %>% 
    hc_plotOptions(series = list(showInLegend = FALSE)) %>% 
    hc_yAxis(min = 0, max = 1) %>% 
    hc_tooltip(sort = TRUE, table = TRUE, valueDecimals = 2) 
  
}



