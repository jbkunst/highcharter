library(highcharter)
options(highcharter.verbose = TRUE)

highchart() %>% 
  hc_add_series(cars, "point", hcaes(speed, dist), name = "Some points") %>% 
  hc_add_series(lm(dist ~ poly(speed, 5, raw = TRUE), data = cars), name = "ploy5") %>% 
  hc_add_series(lm(dist ~ poly(speed, 7, raw = TRUE), data = cars), name = "ploy7") %>% 
  hc_add_series(lm(dist ~ poly(speed, 10, raw = TRUE), data = cars), name = "ploy10")



hc_add_series.lm <- function(hc, data, type = "line", color = "#5F83EE", fillOpacity = 0.1, ...) {
  
  if (getOption("highcharter.verbose"))
    message(sprintf("hc_add_series.%s", class(data)))
  
  data2 <- data %>% 
    augment() %>% 
    as.matrix.data.frame() %>% 
    as.data.frame() %>% 
    tbl_df()
  data2 <- arrange_(data2, .dots = names(data2)[2])
  data2 <- mutate_(data2, .dots = c("x" = names(data2)[2]))
  data2 <- select_(data2, .dots = c(names(data2)[1]), "x", ".fitted", ".se.fit")
  
  rid <- random_id()
    
  hc %>% 
    hc_add_series(data2, type = type, hcaes_("x", ".fitted"), 
                  id = rid, color = color, ...) %>% 
    hc_add_series(data2, type = "arearange",
                  hcaes_("x",
                         low = ".fitted - 2 * .se.fit",
                         high = ".fitted + 2 * .se.fit"),
                  color = hex_to_rgba(color, fillOpacity),
                  linkedTo = rid, zIndex = -2, ...)
  
}

highchart() %>% 
  hc_add_series(cars, "point", hcaes(speed, dist), name = "Some points") %>% 
  hc_add_series(loess(dist ~ speed, data = cars, span = 0.5), name = "loess 0.5") %>% 
  hc_add_series(loess(dist ~ speed, data = cars, span = 1.0), name = "loess 1.0") %>% 
  hc_add_series(loess(dist ~ speed, data = cars, span = 2.0), name = "loess 2.0")



