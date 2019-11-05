library("readr")
library("jsonlite")
library("dplyr")

lines <- read_lines("http://bl.ocks.org/nbremer/raw/eb0d1fd4118b731d069e2ff98dfadc47/starsSample.js")
lines <- gsub("var stars = ", "", lines)

stars <- fromJSON(lines)

names(stars) <- tolower(names(stars))

stars <- tbl_df(stars)

stars

devtools::use_data(stars)

# EXAMPLE -----------------------------------------------------------------
thm <- hc_theme(
  chart = list(
    backgroundColor = "black"
  ),
  yAxis = list(
    gridLineWidth = 0
  )
)

colors <- c(
  "#FB1108", "#FD150B", "#FA7806", "#FBE426", "#FCFB8F",
  "#F3F5E7", "#C7E4EA", "#ABD6E6", "#9AD2E1"
)

stars$color <- colorize(log(stars$temp), colors)

x <- c("Luminosity", "Temperature", "Distance")
y <- sprintf(
  "{point.%s}",
  c("lum", "temp", "distance")
)
tltip <- tooltip_table(x, y)


hchart(stars, "point", x = temp, y = lum, size = radiussun) %>%
  hc_xAxis(type = "logarithmic", reversed = TRUE) %>%
  hc_yAxis(type = "logarithmic") %>%
  hc_title(text = "Our nearest Stars") %>%
  hc_subtitle(text = "In a Hertzsprung-Russell diagram") %>%
  hc_add_theme(thm) %>%
  hc_tooltip(useHTML = TRUE, headerFormat = "", pointFormat = tltip)
