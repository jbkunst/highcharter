rm(list = ls())
library(tidyverse)
library(tidyr)
library(highcharter)

data("GNI2014", package = "treemap")

data <- GNI2014

df <- structure(
  list(
    Costcenter = c("N1", "N1", "N1", "N1", "N1", "N1", 
                   "N1", "N1", "N2", "N2", "N2", "N2", "N2", "N2", "N3", "N3", "N4", 
                   "N5", "N5", "N6"),
    Vendor = c("L2", "L2", "L2", "L2", "L2", "L2", 
               "L2", "L2", "L1", "L2", "L2", "L2", "L3", "L3", "L2", "L2", "L2", 
               "L2", "L2", "L2"),
    absDiff = c(103.0776, 37.9086, 269.7629, 6.0888, 
                515.388, 27.2604, 27.2604, 6.3608, 4.5434, 88.5966, 982.2193, 
                139.4249, 0.5452, 722.9811, 130.3381, 147.8434, 271.8786, 88.5966, 
                327.4065, 366.564),
    value = c(103.0776, 37.9086, 269.7629, 6.0888, 
              515.388, 27.2604, 27.2604, 6.3608, 4.5434, 88.5966, 982.2193, 
              139.4249, 0.5452, 722.9811, 130.3381, 147.8434, 271.8786, 88.5966, 
              327.4065, 366.564),
    Tool = c("M1", "M2", "M4", "M5", "M6", "M9", 
             "M10", "M11", "M8", "M5", "M9", "M10", "M3", "M7", "M4", "M5", 
             "M5", "M5", "M10", "M5")),
  .Names = c("Costcenter", "Vendor", "absDiff", "value", "Tool"),
  row.names = c(NA, -20L), class = "data.frame")

df <- tbl_df(df)
head(df)

vars <- c("Costcenter", "Vendor", "Tool")
attr <- "value"
aggf <- sum

#specify the tree hierarchy
# df$pathString <- paste("Root" ,df$Costcenter, df$Vendor, df$Tool,   sep = "/")
df <- df %>% 
  unite_("pathString", vars, sep = "/", remove = FALSE) %>% 
  mutate_("pathString" = "paste0(\"Root/\", pathString)")

library("data.tree")
library("data.table")
s <- as.Node(df, mode="table")

#create values for parent nodes, by aggregation of children values
s$Do(function(node) node$value <- Aggregate(node, attribute = attr, aggFun = aggf), traversal = "post-order")
# assign ids to all nodes
s$Set(id = 1:s$totalCount)
# calculate parent ids for all children, using parent1 as parent is system reserved by data.tree
s$Set(parent1 = c(function(self) GetAttribute(self$parent, "id", format = identity)))

class(s)
# copy the data tree structure to a data.frame
test <- print(s, "Costcenter","Vendor","Tool","value", "level", "id", "parent1")

test <- data.table(test)
test[,name:= gsub("[^[:alnum:]]", " ", levelName)]
test[,name:= trimws(name)]
test[,parent:= as.character(parent1)] # parent and ids should be of character for highcharts
test[,id:=as.character(id)] # parent and ids should be of character for highcharts
test[,value:= as.numeric(trimws(value))]

test2 <- print(s, "Costcenter","Vendor","Tool","value", "level", "id", "parent1")
head(test2)


flds <- c("levelName", "Costcenter","Vendor","Tool","value", "level", "id", "parent1")

test3 <- map(flds, function(f){ message(f); s$Get(f) }) %>% 
  map(setNames, NULL) %>% 
  map(as.vector) %>% 
  setNames(flds) %>% 
  map_df(identity) %>% 
  tbl_df() %>% 
  mutate(name = gsub("[^[:alnum:]]", " ", levelName),
         name = trimws(name),
         parent = as.character(parent1),
         id = as.character(id),
         value = as.numeric(trimws(value))) %>% 
  filter(level != 1) %>% 
  mutate(level = level - 1) %>% 
  arrange(level) %>% 
  mutate(parent = ifelse(level == 1, NA, parent),
         colorValue = value)
test3

plot(s)

test <- data.table(test)
test[,name:= gsub("[^[:alnum:]]", " ", levelName)]
test[,name:= trimws(name)]
test[,parent:= as.character(parent1)] # parent and ids should be of character for highcharts
test[,id:=as.character(id)] # parent and ids should be of character for highcharts
test[,value:= as.numeric(trimws(value))]


# library(rCharts)
list <- list_parse(test)
list2 <- list_parse(test2)
list3 <- list_parse(test3)


#list[[1]]$parent <- NULL
#list[[1]]$value <- NULL

highchart() %>% 
  hc_add_series(
    type = "treemap",
    #layoutAlgorithm = "squarified",
    allowDrillToNode = TRUE,
    levels = list(
      list(
        level = 1,
        dataLabels = list(
          enabled = TRUE
        ),
        borderWidth = 3
      ),
      list(
        level = 2,
        dataLabels = list(
          enabled = TRUE
        ),
        borderWidth = 2
      )
    ),
    data= list3
  ) %>% 
  hc_colorAxis()

