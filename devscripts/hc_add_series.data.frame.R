aes2 <- function (x, y, ...) {
  structure(as.list(match.call()[-1]), class = "uneval")
}

aes2(hp)
aes2(hp, disp)
aes2(hp, disp, color)

mapping <- aes2(hp, disp^2, color = wt)

# http://rmhogervorst.nl/cleancode/blog/2016/06/13/NSE_standard_evaluation_dplyr.html
mutate_call <- mapping %>% 
  as.character() %>% 
  map(function(x) paste("~ ", x)) %>% 
  map(as.formula) %>% 
  map(lazyeval::interp)

data <- head(mtcars)
data

data %>% mutate_(.dots = mutate_call)

hchart(mtcars, "line", x = wt, y = hp, group = cyl)

