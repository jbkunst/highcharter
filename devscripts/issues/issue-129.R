library(highcharter)

#' https://github.com/jbkunst/highcharter/issues/129

#' # Dont work
for (i in 1:4) print(hc_demo())

#' # Using `tagList`function from the htmltools package
lst <- list()
for (i in 1:4) lst[[i]] <- hc_demo()

htmltools::tagList(lst)
