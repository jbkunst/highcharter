get_box_values <- function(x) {
  boxplot.stats(x)$stats %>%
    t() %>%
    as.data.frame() %>%
    setNames(c("low", "q1", "median", "q3", "high"))
}

get_outliers_values <- function(x) {
  boxplot.stats(x)$out
}

#' Helper to transform data frame for boxplot highcharts format
#'
#' @param data The data frame containing variables.
#' @param variable The variable to calculate the box plot data.
#' @param group_var A variable to split calculation
#' @param group_var2 A second variable to create separate series.
#' @param add_outliers A logical value indicating if outlies series should
#'   be calculated. Default to \code{FALSE}.
#' @param ... Arguments defined in \url{https://api.highcharts.com/highcharts/plotOptions.series}.
#'
#' @examples 
#' 
#' data(pokemon) 
#' 
#' dat <- data_to_boxplot(pokemon, height)
#' 
#' highchart() %>%
#'   hc_xAxis(type = "category") %>%
#'   hc_add_series_list(dat)
#'   
#' dat <- data_to_boxplot(pokemon, height, type_1, name = "height in meters")
#' 
#' highchart() %>%
#' hc_xAxis(type = "category") %>%
#' hc_add_series_list(dat)
#' 
#' 
#' \dontrun{
#' 
#' 
#' 
# data <- diamonds
# 
# dat <- data_to_boxplot(data, x)
# dat
# highchart() %>% hc_xAxis(type = "category") %>% hc_add_series_list(dat)
# ggplot(diamonds) + geom_boxplot(aes(y = x))
# 
# dat <- data_to_boxplot(data, x, color)
# dat
# highchart() %>% hc_xAxis(type = "category") %>% hc_add_series_list(dat)
# ggplot(diamonds) + geom_boxplot(aes(y = x, x = color))
# 
# dat <- data_to_boxplot(data, x, color, cut)
# dat
# highchart() %>% hc_xAxis(type = "category") %>% hc_add_series_list(dat)
# ggplot(diamonds) + geom_boxplot(aes(y = x, x = color, fill = cut))
# 
# dat <- data_to_boxplot(data, x, group_var2 = cut)
# dat
# highchart() %>% hc_xAxis(type = "category") %>% hc_add_series_list(dat)
# ggplot(diamonds) + geom_boxplot(aes(y = x, fill = cut))
# 
# data_to_boxplot(data)
# data_to_boxplot(data, x + x)
# data_to_boxplot(data, x, c(color, cut))
# data_to_boxplot(data, x, c(color, cut), c(color, cut))
# 
# 
# highchart() %>% 
#   hc_xAxis(type = "category") %>%
#   hc_add_series_list(
#     data_to_boxplot(data, x, color = "red", lineWidth = 100)
#   )
# 
# highchart() %>% 
#   hc_xAxis(type = "category") %>%
#   hc_add_series_list(
#     data_to_boxplot(data, x, color, color = "black", add_outliers = TRUE)
#   )
#' 
#' }
#'
#' @importFrom dplyr transmute group_nest
#' @export
data_to_boxplot <- function(data, variable, group_var = NULL, group_var2 = NULL, add_outliers = FALSE, ...){
  
  stopifnot(
    is.data.frame(data),
    !missing(variable)
    )
  
  dx <- data %>%
    transmute(x := {{variable}}) 
  
  if(!missing(group_var)) {
    dg <- data %>% 
      select({{group_var}})
  } else {
    dg <- data.frame(rep(0, nrow(dx)))
  }
  
  if(!missing(group_var2)) {
    dg2 <- data %>% 
      select({{group_var2}})
  } else {
    dg2 <- data.frame(rep(NA, nrow(dx)))
  }  
  
  dg  <- dg  %>% setNames("name")
  dg2 <- dg2 %>% setNames("series")
  
  dat <- bind_cols(dx, dg, dg2)
   
  dat1 <- dat %>%
    group_by(series, name) %>%
    summarise(data = list(get_box_values(x)), .groups = "drop") %>%
    unnest(cols = data) %>%
    group_nest(series) %>%
    mutate(data = map(data, list_parse)) %>%
    rename(name = series) %>%
    mutate(id = name) %>%
    mutate(type = "boxplot", ...) 
    # list_parse()
  
  if(add_outliers) {
    
    dat2 <- dat %>%
      mutate(name = as.numeric(factor(name)) - 1) %>% 
      group_by(series, name) %>%
      summarise(y = list(get_outliers_values(x)), .groups = "drop") %>%
      unnest(cols = y) %>%
      rename(x = name) %>%
      group_nest(series) %>%
      mutate(data = map(data, list_parse)) %>% 
      rename(linkedTo = series) %>%
      mutate(type = "scatter", showInLegend = FALSE, ...)
    
    dout <- bind_rows(dat1, dat2)
    
  } else {
    dout <- dat1
  }
  
  dout
}



#' Helper to transform data frame for treemap/sunburst highcharts format
#'
#' @param data data frame containing variables to organize each level of 
#'   the treemap.
#' @param group_vars Variables to generate treemap levels.
#' @param size_var Variable to aggregate.
#' @param colors Color to chart every item in the first level.
#'
#' @examples 
#' 
#' \dontrun{
#' 
#' library(dplyr)
#' data(gapminder, package = "gapminder")
#' 
#' gapminder_2007 <- gapminder::gapminder %>% 
#'   filter(year  == max(year)) %>% 
#'   mutate(pop_mm = round(pop/1e6))
#' 
#' dout <- data_to_hierarchical(gapminder_2007, c(continent, country), pop_mm)
#' 
#' hchart(dout, type = "sunburst")
#' 
#' hchart(dout, type = "treemap")
#' }
#' 
#' @importFrom dplyr group_by_at arrange desc distinct rename_all everything
#' @importFrom tidyr unite
#' @importFrom purrr reduce
#' @export
data_to_hierarchical <- function(data, group_vars, size_var, colors = getOption("highcharter.color_palette")){
  
  dat <- data %>%
    select({{group_vars}}, {{size_var}})
  
  ngvars <-  ncol(dat) - 1
  
  names(dat) <- c(str_c("group_var_", seq(1, ngvars)), "value")
  
  gvars <-  names(dat)[seq(1, ngvars)]
  
  # group to calculate the sum if there are duplicated combinations
  dat <- dat %>% 
    group_by_at(all_of(gvars)) %>% 
    summarise(value = sum(value, na.rm = TRUE), .groups = "drop") %>% 
    ungroup() %>% 
    mutate_if(is.factor, as.character) %>% 
    arrange(desc(value)) 
  
  dout <- map(seq_along(gvars), function(depth = 1){

    datg <- dat %>%
      select(1:depth) %>% 
      distinct() 

    datg_name <- datg %>%
      select(depth) %>%
      rename_all(~ "name")

    datg_id <- datg %>%
      unite("id", everything(), sep = "_") %>%
      mutate(id = str_to_id_vec(id))

    datg_parent <- datg %>%
      select(1:(depth- 1)) %>%
      unite("parent", everything(), sep = "_") %>%
      mutate(parent = str_to_id(parent))

    dd <- list(datg_name, datg_id)
    
    # depth != 1 add parents
    if(depth != 1) dd <- dd %>% append(list(datg_parent))
    
    # depth == 1 add colors
    if(depth == 1 & !is.null(colors))
      dd <- dd %>% append(list(tibble(color = rep(colors, length.out = nrow(datg)))))
    
    # depth == lastdepth add value 
    if(depth == ngvars) dd <- dd %>% append(list(dat %>% select(value)))

    dd <- dd %>%
      bind_cols() %>%
      mutate(level = depth)
    
    dd
    
    list_parse(dd) 

  })
  
  dout <- reduce(dout, c)
  
  dout
  
}

#' Helper to transform data frame for sankey highcharts format
#'
#' @param data A data frame
#'
#' @examples 
#' 
#' \dontrun{
#' library(dplyr) 
#' data(diamonds, package = "ggplot2")
#' 
#' diamonds2 <- select(diamonds, cut, color, clarity)
#' 
#' data_to_sankey(diamonds2)
#' 
#' hchart(data_to_sankey(diamonds2), "sankey", name = "diamonds")
#' }
#' 
#' @importFrom dplyr all_of count group_by_all vars
#' @importFrom stats complete.cases
#' @export
data_to_sankey <- function(data = NULL) {
  
  # numeric to categories
  if(any(unlist(purrr::map(data, class)) %in% c("integer", "numeric"))) {
    
    warning("numeric variables were treated with cut() function")
    data <- dplyr::mutate_if(data, function(x) is.numeric(x) && length(unique(x)) > 10, ~ cut(.x, breaks = c(-Inf, quantile(.x, c(2,4,6,8)/10), Inf)))
    
  }
  
  # combintaion data
  dcmb <- tibble::tibble(
    var1 = names(data),
    var2 = dplyr::lead(var1)
    ) %>%  
    dplyr::filter(complete.cases(.))
  
  # sankey data
  dsnky <- purrr::pmap_df(dcmb, function(var1 = "cut", var2 = "color"){
      
    data %>% 
      select(all_of(var1) , all_of(var2)) %>% 
      group_by_all() %>% 
      count() %>% 
      ungroup() %>% 
      setNames(c("from", "to", "weight")) %>% 
      mutate_if(is.factor, as.character) %>% 
      mutate_at(vars(1, 2), as.character) %>% 
      mutate(id := paste0(from, to))
    
    })
  
  dsnky

}

