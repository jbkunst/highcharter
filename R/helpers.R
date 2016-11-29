#' Convert an object to list with identical structure
#'
#' This functions are similiar to \code{rlist::list.parse} but this removes
#' names.
#' 
#' @param df A data frame to parse to list
#' 
#' @examples 
#' 
#' x <- data.frame(a=1:3, type=c('A','C','B'), stringsAsFactors = FALSE)
#' 
#' list_parse(x)
#' 
#' list_parse2(x)
#' 
#' @importFrom purrr transpose
#' @export
list_parse <- function(df) {
  
  assertthat::assert_that(is.data.frame(df))
  
  map_if(df, is.factor, as.character) %>% 
    as_data_frame() %>% 
    list.parse() %>% 
    setNames(NULL)
  
}

#' @importFrom rlist list.parse
#' @rdname list_parse  
#' @export 
list_parse2 <- function(df) {
  
  assertthat::assert_that(is.data.frame(df))
  
  list_parse(df) %>% 
    map(setNames, NULL)
  
}

#' @rdname list_parse  
#' @export 
list.parse2 <- function(df) {
  
  .Deprecated("list_parse2")
  
  list_parse2(df) 
}

#' @rdname list_parse  
#' @export 
list.parse3 <- function(df) {
  
  .Deprecated("list_parse")
  
  list_parse(df) 
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
  
  assertthat::assert_that(is.character(x) | is.factor(x))
  
  x %>% 
    as.character() %>% 
    str_trim() %>%
    str_to_lower() %>% 
    str_replace_all("\\s+", "_") %>% 
    str_replace_all("\\\\|/", "_") %>% 
    str_replace_all("\\[|\\]", "_") %>% 
    str_replace_all("_+", "_") %>% 
    str_replace_all("_$|^_", "")
  
}

#' Date to Timesstamps
#' 
#' Turn a date time vector to \code{timestamp} format
#' 
#' @param dt Date or datetime vector
#' 
#' @examples 
#' 
#' datetime_to_timestamp(
#'   as.Date(c("2015-05-08", "2015-09-12"),
#'   format = "%Y-%m-%d"))
#' 
#' @export
datetime_to_timestamp <- function(dt) {
  
  # http://stackoverflow.com/questions/10160822/
  assertthat::assert_that(assertthat::is.date(dt) | assertthat::is.time(dt))
  
  tmstmp <- as.numeric(as.POSIXct(dt))
  
  tmstmp <- 1000 * tmstmp
  
  tmstmp
  
}

#' Transform colors from hexadeximal format to rgba hc notation
#' 
#' @param x colors in hexadecimal format
#' @param alpha alpha 
#' 
#' @examples 
#' 
#' hex_to_rgba(x <- c("#440154", "#21908C", "#FDE725"))
#' 
#'
#' @importFrom grDevices col2rgb
#' @importFrom tidyr unite_
#' @export
hex_to_rgba <- function(x, alpha = 1) {
  
  x %>% 
    col2rgb() %>% 
    t() %>% 
    as.data.frame() %>% 
    unite_(col = "rgba", from = c("red", "green", "blue"), sep = ",") %>% 
    .[[1]] %>% 
    sprintf("rgba(%s,%s)", ., alpha)
  
}  

#' Get dash styles
#'
#' Get dash style to use on highcharts objects.
#' 
#' 
#' @export
dash_styles <- function() {
  
  .Deprecated()
  
  c("Solid", "ShortDash", "ShortDot", "ShortDashDot", "ShortDashDotDot",
    "Dot", "Dash", "LongDash", "DashDot", "LongDashDot", "LongDashDotDot")
  
}

#' Chart a demo for testing themes
#'
#' Chart a demo for testing themes
#' 
#' @examples 
#' 
#' highcharts_demo()
#' 
#' @export
highcharts_demo <- function() {

  dtemp <- structure(
    list(
      month = c("Jan", "Feb", "Mar", "Apr", "May", "Jun",
                "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"),
      tokyo = c(7, 6.9,  9.5, 14.5, 18.2, 21.5,
                25.2, 26.5, 23.3, 18.3, 13.9, 9.6),
      new_york = c(-0.2,  0.8, 5.7, 11.3, 17, 22, 
                   24.8, 24.1, 20.1, 14.1, 8.6, 2.5),
      berlin = c(-0.9,  0.6, 3.5, 8.4, 13.5, 17,
                 18.6, 17.9, 14.3, 9, 3.9, 1),
      london = c(3.9,  4.2, 5.7, 8.5, 11.9, 15.2,
                 17, 16.6, 14.2, 10.3, 6.6, 4.8)),
    .Names = c("month", "tokyo", "new_york", "berlin", "london"),
    row.names = c(NA, 12L ), class = c("tbl_df", "tbl", "data.frame"))
  
  highchart() %>% 
    hc_title(text = "Monthly Average Temperature") %>% 
    hc_subtitle(text = "Source: WorldClimate.com") %>% 
    hc_yAxis(title = list(text = "Temperature")) %>% 
    hc_xAxis(title = list(text = "Months")) %>% 
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
#' @param x A numeric, character or factor object.
#' @param colors A character string of colors (ordered) to colorize \code{x}
#' @examples 
#' 
#' colorize(runif(10))
#' 
#' colorize(LETTERS[rbinom(20, 5, 0.5)], c("#FF0000", "#00FFFF"))
#' 
#' @importFrom grDevices colorRampPalette
#' @importFrom stats ecdf
#' @export
colorize <- function(x, colors = c("#440154", "#21908C", "#FDE725")) {
  
  nuniques <- length(unique(x))
  palcols <- grDevices::colorRampPalette(colors)(nuniques)
  
  if (!is.numeric(x) | nuniques < 10) {
    
    y <- as.numeric(as.factor(x))
    xcols <- palcols[y]
    
  } else {
    
    ecum <- ecdf(x)
    xcols <- palcols[ceiling(nuniques * ecum(x))]
    
  }
  
  xcols
  
}

#' Create vector of color from vector
#' 
#' @param x A numeric, character or factor object.
#' @param option A character string indicating the colormap option to use.
#' 
#' @importFrom viridisLite viridis
#' @importFrom stringr str_sub
#' @export
colorize_vector <- function(x, option = "D") {
  
  .Deprecated("colorize")
  
  nunique <- length(unique(x))
  
  if (!is.numeric(x) | nunique < 10) {
    
    bcol <- str_sub(viridis(nunique, option = option), 0, 7)
    y <- as.numeric(as.factor(x))
    cols <- bcol[y]
    
  } else {
    
    nc <- 1000
    
    bcol <- str_sub(viridis(nc, option = option), 0, 7)
    ecum <- ecdf(x)
    
    cols <- bcol[round(nc * ecum(x))]
    
  }
  
  cols
  
}

#' Function to create \code{stops} argument in \code{hc_colorAxis}
#' 
#' @param n A numeric indicating how much quantiles generate.
#' @param colors A character string of colors (ordered)
#' 
#' @examples
#' 
#' color_stops(5)
#' 
#' @export
color_stops <- function(n = 10, colors = c("#440154", "#21908C", "#FDE725")) {
  
  palcols <- grDevices::colorRampPalette(colors)(n)
  
  list_parse2(
    data.frame(
      q = seq(0, n - 1) / (n - 1),
      c = palcols
      )
    )
}

#' Function to create \code{dataClasses} argument in \code{hc_colorAxis}
#' 
#' @param breaks A numeric vector 
#' @param colors A character string of colors (ordered)
#' 
#' @examples
#' 
#' color_classes(c(0, 10, 20, 50))
#' 
#' @export
color_classes <- function(breaks = NULL,
                          colors = c("#440154", "#21908C", "#FDE725")) {
  
  lbrks <- length(breaks)
  
  list_parse(
    data.frame(
      from = breaks[-lbrks],
      to = breaks[-1],
      color = grDevices::colorRampPalette(colors)(lbrks - 1),
      stringsAsFactors = FALSE
    )
  )
  
}

#' Auxiliar function to get series and options from tidy frame for hchart.data.frame
#' 
#' This function is used in hchart.data.frame and hc_add_series_df
#' 
#' @param data A \code{data.frame} object.
#' @param type The type of chart. Possible values are line, scatter, point, column.
#' @param ... Aesthetic mappings as \code{x y group color low high}.
#' 
#' @examples 
#' 
#' get_hc_series_from_df(iris, type = "point", x = Sepal.Width)
#' 
#' @importFrom tibble has_name
#' @export
get_hc_series_from_df <- function(data, type = NULL, ...) {
  
  assertthat::assert_that(is.data.frame(data))
  stopifnot(!is.null(type))
  
  pars <- eval(substitute(alist(...)))
  parsc <- map(pars, as.character)
  
  data <- mutate(data, ...)
  data <- ungroup(data)
  
  # check type
  type <- ifelse(type == "point", "scatter", type)
  type <- ifelse("size" %in% names(data) & type == "scatter", "bubble", type)
  
  # heatmap
  if (type == "heatmap") {
    if (!is.numeric(data[["x"]])) {
      data[["xf"]] <- as.factor(data[["x"]])
      data[["x"]] <- as.numeric(as.factor(data[["x"]])) - 1
    }
    if (!is.numeric(data[["y"]])) {
      data[["yf"]] <- as.factor(data[["y"]])
      data[["y"]] <- as.numeric(as.factor(data[["y"]])) - 1
    }
  }
  
  # x
  if (has_name(parsc, "x")) {
    if (is.Date(data[["x"]])) {
      data[["x"]] <- datetime_to_timestamp(data[["x"]])
      
    } else if (is.character(data[["x"]]) | is.factor(data[["x"]])) {
      data[["name"]] <- data[["x"]]
      data[["x"]] <- NULL
    } 
  }
  
  # color
  if (has_name(parsc, "color")) {
    if (type == "treemap") {
      data <- rename_(data, "colorValue" = "color")
    } else {
      data  <- mutate_(data, "colorv" = "color",
                       "color" = "highcharter::colorize(color)")  
    }
  }
  
  # size
  if (has_name(parsc, "size") & type %in% c("bubble", "scatter"))
    data <- mutate_(data, "z" = "size")
  
  # group 
  if (!has_name(parsc, "group"))
    data[["group"]] <- "Series"
  
  data[["charttpye"]] <- type
  
  dfs <- data %>% 
    group_by_("group", "charttpye") %>% 
    do(data = list_parse(select_(., quote(-group), quote(-charttpye)))) %>% 
    ungroup() %>% 
    rename_("name" = "group", "type" = "charttpye")
  
  if (!has_name(parsc, "group"))
    dfs[["name"]] <- NULL
  
  series <- list_parse(dfs)
  
  series
  
}

#' Check if a string vector is in hexadecimal color format
#' 
#' @param x A string vectors
#' 
#' @examples 
#' 
#' x <- c("#f0f0f0", "#FFf", "#99990000", "#00FFFFFF")
#' 
#' is.hexcolor(x)
#' 
#' are.hexcolor(x)
#' @export
is.hexcolor <- function(x) {
  
  assertthat::assert_that(is.character(x))
  
  pattern <- "^#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3}|[A-Fa-f0-9]{8})$"
  
  str_detect(x, pattern)
  
}

#' @rdname is.hexcolor
#' @export
are.hexcolor <- function(x) {
  
  all(is.hexcolor(x))
  
}

#' Function to generate iids
#' @param n Number of ids
#' @param length Length of ids
#' @export
random_id <- function(n = 1, length = 10){
  
  source <- c(seq(0, 9), letters)
  
  replicate(n, paste0(sample(x = source, size = length, replace = TRUE), collapse = ""))
  
}

#' Function to avoid the jsonlite::auto_unbox default
#' @param x And element, numeric or character
#' @export
fix_1_length_data <- function(x) {
  
  if(getOption("highcharter.verbose"))
    message("fix_1_length")
  
  if(class(x) != "list" & length(x) == 1)
    x <- list(x)
  x
}


