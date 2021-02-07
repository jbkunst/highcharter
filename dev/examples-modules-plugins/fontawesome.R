# from vignettes/fontawesome.Rmd
# install.packages("rsvg")
require(rsvg) # for fontawesome::fa_png
library(fontawesome)
library(highcharter)
library(stringr)

df <- data.frame(
  a = round(rnorm(10), 2),
  b = round(rnorm(10), 2)
)

fa_to_png_to_datauri <- function(name, ...) {
  
  tmpfl <- tempfile(fileext = ".png")
  
  fontawesome::fa_png(name, file = tmpfl, ...)
  
  knitr::image_uri(tmpfl)
  
}

# specify colors tu resue in the series/tooltips
rcol <- "#4C83B6"
pcol <- "#3CAB48"

rproj <- fa_to_png_to_datauri(name = "r-project", width = 22, fill = rcol)
pthon <- fa_to_png_to_datauri(name = "python",    width = 22, fill = pcol)

highchart() %>% 
  hc_title(
    text = str_c("This is a svg ", fa("rocket", fill = "#CACACA"), " icon"),
    useHTML = TRUE
  ) %>% 
  hc_add_series(
    df,
    "scatter",
    hcaes(a, b),
    name = "R icons",
    color = rcol,
    marker = list(symbol = str_glue("url({data_uri})", data_uri = rproj)),
    icon = rproj
  ) %>% 
  hc_add_series(
    df,
    "scatter",
    hcaes(b, a),
    name = "Python icons",
    color = pcol,
    marker = list(symbol = str_glue("url({data_uri})", data_uri = pthon)),
    icon = pthon
  ) %>% 
  hc_tooltip(
    pointFormat = str_c(
      "<b>",
      "<img style='vertical-align:middle' height='15' src='{series.options.icon}'/> ",
      "[{point.x}, {point.y}]",
      "</b>"
    ),
    useHTML = TRUE
  )
