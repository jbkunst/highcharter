library(tidyverse)
library(htmltools)
library(highcharter)
library(viridisLite)

color_stops_index <- color_stops(colors = inferno(10, begin = 0.1))

hc_theme_highcharts_small <- 
  hc_theme_hcrt(
    chart = list(backgroundColor = "transparent"),
    plotOptions = list(
      series = list(showInLegend = FALSE, marker = list(radius = 2)),
      line = list(lineWidth = 1.2)
      ),
    xAxis = list(
      showLastLabel = FALSE,
      showFirstLabel = FALSE,
      endOnTick = FALSE,
      startOnTick = FALSE
      ),
    yAxis = list(
      showLastLabel = FALSE,
      showFirstLabel = FALSE,
      endOnTick = FALSE,
      startOnTick = FALSE
      ),
    tooltip = list(valueDecimals = 2)
  )

options(highcharter.theme = hc_theme_highcharts_small)


# example 1: scatter ------------------------------------------------------
mpg <- ggplot2::mpg %>%
  mutate(name = str_c(manufacturer, " ", model)) %>% 
  select(x = displ, y = hwy) %>% 
  mutate_all(round, 2)

p1 <- hchart(mpg, "point", hcaes(x, y), name = "Cars") %>% 
  hc_colorAxis(stops = color_stops_index, legend = FALSE, visible = FALSE) %>% 
  hc_xAxis(title = list(text = "displ")) %>% 
  hc_xAxis(title = list(text = "hwy")) 

p1

# example 2: lines/forecast -----------------------------------------------
library(forecast)
p2 <- hchart(
  forecast(ets(AirPassengers), level = 90, h = 12 * 2),
  fillOpacity = 0.1,
  name = "Air Passengers data"
  ) %>%
  hc_xAxis(min = datetime_to_timestamp(as.Date("1955-01-01"))) %>%
  hc_tooltip(shared = TRUE, valueDecimals = 0)

p2

# example 3: maps ---------------------------------------------------------
data(GNI2014, package = "treemap")
GNI2014 <- select(GNI2014, -population, -continent)
p3 <- hcmap(
  "custom/world-robinson-lowres",
  data = GNI2014,
  name = "Gross national income per capita",
  value = "GNI",
  borderWidth = 0,
  joinBy = c("iso-a3", "iso3"),
  nullColor = "#932667"
  ) %>%
  hc_colorAxis(stops = color_stops_index, type = "logarithmic") %>%
  hc_legend(enabled = FALSE) %>%
  hc_mapNavigation(enabled = FALSE) %>% 
  hc_credits(enabled = FALSE)


p3


# example 4: boxplots -----------------------------------------------------
p4 <- highchart() %>%
  hc_chart(type = "bar") %>% 
  hc_xAxis(type = "category") %>%
  hc_xAxis(showLastLabel = TRUE, showFirstLabel = TRUE) %>% 
  hc_add_series_list(
    data_to_boxplot(
      iris, Sepal.Length, Species, add_outliers = TRUE,
      color = "red", showInLegend = FALSE, name = "Sepal length"
      )
    )

p4


# example 5: graph --------------------------------------------------------
library(igraph)

set.seed(12313)
N <- 24
net <- sample_pa(N)
wc <- cluster_walktrap(net)
V(net)$label <- 1:N
V(net)$name <- 1:N
V(net)$page_rank <- round(page.rank(net)$vector, 2)
V(net)$betweenness <- round(betweenness(net), 2)
V(net)$degree <- degree(net)
V(net)$size <- V(net)$degree + 1
V(net)$comm <- membership(wc)
V(net)$color <- colorize(membership(wc), viridisLite::magma(length(wc)))
p5 <- hchart(net, layout = layout_with_fr, maxSize = 13)

p5
  

# example 6: density ------------------------------------------------------
p6 <- highchart() %>%
  hc_chart(type = "area") %>% 
  hc_add_series(density(rnorm(10000000)), name = "Normal(0, 1) Distribution") %>%
  hc_add_series(density(rgamma(100000000, 5, 0.8)), name = "Gamma(5. 0.8) Distribution") %>%
  hc_plotOptions(series = list(fillOpacity = 0.5)) %>%
  hc_xAxis(min = -5, max = 12)

p6


# example 6: raster -------------------------------------------------------
brks <- seq(-2.5, 2.5, length.out = 30)
grid <- expand.grid(brks, brks)
m <- as.data.frame(grid) %>% 
  mutate(
    value =
      mvtnorm::dmvnorm(grid, mean = c(1, 1), sigma = matrix(c(1, .2, .2, 1), nrow = 2)) +
      mvtnorm::dmvnorm(grid, mean = c(-1, -1), sigma = matrix(c(1, -.8, -.8, 1), nrow = 2)) +
      mvtnorm::dmvnorm(grid, mean = c(0, 0), sigma = matrix(c(1.5, 0, 0, 1.5), nrow = 2))) %>% 
  spread(Var2, value) %>% 
  select(-Var1) %>% 
  as.matrix() 

colnames(m) <- rownames(m) <-  NULL

ncols <- 10
cols <- c(rep("white", 2), rev(inferno(ncols - 2, begin = 0)))
cols <- hex_to_rgba(cols, alpha = 1:ncols/ncols)
colssotps <- list_parse2(
  data.frame(
    q = seq(0, ncols - 1) / (ncols - 1),
    c = cols
  )
)

p7 <- hchart(m) %>% 
  hc_add_theme(hc_theme_null()) %>% 
  hc_legend(enabled = FALSE) %>% 
  hc_colorAxis(stops = colssotps)

p7


# exmple 8: histogram -----------------------------------------------------
p8 <- hchart(rgamma(5000, shape = 3, scale = 0.8)) %>% 
  hc_xAxis(max = 8)

p8


# join --------------------------------------------------------------------
plots <- list(
  p1, p2, 
  p3, p4, 
  p5, p6, 
  p7, p8
  )

plots <- map(plots, hc_size, height = 250)

# hw_grid(plots)

divplots <- map(plots, tags$div, class = "col-sm-6")

divplots <- htmltools::tagList(
  tags$div(
    class = "row", 
    # style = "padding-right: 10px",
    divplots
    )
  )

divplots

# export ------------------------------------------------------------------
# install.packages("connectwidgets")

hw_grid(
  p1, p2, 
  p3, p4, 
  p5, p6, 
  p7, p8,
  ncol = 2,
  rowheight = 250
) |> 
  htmltools::save_html("pkgdown/index-examples.html")

