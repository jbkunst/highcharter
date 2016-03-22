#' Convert an object to list with identical structure
#'
#' This function is similiar to \code{rlist::list.parse} but this removes names. 
#' 
#' @param df A data frame to parse to list
#' 
#' @examples 
#' 
#' x <- data.frame(a=1:3,type=c('A','C','B'), stringsAsFactors = FALSE)
#' 
#' list.parse2(x)
#' 
#' list.parse3(x)
#' 
#' @export
list.parse2 <- function(df) {
  
  assertthat::assert_that(is.data.frame(df))
  
  res <- apply(df, 1, function(r) as.list(as.vector(r)))
  
  names(res) <- NULL
  
  res
  
}

#' @importFrom rlist list.parse
#' @rdname list.parse2  
#' @export 
list.parse3 <- function(df) {
  
  assertthat::assert_that(is.data.frame(df))
  
  res <- list.parse(df)
  
  names(res) <- NULL
  
  res
  
}

#' String to 'id' format
#' 
#' Turn a string to \code{id} format used in treemaps.
#' 
#' @param x A vector string.
#' 
#' @examples 
#' 
#' str_to_id(" A string _ with sd / sdg    Underscores \   ")
#' 
#' @importFrom stringr str_to_lower str_replace_all
#' @export
str_to_id <- function(x) {
  
  assertthat::assert_that(is.character(x))
  
  x %>% 
    str_trim() %>%
    str_to_lower() %>% 
    str_replace_all("\\s+", "_") %>% 
    str_replace_all("\\\\|/", "_") %>% 
    str_replace_all("\\[|\\]", "_") %>% 
    str_replace_all("_+", "_") %>% 
    str_replace_all("_$|^_", "") %>% 
    iconv("latin1", "ASCII", sub = "")
  
}

#' Date to Timesstamps
#' 
#' Turn a date time vector to \code{timestamp} format
#' 
#' @param dt Date or datetime vector
#' 
#' @examples 
#' 
#' datetime_to_timestamp(dt = as.Date(c("2015-05-08", "2015-09-12"), format = "%Y-%m-%d"))
#' 
#' @export
datetime_to_timestamp <- function(dt) {
  
  # http://stackoverflow.com/questions/10160822/handling-unix-timestamp-with-highcharts 
  assertthat::assert_that(assertthat::is.date(dt) | assertthat::is.time(dt))
  
  tmstmp <- dt %>% 
    as.POSIXct(dt) %>% 
    as.numeric() 
  
  tmstmp <- 1000 * tmstmp
  
  tmstmp
  
}

#' Get default colors for Highcharts theme
#'
#' Get color used in highcharts charts.
#' 
#' @examples 
#' 
#' hc_get_colors()[1:5]
#' 
#' @export
hc_get_colors <- function() {
  
  c("#7cb5ec", "#434348", "#90ed7d", "#f7a35c", "#8085e9",
    "#f15c80", "#e4d354", "#2b908f", "#f45b5b", "#91e8e1")
  
}

#' Transform colors from hexadeximal format to rgba hc notation
#' 
#' @param x colors in hexadecimal format
#' @param alpha alpha 
#' 
#' @examples 
#' 
#' hex_to_rgba(x <- hc_get_colors())
#' 
#'
#' @importFrom grDevices col2rgb
#' @importFrom tidyr unite_
#' @export
hex_to_rgba <- function(x, alpha = 1) {
  
  rgba <- x %>% 
    col2rgb() %>% 
    t() %>% 
    as.data.frame() %>% 
    unite_(col = "rgba", from = c("red", "green", "blue") , sep = ",")
  
  sprintf("rgba(%s,%s)", rgba[["rgba"]], alpha)
  
}  

#' Get dash styles
#'
#' Get dash style to use on highcharts objects.
#' 
#' @examples 
#' 
#' hc_get_dash_styles()[1:5]
#' 
#' @export
hc_get_dash_styles <- function() {
  
  c("Solid", "ShortDash", "ShortDot", "ShortDashDot", "ShortDashDotDot",
    "Dot", "Dash", "LongDash", "DashDot", "LongDashDot", "LongDashDotDot")
  
}

#' Chart a demo for testing themes
#'
#' Chart a demo for testing themes
#' 
#' @examples 
#' 
#' hc_demo()
#' 
#' @export
hc_demo <- function() {

  dtemp <- structure(
    list(month = c("Jan", "Feb", "Mar", "Apr", "May", "Jun",  "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"),
         tokyo = c(7, 6.9,  9.5, 14.5, 18.2, 21.5, 25.2, 26.5, 23.3, 18.3, 13.9, 9.6),
         new_york = c(-0.2,  0.8, 5.7, 11.3, 17, 22, 24.8, 24.1, 20.1, 14.1, 8.6, 2.5),
         berlin = c(-0.9,  0.6, 3.5, 8.4, 13.5, 17, 18.6, 17.9, 14.3, 9, 3.9, 1),
         london = c(3.9,  4.2, 5.7, 8.5, 11.9, 15.2, 17, 16.6, 14.2, 10.3, 6.6, 4.8)),
    .Names = c("month", "tokyo", "new_york", "berlin", "london"),
    row.names = c(NA, 12L ), class = c("tbl_df", "tbl", "data.frame"))
  
  highchart() %>% 
    hc_title(text = "Monthly Average Temperature") %>% 
    hc_subtitle(text = "Source: WorldClimate.com") %>% 
    hc_yAxis(title = list(text = "Temperature")) %>% 
    hc_xAxis(categories = dtemp$month) %>% 
    hc_add_series(name = "Tokyo", data = dtemp$tokyo) %>% 
    hc_add_series(name = "London", data = dtemp$london) %>% 
    hc_add_series(name = "Berlin", data = dtemp$berlin) 
  
}

#' Helpers functions to get FontAwesome icons code
#'
#' Helpers functions to get FontAwesome icons code
#'
#' @param iconname The icon's name
#'
#' @examples
#'
#' fa_icon("car")
#'
#' @export
fa_icon <- function(iconname = "circle") {
  
  faicos <- readRDS(system.file("extdata/faicos.rds", package = "highcharter"))

  stopifnot(iconname %in% faicos$name)

  sprintf("<i class=\"fa fa-%s\"></i>", iconname)
}

#' @rdname fa_icon
#'
#' @examples
#'
#' fa_icon_mark("car")
#'
#' fa_icon_mark(iconname = c("car", "plane", "car"))
#'
#' @export
fa_icon_mark <- function(iconname = "circle"){
  
  faicos <- readRDS(system.file("extdata/faicos.rds", package = "highcharter"))
  
  stopifnot(all(iconname %in% faicos$name))

  idx <- purrr::map_int(iconname, function(icn) which(faicos$name %in% icn))

  cod <- faicos$code[idx]

  # this is for the plugin: need the text:code to parse
  paste0("text:", cod)

}

#' Helper for make table in tooltips 
#' 
#' Helper to make table in tooltips for the \code{pointFormat}
#' parameter in \code{hc_tooltip}
#'
#' @param x A string vector with description text
#' @param y A string with accesors ex: \code{point.series.name}, 
#'   \code{point.x}
#' @param title A title tag with accessor or string
#' @param img Img tag
#' @param ... html attributes for the table element
#' 
#' @examples 
#' 
#' x <- c("Income:", "Genre", "Runtime")
#' y <- c("$ {point.y}", "{point.series.options.extra.genre}",
#'        "{point.series.options.extra.runtime}")
#' 
#' tooltip_table(x, y)
#' 
#' @importFrom purrr map2
#' @importFrom htmltools tags tagList
#' @export
tooltip_table <- function(x, y,
                          title = NULL,
                          img = NULL, ...) {
  
  assertthat::assert_that(length(x) == length(y))
  
  tbl <- map2(x, y, function(x, y){
    tags$tr(
      tags$th(x),
      tags$td(y)
    )
  })
  
  tbl <- tags$table(tbl, ...)
  
  if (!is.null(title))
    tbl <- tagList(title, tbl)
  
  if (!is.null(img))
    tbl <- tagList(tbl, img)
  
  as.character(tbl) 
  
}

#' Create vector of color from vector
#' 
#' Using viridis
#' 
#' @param x A numeric, character or factor vector.
#' @param option A character string indicating the colormap option to use.
#' 
#' @examples
#' x <- runif(50)
#' colorize_vector(x)
#' 
#' x <- sample(letters[1:4], size = 20, replace = TRUE)
#' colorize_vector(x)
#' 
#' @importFrom viridisLite viridis
#' @importFrom stats ecdf
#' @importFrom stringr str_sub
#' @export
colorize_vector <- function(x, option = "D") {
  
  nunique <- length(unique(x))
  
  if (!is.numeric(x) | nunique < 10) {
    
    bcol <- str_sub(viridis(nunique, option = option), 0, 7)
    y <- as.numeric(as.factor(x))
    cols <- bcol[y]
    
  } else {
    
    nc <- 1000
    
    bcol <- str_sub(viridis(nc, option = option), 0, 7)
    ecum <- ecdf(x)
    
    cols <- bcol[round(nc*ecum(x))]
    
  }
  
  cols
  
}
