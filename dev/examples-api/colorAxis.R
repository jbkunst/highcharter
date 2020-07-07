library(dplyr)

data(mpg, package = "ggplot2")

mpgman2 <- mpg %>% 
  group_by(manufacturer, year) %>% 
  dplyr::summarise(
    n = dplyr::n(),
    displ = mean(displ)
    )

mpgman2

hchart(
  mpgman2, "column", hcaes(x = manufacturer, y = n, group = year),
  colorKey = "displ",
  # color = c("#FCA50A", "#FCFFA4"),
  name = c("Year 1999", "Year 2008")
  ) %>% 
  hc_colorAxis(min = 0, max = 5)


# defaults to yAxis
hchart(iris, "point", hcaes(Sepal.Length, Sepal.Width)) %>% 
  hc_colorAxis(
    minColor = "red",
    maxColor = "blue"
  )



# Ex2
n <- 5

stops <- data.frame(
  q = 0:n/n,
  c = c("#440154", "#414487", "#2A788E", "#22A884", "#7AD151", "#FDE725"),
  stringsAsFactors = FALSE
  )

stops <- list_parse2(stops)

M <- round(matrix(rnorm(50*50), ncol = 50), 2)

hchart(M) %>% 
  hc_colorAxis(stops = stops)

# Ex3
# hchart(volcano) %>% 
#   hc_colorAxis(stops = stops, max = 200)
