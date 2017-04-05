#' ---
#' output:
#'   html_document:
#'     theme: paper
#' ---
#+echo=FALSE
knitr::opts_chunk$set(warning = FALSE, message = FALSE)

#+echo=TRUE
library(highcharter)
mtcars <- tibble::rownames_to_column(mtcars)

#' More info: https://cran.r-project.org/web/packages/highcharter/vignettes/charting-data-frames.html
#' 
#' ## {.tabset .tabset-fade .tabset-pills}
#' 
#' ### Standar
#' You can use "point" or "scatter"
hchart(mtcars, "point", hcaes(wt, mpg))

#' ### Groups
hchart(mtcars, "point", hcaes(wt, mpg, group = gear))

#' ### Color
hchart(mtcars, "point", hcaes(wt, mpg, color = hp))

#' ### Size
hchart(mtcars, "point", hcaes(wt, mpg, size = drat), maxSize = "8%")

#' ### Labels
hchart(mtcars, "point", hcaes(wt, mpg), dataLabels = list(enabled = TRUE, format = "{point.rowname}"))


#' ### All
hchart(mtcars, "point", hcaes(wt, mpg, group = gear, color = hp, size = drat),
       maxSize = "8%", dataLabels = list(enabled = TRUE, format = "{point.rowname}"))



