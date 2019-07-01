options(highcharter.theme = hc_theme_smpl())
options(highcharter.debug = TRUE)

rarima <- function(model = list(ar = 0.5), n = NULL, ...) {
  x <- arima.sim(model = model, n = n, ...)  
  attr(x, "model") <- model
  class(x) <- "simarima"
  x
}

y <- rarima(model =  list(ar = c(0.8897, -0.4858), ma = c(-0.2279, 0.2488)),
            n = 603, rand.gen = function(n, ...) sqrt(0.1796) * rt(n, df = 5))

str(y)
class(y)
attr(y, "model")

hc_gen_arimaproces <- function(x) {
  
  x <- as.numeric(x)
  df <- data.frame(x = 1:length(x), y = x)
  
  highchart() %>% 
    hc_add_series(data = list(list(0, 0)), datao = list_parse(df), type = "line") 
  
  #   fmtrr <- "function() {
  #   if (this.point.x == this.series.data[this.series.data.length-1].x & 
  #   this.series.options.showlabel) {
  #   return this.series.options.extra.title;
  #   } else {
  #   return null;
  #   }
  # }"
  
}

highchart() %>% 
  hc_add_series(data = as.numeric(ts)) %>% 
  hc_navigator(enabled = TRUE) %>% 
  hc_rangeSelector(enabled = FALSE)

hc <- hchart(ts)
hchc$x$type <- "stock"
hc
