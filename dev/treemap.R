rm(list = ls())
library("dplyr")
library("treemap")


data(GNI2014)
head(GNI2014)

tm <- treemap(GNI2014,
        index=c("continent", "iso3"),
        vSize="population",
        vColor="GNI",
        type="value",
        palette = rev(viridis::viridis(5)))

highchart() %>% 
  hc_add_series_treemap(tm, allowDrillToNode = TRUE) %>% 
  hc_title(text = "GNI World Data") %>% 
  hc_subtitle(text = "Gross national income in dollars per country in 2010") %>% 
  hc_tooltip(pointFormat = "<b>{point.name}</b>:<br>Population {point.value:,.1f}")


#### ####
library("portfolio")

data <- read.csv("http://datasets.flowingdata.com/post-data.txt")
head(data)

tm <- map.market(id=data$id, area=data$views, group=data$category, color=data$comments, main="FlowingData Map")

head(tm$children)

data(dow.jan.2005)
map.market(id    = dow.jan.2005$symbol,
           area  = dow.jan.2005$price,
           group = dow.jan.2005$sector,
           color = 100 * dow.jan.2005$month.ret)
