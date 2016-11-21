library(tidyverse)
library(lubridate)
library(highcharter)
# do_cbind ----------------------------------------------------------------
add_ellipsis_to_dataframe <- function(data, ...) {
  
  datal <- as.list(data)
  
  l <- map_if(list(...), function(x) is.list(x), list)
  
  datal <- append(datal, l)
  
  as_data_frame(datal)

}

add_ellipsis_to_dataframe(head(mtcars), algo = 4, otracosa = 1:6)
# add_ellipsis_to_dataframe(head(mtcars), algo = 4, otracosa = 1:5)
s <- add_ellipsis_to_dataframe(head(mtcars), algo = 4, otracosa = 1:6, l = list(a = 3, otra = TRUE))

s$l[[1]]

# hcaes -------------------------------------------------------------------
hcaes <- function (x, y, ...) {
  mapping <- structure(as.list(match.call()[-1]), class = "uneval")
  mapping <- mapping[names(mapping) != ""]
  class(mapping) <- c("hcaes", class(mapping))
  mapping
}

hcaes(hp)
hcaes(hp, disp)
(mapping <- hcaes(hp, disp^2, color = wt))
hcaes(hp, disp, color, group = g, blue)
names(mapping)


# mutate_mapping ----------------------------------------------------------
mutate_mapping <- function(data, mapping) {
  
  stopifnot(is.data.frame(data), inherits(mapping, "hcaes"))
  
  # http://rmhogervorst.nl/cleancode/blog/2016/06/13/NSE_standard_evaluation_dplyr.html
  mutate_call <- mapping %>% 
    as.character() %>% 
    map(function(x) paste("~ ", x)) %>% 
    map(as.formula) %>% 
    map(lazyeval::interp)
  
  mutate_(data, .dots = mutate_call)
  
}

# data_to_series ----------------------------------------------------------
data_to_series <- function(data, mapping, type, ...) {
  
  # check type and fix
  type <- ifelse(type == "point", "scatter", type)
  type <- ifelse((has_name(mapping, "size") | has_name(mapping, "z")) & type == "scatter",
                 "bubble", type)
  
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
  if (has_name(mapping, "x")) {
    if (is.Date(data[["x"]])) {
      data[["x"]] <- datetime_to_timestamp(data[["x"]])
      
    } else if (is.character(data[["x"]]) | is.factor(data[["x"]])) {
      data[["name"]] <- data[["x"]]
      data[["x"]] <- NULL
    } 
  }
  
  # color
  if (has_name(mapping, "color")) {
    
    if (type == "treemap") {
      data <- rename_(data, "colorValue" = "color")
    } else {
      data  <- mutate_(data, "colorv" = "color",
                       "color" = "highcharter::colorize(color)")  
    }
  } else if (has_name(data, "color")) {
    data <- rename_(data, "colorv" = "color")
  }
  
  # size
  if (type %in% c("bubble", "scatter")) {
    
    if(has_name(mapping, "size"))
      data <- mutate_(data, "z" = "size")
    
  }
    
  
  message("fix ended"); print(data)
  
  # group 
  if (!has_name(mapping, "group"))
    data[["group"]] <- "group"
  
  message("add group"); print(data)
  
  data <- data %>% 
    group_by_("group") %>% 
    do(data = list_parse(select_(., quote(-group)))) %>% 
    ungroup()
  
  message("make group"); print(data)
  
  data$type <- type
  
  message("add type"); print(data)
  

  if(length(list(...)) > 0)
    data <- add_ellipsis_to_dataframe(data, ...)

  message("add ..."); print(data)
  
  if(has_name(mapping, "group"))
      data <- rename_(data, "name" = "group")

  message("remove name if no group"); print(data)
  
  series <- list_parse(data)
  
  # 
  
  
  series
  
}

# get_options_from_mapping ------------------------------------------------
get_options_from_mapping <- function(data, mapping, type) {
  
  opts <- list()
  
  # x
  if (has_name(mapping, "x")) {
    if (is.Date(data[["x"]])) {
      opts$xAxis_type <- "datetime"
    } else if (is.character(data[["x"]]) | is.factor(data[["x"]])) {
      opts$xAxis_type <- "category"
    } else {
      opts$xAxis_type <- "linear"
    }
  }
  
  # y
  if (has_name(mapping, "x")) {
    if (is.Date(data[["y"]])) {
      opts$yAxis_type <- "datetime"
    } else if (is.character(data[["y"]]) | is.factor(data[["y"]])) {
      opts$yAxis_type <- "category"
    } else {
      opts$yAxis_type <- "linear"
    }
  }  
  
  # showInLegend
  opts$series_plotOptions_showInLegend <- "group" %in% names(data)
  
  # colorAxis
  opts$add_colorAxis <- 
    (type == "treemap" & "color" %in% names(data)) | (type == "heatmap")
  
  # series marker enabled
  opts$series_marker_enabled <- !(type %in% c("line", "spline"))
  
  # heatmap
  if (type == "heatmap") {
    if (!is.numeric(data[["x"]])) {
      opts$xAxis_categories <- levels(as.factor(data[["x"]]))
    }
    if (!is.numeric(data[["y"]])) {
      opts$yAxis_categories <- levels(as.factor(data[["y"]]))
    }
  }
  
  opts
  
}





# tests -------------------------------------------------------------------
mapping <- hcaes(hp, disp^2, color = wt)
data <- tbl_df(head(mtcars))
data

mutate_mapping(data, hcaes(hp, disp^2, color = wt))
mutate_mapping(data, hcaes(hp, disp, color, group = gear, blue))

data <- mutate_mapping(data, mapping)
data_to_series(data, mapping, "scatter")

# data <- mtcars %>% sample_n(10) %>% tbl_df()
data <- mtcars %>% tbl_df()

highchart() %>% 
  hc_add_series(data = data, type = "point", mapping = hcaes(x = hp, y = disp),
                name = "Some points")

highchart() %>% 
  hc_add_series(data = data, mapping = hcaes(x = hp, y = disp, size = wt),
                type = "point", name = "Some Bubbles", showInLegend = FALSE)

highchart() %>% 
  hc_add_series(data = data, type = "bubble", mapping = hcaes(x = hp, y = disp, group = gear),
                showInLegend = c(T, F, T), var = list(othervar = 4, hey = 10))

highchart() %>% 
  hc_add_series(data = data, type = "scatter", mapping = hcaes(x = hp, y = disp, group = gear))


highchart() %>% 
  hc_add_series(data = data, type = "scatter", mapping = hcaes(x = hp, y = disp, group = gear),
                dataLabels = list(enabled = TRUE))

highchart() %>% 
  hc_add_series(data = data, type = "scatter", mapping = hcaes(x = hp, y = disp, z = gear),
                dataLabels = list(enabled = TRUE))

highchart() %>% 
  hc_add_series(data = data, type = "scatter", mapping = hcaes(x = hp, y = disp, size = gear),
                dataLabels = list(enabled = TRUE))

highchart() %>% 
  hc_add_series(data = data, type = "scatter", mapping = hcaes(x = hp, y = disp, z = gear, group = cyl),
                dataLabels = list(enabled = TRUE))

# hchart2 -----------------------------------------------------------------
hchart.data.frame <- function(object, type = NULL, mapping = hcaes(), ...) {
  
  highchart() %>%
    hc_add_series(data = object, type = type, mapping = mapping, ...)
  
}

hchart(AirPassengers, dataLabels = list(enabled = TRUE), name = "ASD", color = "skyblue") %>% 
  hc_xAxis(type = "datetime")

hchart(data, type = "point", mapping = hcaes(x = hp, y = disp))

hchart(data, mapping = hcaes(x = hp, y = disp, size = wt),
       type = "point", name = "Some Bubbles", showInLegend = FALSE)

hchart(data, type = "bubble", mapping = hcaes(x = hp, y = disp, group = gear),
       showInLegend = c(T, F, T), var = list(othervar = 4, hey = 10))

hchart(data, type = "scatter", mapping = hcaes(x = hp, y = disp, group = gear))

hchart(data, type = "scatter", mapping = hcaes(x = hp, y = disp, group = gear),
       dataLabels = list(enabled = TRUE))

hchart(data, type = "scatter", mapping = hcaes(x = hp, y = disp, z = gear),
       dataLabels = list(enabled = TRUE))

hchart(data, type = "scatter", mapping = hcaes(x = hp, y = disp, size = gear),
       dataLabels = list(enabled = TRUE))

hchart(data, type = "scatter", mapping = hcaes(x = hp, y = disp, z = gear, group = cyl),
       dataLabels = list(enabled = TRUE))

