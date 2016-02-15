# highchart() %>%  hc_xAxis(title = "hey", "s", "aa", 4+4)

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
  print(as.list(match.call(call = sys.call(sys.parent(-1)), expand.dots = FALSE))$...)
  
}

g <- function(...) {
  print(as.list(match.call(expand.dots = FALSE))$...)
}

f <- function(...)  g(...)
  
g(rnorm(5), par = "a", 4 + 4)

f(rnorm(5), par = "a", 4 + 4)


