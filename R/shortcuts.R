. <- NULL
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
#' \dontrun{
#' 
#' library("magrittr")
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
#' }
#' 
#' @import zoo
#' 
#' @importFrom stats is.ts time
#' 
#' @export 
hc_add_serie_ts2 <- function(hc, ts, ...) {
  
  assert_that(is.ts(ts),
              .is_highchart(hc))
  
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
#' data(economics, package = "ggplot2")
#' 
#' hc_add_serie_ts(highchart(),
#'                 economics$psavert, economics$date,
#'                 name = "Personal Savings Rate")
#'  
#' }
#' 
#' @import zoo
#' 
#' @export 
hc_add_serie_ts <- function(hc, values, dates, ...) {
  
  assert_that(.is_highchart(hc), 
              is.numeric(values),
              is.date(dates))
  
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
#' This function helps to create scatter plot from two numerics vectors.
#' 
#' @param hc A \code{highchart} \code{htmlwidget} object. 
#' @param x A numeric vector. 
#' @param y A numeric vector. Same length of \code{x}.
#' @param group A vector to split the (x,y) pairs (similiar to fill/color in ggplot).
#' @param ... Aditional shared arguments for the data series (\url{http://api.highcharts.com/highcharts#series}).
#' 
#' @examples 
#' 
#' \dontrun{
#' 
#' highchart() %>% 
#'   hc_add_serie_scatter(cars$speed, cars$dist)
#'    
#' highchart() %>% 
#'   hc_add_serie_scatter(mtcars$wt, mtcars$mpg, mtcars$cyl) %>% 
#'   hc_title(text = "Motor Trend Car Road Tests") %>% 
#'   hc_xAxis(title = list(text = "Weight")) %>% 
#'   hc_yAxis(title = list(text = "Miles/gallon")) %>% 
#'   hc_tooltip(headerFormat = "<b>{series.name} cylinders</b><br>",
#'              pointFormat = "{point.x} (lb/1000), {point.y} (miles/gallon)")
#' 
#' }
#' 
#' @importFrom dplyr mutate group_by do select data_frame
#' 
#' @export 
hc_add_serie_scatter <- function(hc, x, y, group = NULL, ...) {
  
  assert_that(.is_highchart(hc),
              is.numeric(x),
              is.numeric(y),
              length(x) == length(y))
  
  df <- data_frame(x, y)
  
  if (!is.null(group)) {
    
    assert_that(length(x) == length(group))
    
    dss <- df %>%
      mutate(group = group) %>% 
      group_by(group) %>% 
      do(
        type = "scatter",
        data = list.parse2(data_frame(.$x, .$y)),
        name = unique(as.character(.$group))
      ) %>% select(-group)
    
    hc$x$hc_opts$series <- append(hc$x$hc_opts$series, list.parse2(dss))
    
  } else {
    
    dss <- list.parse2(df)
    
    # hc$x$hc_opts$series <- list(list(data = dss, type = "scatter"))
    hc <- hc %>% hc_add_serie(data = dss, type = "scatter", ...)
    
  }
  
  hc 
  
}

#' Shorcut for add series for pie, bar and column charts
#'
#' This function add label value delete the actual series in the object and change the \code{chart}
#' type to \code{scatter}.
#' 
#' @param hc A \code{highchart} \code{htmlwidget} object. 
#' @param labels A vector of labels. 
#' @param values A numeric vector. Same length of \code{labels}.
#' @param colors A not required color vector (hexadecimal format). Same length of \code{labels}.
#' @param ... Other parameters for data series.
#' 
#' @examples 
#' 
#' \dontrun{
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
#' }
#' 
#' @export
hc_add_serie_labels_values <- function(hc, labels, values, colors = NULL, ...) {
  
  assert_that(.is_highchart(hc),
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

#' Shorcut for create treemaps ####
#'
#' This function helps to create hicharts treemaps from \code{treemap} objects
#' from the package \code{treemap}.
#' 
#' @param hc A \code{highchart} \code{htmlwidget} object. 
#' @param tm A \code{treemap} object
#' @param ... Aditional shared arguments for the data series (\url{http://api.highcharts.com/highcharts#series}).
#' 
#' @examples 
#' 
#' \dontrun{
#' 
#' library("treemap")
#' library("magrittr")
#' library("viridis")
#' 
#' data(GNI2010)
#' head(GNI2010)
#' 
#' tm <- treemap(GNI2010, index = c("continent", "iso3"),
#'               vSize = "population", vColor = "GNI",
#'               type = "comp", palette = rev(viridis(6)))
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
#' 
#' @importFrom dplyr filter_ mutate_ rename_ select_ tbl_df
#' @importFrom plyr ldply
#' 
#' @export 
hc_add_serie_treemap <- function(hc, tm, ...) {
  
  assert_that(.is_highchart(hc),
              is.list(tm))
  
  df <- tm$tm %>% 
    tbl_df() %>% 
    select_("-x0", "-y0", "-w", "-h", "-stdErr", "-vColorValue") %>% 
    rename_("value" = "vSize", "valuecolor" = "vColor") %>% 
    purrr::map_if(is.factor, as.character)
  
  ndepth <- which(names(df) == "value") - 1
  
  ds <- ldply(seq(ndepth), function(lvl){ # lvl <- sample(size = 1, seq(ndepth))
    
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
  
  ds <- purrr::map(ds, function(x){
    if (is.na(x$parent))
      x$parent <- NULL
    x
  })
  
  hc %>% hc_add_serie(data = ds, type = "treemap", ...)
  
}
