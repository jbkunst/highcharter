rm(list = ls())
library("highcharter")
library("ggdendro")
library("dplyr")

dd <- iris[, -5] %>% dist %>% hclust %>% as.dendrogram()
dd <- mtcars %>% dist %>% hclust %>% as.dendrogram()
plot(dd)

dddata <- dendro_data(dd)

by_row2 <- function(.d, .f, ...) {
  purrr::by_row(.d, .f, ..., .to = "out")[["out"]]
}

dsseg <- dddata$segments %>% 
  mutate(x = x - 1, xend = xend - 1) %>% 
  by_row2(function(x){
    list(list(x = x$x, y = x$y), list(x = x$xend, y = x$yend))
  }) 


hc <- highchart() %>% 
  hc_plotOptions(
    series = list(
      lineWidth = 2,
      showInLegend = FALSE,
      marker = list(radius = 0),
      enableMouseTracking = FALSE
    )
  ) %>% 
  hc_xAxis(categories = dddata$labels$label,
           tickmarkPlacement = "on") %>% 
  hc_colors(list(hex_to_rgba("#606060")))

for (i in seq_along(dsseg)) {
  hc <- hc %>% hc_add_series(data = dsseg[[i]], type = "scatter")
}

hc

hc %>%
  hc_chart(type = "column")

hc %>%
  hc_chart(type = "bar") %>% 
  hc_xAxis(tickLength = 0)

hc %>% hc_chart(type = "bar") %>%
  hc_yAxis(reversed = TRUE) %>%
  hc_xAxis(opposite = TRUE, tickLength = 0)

hc %>% hc_chart(polar = TRUE) %>%
  hc_yAxis(reversed = TRUE, visible = FALSE) %>% 
  hc_xAxis(gridLineWidth = 0,
           lineWidth = 0)
  
