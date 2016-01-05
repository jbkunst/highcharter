rm(list = ls())
library("treemap")
library("highcharter")
library("htmlwidgets")

data(GNI2010)
head(GNI2010)



library("plyr")

hc_add_serie_treemap <- function(hc, tm, ...) {
  
  df <- tm$tm %>% 
    tbl_df() %>% 
    select_("-x0", "-y0", "-w", "-h", "-stdErr", "-vColorValue") %>% 
    rename_("value" = "vSize", "valuecolor" = "vColor") %>% 
    purrr::map_if(is.factor, as.character)
  
  ndepth <- which(names(df) == "value") - 1
  
  
  ds <- ldply(seq(ndepth), function(lvl){ # lvl <- sample(size = 1, seq(ndepth))
    
    df2 <- df %>% 
      filter_(sprintf("level == %s", lvl)) %>% 
      rename_("name" = names(df)[lvl]) %>% 
      mutate_("id" = "highcharter::str_to_id(name)")
    
    if(lvl > 1) {
      df2 <- df2 %>% 
        mutate_("parent" = names(df)[lvl-1],
                "parent" = "highcharter::str_to_id(parent)")
    } else {
      df2 <- df2 %>% 
        mutate_("parent" = NA)
    }
  
    df2 
    
  })
  
  ds <- setNames(rlist::list.parse(ds), NULL)
  
  ds <- purrr::map(ds, function(x){
    if(is.na(x$parent))
     x$parent <- NULL
    x
  })
  
  hc <- hc %>% hc_add_serie(data = ds, type = "treemap", ...)

  hc
  
}

count(GNI2010, continent)

GNI2222 <- filter(GNI2010, continent %in% c("Oceania", "North America"))

GNI2222 <- data_frame(L = c("A", "A", "A", "B", "B"),
                      l = c("ta", "tata", "tatata", "bi", "bibi"),
                      foo = c(1, 2, 3, 4, 5),
                      bar = c(3, 5, 4, 7, 9))

tm <- treemap(GNI2222, index = c("continent", "country"), vSize = "population", vColor = "GNI", type = "value", draw = TRUE)
highchart() %>% 
  hc_add_serie_treemap(tm, allowDrillToNode = TRUE) %>% 
  hc_tooltip(pointFormat = "{point.continent}: {point.vSize}")

tm <- treemap(GNI2222, index = c("continent", "country"), vSize = "population", vColor = "GNI", type = "value", draw = TRUE)
highchart() %>% 
  hc_add_serie_treemap(tm, allowDrillToNode = TRUE) %>% 
  hc_tooltip(pointFormat = "{point.continent}: {point.vSize}")

tm <- treemap(GNI2010, index = c("continent"), vSize = "population", vColor = "GNI", type = "value", draw = TRUE)
highchart() %>% 
  hc_add_serie_treemap(tm, allowDrillToNode = TRUE) %>% 
  hc_tooltip(pointFormat = "{point.continent}: {point.vSize}")




