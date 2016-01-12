#' Shorcut for create/add time series charts from a ts object
#'
#' This function add a time series to a \code{highchart} object
#' from a \code{ts} object. 
#' 
#' This function \bold{modify} the type of \code{chart} to \code{datetime}
#'  
#' @param hc A \code{highchart} \code{htmlwidget} object. 
#' @param ts A time series object.
#' @param ... Aditional arguments for the data series (\url{http://api.highcharts.com/highcharts#series}).
#' 
#' @examples 
#' 
#' require("dplyr")
#' 
#' highchart() %>% 
#'   hc_title(text = "Monthly Airline Passenger Numbers 1949-1960") %>% 
#'   hc_subtitle(text = "The classic Box and Jenkins airline data") %>% 
#'   hc_add_serie_ts2(AirPassengers, name = "passengers") %>%
#'   hc_tooltip(pointFormat =  '{point.y} passengers')
#' 
#' highchart() %>% 
#'   hc_title(text = "Monthly Deaths from Lung Diseases in the UK") %>% 
#'   hc_add_serie_ts2(fdeaths, name = "Female") %>%
#'   hc_add_serie_ts2(mdeaths, name = "Male")
#'   
#' @importFrom stats is.ts time
#' 
#' @export 
hc_add_serie_ts2 <- function(hc, ts, ...) {
  
  assertthat::assert_that(is.ts(ts), .is_highchart(hc))
  
  # http://stackoverflow.com/questions/29202021/r-how-to-extract-dates-from-a-time-series
  dates <- time(ts) %>% 
    zoo::as.Date()
  
  values <- as.vector(ts)
  
  hc %>% hc_add_serie_ts(values, dates, ...)
    
}

#' Shorcut for create/add time series from values and dates
#'
#' This function add a time series to a \code{highchart} object. 
#' 
#' This function \bold{modify} the type of \code{chart} to \code{datetime}
#'  
#' @param hc A \code{highchart} \code{htmlwidget} object. 
#' @param values A numeric vector
#' @param dates  A date vector (same length as \code{values})
#' @param ... Aditional arguments for the data series (\url{http://api.highcharts.com/highcharts#series}).
#' 
#' @examples 
#' 
#' \dontrun{
#' 
#' require("ggplot2")
#' data(economics, package = "ggplot2")
#' 
#' hc_add_serie_ts(hc = highchart(),
#'                 values = economics$psavert, dates = economics$date,
#'                 name = "Personal Savings Rate")
#' }
#' 
#' @importFrom zoo as.Date
#' 
#' @export 
hc_add_serie_ts <- function(hc, values, dates, ...) {
  
  assertthat::assert_that(.is_highchart(hc), is.numeric(values), is.date(dates))
  
  timestamps <- dates %>% 
    zoo::as.Date() %>%
    as.POSIXct() %>% 
    as.numeric()
  
  # http://stackoverflow.com/questions/10160822/handling-unix-timestamp-with-highcharts  
  timestamps <- 1000 * timestamps
  
  ds <- list.parse2(data.frame(timestamps, values))
  
  hc %>% 
    hc_xAxis(type = "datetime") %>% 
    hc_add_serie(marker = list(enabled = FALSE), data = ds, ...)
  
}

#' Shorcut for create scatter plots
#'
#' This function helps to create scatter plot from two numerics vectors. Options
#' argumets like size, color and label for points are added. 
#' 
#' @param hc A \code{highchart} \code{htmlwidget} object. 
#' @param x A numeric vector. 
#' @param y A numeric vector. Same length of \code{x}.
#' @param z A numeric vector for size. Same length of \code{x}.
#' @param color A vector to color the points.
#' @param label A vector to put names in the dots if you enable the datalabels.
#' @param showInLegend Logical value to show or not the data in the legend box.
#' @param viridis.option Palette to use in case the \code{color}. Argument can not
#'   be \code{NULL} in the case of use \code{color} argument.
#'  Options are A, B, C, D.
#' @param ... Aditional shared arguments for the data series 
#'   (\url{http://api.highcharts.com/highcharts#series}).
#' 
#' @examples 
#' 
#' require("dplyr")
#' 
#' hc <- highchart() %>% 
#'   hc_title(text = "Motor Trend Car Road Tests") %>% 
#'   hc_xAxis(title = list(text = "Weight")) %>% 
#'   hc_yAxis(title = list(text = "Miles/gallon"))
#'    
#' hc_add_serie_scatter(hc, mtcars$wt, mtcars$mpg)
#' 
#' hc_add_serie_scatter(hc, mtcars$wt, mtcars$mpg,
#'                      mtcars$drat)
#'                      
#' hc_add_serie_scatter(hc, mtcars$wt, mtcars$mpg,
#'                      mtcars$drat, mtcars$cyl)
#'                      
#' hc_add_serie_scatter(hc, mtcars$wt, mtcars$mpg,
#'                      mtcars$drat, mtcars$hp,
#'                      rownames(mtcars),
#'                      dataLabels = list(
#'                        enabled = TRUE,
#'                        format = "{point.label}"
#'                        )) %>% 
#' hc_chart(zoomType = "xy") %>% 
#' hc_tooltip(useHTML = TRUE,
#'            headerFormat = "<table>",
#'            pointFormat = paste("<tr><th colspan=\"2\"><h3>{point.label}</h3></th></tr>",
#'                                "<tr><th>Weight</th><td>{point.x} lb/1000</td></tr>",
#'                                "<tr><th>MPG</th><td>{point.y} mpg</td></tr>",
#'                                "<tr><th>Drat</th><td>{point.z} </td></tr>",
#'                                "<tr><th>HP</th><td>{point.valuecolor} hp</td></tr>"),
#'            footerFormat = "</table>")
#' 
#' @importFrom dplyr mutate group_by do select data_frame
#' @import magrittr
#' @importFrom viridisLite viridis
#' @importFrom stats ecdf
#' 
#' @export 
hc_add_serie_scatter <- function(hc, x, y, z = NULL, color = NULL, label = NULL,
                                 showInLegend = FALSE, viridis.option = "D", ...) {
  
  assertthat::assert_that(.is_highchart(hc), length(x) == length(y),
                          is.numeric(x), is.numeric(y))
  
  df <- data_frame(x, y)
  
  if (!is.null(z)) {
    assert_that(length(x) == length(z))
    df <- df %>% mutate(z = z)
  }
  
  if (!is.null(color)) {
    
    assert_that(length(x) == length(color))
    assert_that(viridis.option %in% c("A", "B", "C", "D"))
    
    colorvar <- color
    
    if (!is.numeric(colorvar))
      colorvar <- as.numeric(as.factor(colorvar))
    
    cols <- viridisLite::viridis(1000, option = viridis.option)[round(ecdf(colorvar)(colorvar)*1000)]
    
    if (is.null(z))
      cols <- substr(cols, 0, 7)
    
    df <- df %>% mutate(valuecolor = color,
                        color = cols)
  }
  
  if (!is.null(label)) {
    assert_that(length(x) == length(label))
    df <- df %>% mutate(label = label)
  }
  
  ds <- setNames(rlist::list.parse(df), NULL)
  
  type <- ifelse(!is.null(z), "bubble", "scatter")
  
  hc %>% hc_add_serie(data = ds, type = type, showInLegend = showInLegend, ...)
  
}

#' Shorcut for add series for pie, bar and column charts
#'
#' This function add data to plot pie, bar and column charts.
#' 
#' @param hc A \code{highchart} \code{htmlwidget} object. 
#' @param labels A vector of labels. 
#' @param values A numeric vector. Same length of \code{labels}.
#' @param colors A not required color vector (hexadecimal format). Same length of \code{labels}.
#' @param ... Aditional shared arguments for the data series 
#'   (\url{http://api.highcharts.com/highcharts#series}).
#' 
#' @examples 
#' 
#' require("dplyr")
#' 
#' data("favorite_bars")
#' data("favorite_pies")
#' 
#' highchart() %>% 
#'   hc_title(text = "This is a bar graph describing my favorite pies
#'                    including a pie chart describing my favorite bars") %>%
#'   hc_subtitle(text = "In percentage of tastiness and awesomeness") %>% 
#'   hc_add_serie_labels_values(favorite_pies$pie, favorite_pies$percent, name = "Pie",
#'                              colorByPoint = TRUE, type = "column") %>% 
#'   hc_add_serie_labels_values(favorite_bars$bar, favorite_bars$percent,
#'                              colors = substr(terrain.colors(5), 0 , 7), type = "pie",
#'                              name = "Bar", colorByPoint = TRUE, center = c('35%', '10%'),
#'                              size = 100, dataLabels = list(enabled = FALSE)) %>% 
#'   hc_yAxis(title = list(text = "percentage of tastiness"),
#'            labels = list(format = "{value}%"), max = 100) %>% 
#'   hc_xAxis(categories = favorite_pies$pie) %>% 
#'   hc_legend(enabled = FALSE) %>% 
#'   hc_tooltip(pointFormat = "{point.y}%")
#' 
#' 
#' @export
hc_add_serie_labels_values <- function(hc, labels, values, colors = NULL, ...) {
  
  assertthat::assert_that(.is_highchart(hc),
                          is.numeric(values),
                          length(labels) == length(values))

  df <- data_frame(name = labels, y = values)
  
  if (!is.null(colors)) {
    assert_that(length(labels) == length(colors))
    
    df <- mutate(df, color = colors)
    
  }
  
  ds <- setNames(rlist::list.parse(df), NULL)
  
  hc <- hc %>% hc_add_serie(data = ds, ...)
  
  hc
                      
}

#' Shorcut for create treemaps
#'
#' This function helps to create hicharts treemaps from \code{treemap} objects
#' from the package \code{treemap}.
#' 
#' @param hc A \code{highchart} \code{htmlwidget} object. 
#' @param tm A \code{treemap} object from the treemap package.
#' @param ... Aditional shared arguments for the data series
#'   (\url{http://api.highcharts.com/highcharts#series}).
#' 
#' @examples 
#' 
#' \dontrun{
#' 
#' library("treemap")
#' library("viridis")
#' 
#' data(GNI2010)
#' head(GNI2010)
#' 
#' tm <- treemap(GNI2010, index = c("continent", "iso3"),
#'               vSize = "population", vColor = "GNI",
#'               type = "comp", palette = rev(viridis(6)),
#'               draw = FALSE)
#' 
#' highchart(height = 800) %>% 
#'   hc_add_serie_treemap(tm, allowDrillToNode = TRUE,
#'                        layoutAlgorithm = "squarified",
#'                        name = "tmdata") %>% 
#'    hc_title(text = "Gross National Income World Data") %>% 
#'    hc_tooltip(pointFormat = "<b>{point.name}</b>:<br>
#'                              Pop: {point.value:,.0f}<br>
#'                              GNI: {point.valuecolor:,.0f}")
#' 
#' }
#' 
#' @importFrom dplyr filter_ mutate_ rename_ select_ tbl_df
#' @importFrom plyr ldply
#' @importFrom purrr map_if map
#' 
#' @export 
hc_add_serie_treemap <- function(hc, tm, ...) {
  
  assertthat::assert_that(.is_highchart(hc),
                          is.list(tm))
  
  df <- tm$tm %>% 
    tbl_df() %>% 
    select_("-x0", "-y0", "-w", "-h", "-stdErr", "-vColorValue") %>% 
    rename_("value" = "vSize", "valuecolor" = "vColor") %>% 
    purrr::map_if(is.factor, as.character) %>% 
    data.frame(stringsAsFactors = FALSE) %>% 
    tbl_df()
  
  ndepth <- which(names(df) == "value") - 1
  
  ds <- ldply(seq(ndepth), function(lvl){ # lvl <- sample(seq(ndepth), size = 1)
    
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
  
  ds <- setNames(rlist::list.parse(ds), NULL)
  
  ds <- map(ds, function(x){
    if (is.na(x$parent))
      x$parent <- NULL
    x
  })
  
  hc %>% hc_add_serie(data = ds, type = "treemap", ...)
  
}
