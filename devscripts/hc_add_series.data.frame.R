library(tidyverse)

hc_aes <- function (x, y, ...) {
  mapping <- structure(as.list(match.call()[-1]), class = "uneval")
  mapping <- mapping[names(mapping) != ""]
  class(mapping) <- c("hc_aes", class(mapping))
  mapping
}

hc_aes(hp)
hc_aes(hp, disp)
(mapping <- hc_aes(hp, disp^2, color = wt))
hc_aes(hp, disp, color, group = g, blue)

names(mapping)

mutate_mapping <- function(data, mapping) {
  
  stopifnot(is.data.frame(data), inherits(mapping, "hc_aes"))
  
  # http://rmhogervorst.nl/cleancode/blog/2016/06/13/NSE_standard_evaluation_dplyr.html
  mutate_call <- mapping %>% 
    as.character() %>% 
    map(function(x) paste("~ ", x)) %>% 
    map(as.formula) %>% 
    map(lazyeval::interp)
  
  mutate_(data, .dots = mutate_call)
  
}

mutate_mapping_to_series <- function(data, mapping, type) {
  
  # check type and fix
  type <- ifelse(type == "point", "scatter", type)
  type <- ifelse(has_name(mapping, "size") & type == "scatter", "bubble", type)
  
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
  }
  
  # size
  if (has_name(mapping, "size") & type %in% c("bubble", "scatter"))
    data <- mutate_(data, "z" = "size")
  
  # group 
  if (!has_name(mapping, "group"))
    data[["group"]] <- "group"
  
  series <- data %>% 
    group_by_("group") %>% 
    do(data = list_parse(select_(., quote(-group)))) %>% 
    ungroup()
  
  series[["type"]] <- type
  
  series <- series
  
  if (!has_name(parsc, "group"))
    dfs[["name"]] <- NULL
  
  series <- list_parse(dfs)
  
  series
  
}

validate_mapping <- function(mapping, needmapp = c("x", "y")) {
  
  diffm <- setdiff(needmapp, names(mapping))
  
  if(length(diffm) == 0) {
    return(TRUE)
  } else {
    stop(paste("Some required mapping(s) is(are) missing:", paste(diffm, collapse = ", ")))
  }
  
}

mutate_mapping_fix_heatmap <- function(data, mapping) {
  
  validate_mapping(mapping, c("x", "y", "value"))
  
  if (!is.numeric(data$x)) {
    data$xf <- as.factor(data$x)
    data$x  <- as.numeric(as.factor(data$x)) - 1
  }
  
  if (!is.numeric(data$y)) {
    data$yf <- as.factor(data$y)
    data$y  <- as.numeric(as.factor(data$y)) - 1
  }
  
  data
  
}



options_mapping <- function(data, mapping) {
  
}

mapping <- hc_aes(hp, disp^2, color = wt)
data <- tbl_df(head(mtcars))
data

mutate_mapping(data, mapping)
mutate_mapping(data, hc_aes(hp, disp^2, color = wt))
mutate_mapping(data, hc_aes(hp, disp, color, group = gear, blue))

# heatmap
data <- group_by(diamonds, cut, color) %>% summarize(price = median(price))
mapping <- hc_aes(x = cut, y = color, value = price)
data <- mutate_mapping(data, mapping)


