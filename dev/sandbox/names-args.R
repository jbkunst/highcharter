highchart() %>%
  hc_xAxis(title = "hey", var = 4+4) %>% 
  hc_add_series(data = c(1, 2, 3))

highchart() %>%
  hc_xAxis(title = "hey", 4 + 4) %>% 
  hc_add_series(data = c(1, 2, 3))

highchart() %>%
  hc_xAxis(title = "hey") %>% 
  hc_add_series(data = c(1, 2, 3),
                rexp(19), c(1,2,3,2,3,2,3,2,3))




g <- function(...){
  
  cat("\014")  
  
  message("arguments")
  print(list(...))
  
  message("name slot arguments")
  print(names(list(...)))
  
  message("substitute")
  print(substitute(...))
  
  message("deparse")
  print(deparse(substitute(...)))
  
  message("match.call")
  print(match.call(expand.dots = TRUE))
  
  message("exp 1")
  print(substitute(match.call()))
  
  message("exp 2")
  print(
    print(eval(substitute(alist(...)))))
  
}

g <- function(...) {
  lstargs <- eval(substitute(alist(...)))
  print(lstargs)
  lstargs
}

f <- function(...)  g(...)
  
g(rnorm(5), par = "a", 4 + 4)

lstargs <- f(rnorm(5), par = "a", 4 + 4)
lstargs <- f(a = rnorm(5), par = "a",  b = 4 + 4)

chrargs <- lstargs[which(names(lstargs) == "")] %>% 
  unlist() %>% 
  as.character() %>% 
  paste0("'", ., "'", collapse = ", ")
