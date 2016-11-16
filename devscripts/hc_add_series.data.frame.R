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

mutate_mapping_fix <- function(data, mapping) {
  
  if(has_name(mapping, "x") & is.Date(data[["x"]]))
    data <- mutate(data, x = datetime_to_timestamp(x))
  
}

options_mapping <- function(data, mapping) {
  
}

mapping <- hc_aes(hp, disp^2, color = wt)
data <- head(mtcars)
data

mutate_mapping(data, mapping)
mutate_mapping(data, hc_aes(hp, disp^2, color = wt))
mutate_mapping(data, hc_aes(hp, disp, color, group = gear, blue))

