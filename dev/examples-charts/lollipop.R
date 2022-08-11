#' ## lollipop
mtcars <- mtcars[order(mtcars$hp , decreasing = TRUE),]
mtcars$name <- rownames(mtcars)

hchart(mtcars, "lollipop", hcaes(name = name, low = hp ), name = "Horse Power") %>% 
  hc_xAxis(type = "category") %>% 
  hc_yAxis(labels = list(format = "{value} HP"))
