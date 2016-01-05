rm(list = ls())
library("dplyr")
library("treemap")


data(GNI2010)
head(GNI2010)

set.seed(123)
GNI20102 <- dplyr::sample_n(GNI2010, 100)



tm <- treemap(GNI20102,
              index = c("continent", "country"), 
              vSize = "population",
              palette = rev(viridis::viridis(5)))


highchart() %>% 
  hc_add_serie_treemap(tm, allowDrillToNode = TRUE) %>% 
  hc_title(text = "GNI World Data") %>% 
  hc_subtitle(text = "Gross national income in dollars per country in 2010") %>% 
  hc_tooltip(pointFormat = "<b>{point.name}</b>:<br>
             Population {point.value:,.1f}")

