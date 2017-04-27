rm(list = ls())
library(dplyr)
library(tidyr)
library(purrr)
library(highcharter)
library(data.tree)
options(highcharter.debug = TRUE)

data(GNI2014, package = "treemap")


# ... <- NULL
# data <- tbl_df(GNI2014)
# vars <- c("continent", "country")
# aggfun <- function(x) sum(x, na.rm = TRUE)
# sizevar <- "population"
# colovar <- "GNI"


hctreemap2 <- function(data, vars, sizevar = NULL, colorvar = NULL, aggfun = sum, ...) {
  
  data <- data %>% 
    mutate_if(is.factor, as.character) %>% 
    unite_("pathString", vars, sep = "/", remove = FALSE) %>% 
    mutate_("pathString" = "paste0(\"Root/\", pathString)")
  
  s <- as.Node(data, mode="table")
  s$Do(function(node) node$value <- Aggregate(node, attribute = sizevar, aggFun = aggfun), traversal = "post-order")
  s$Set(id = 1:s$totalCount)
  s$Set(parent1 = c(function(self) GetAttribute(self$parent, "id", format = identity)))
  
  vars2 <- c(vars, sizevar, "levelName", "id", "level", "parent1", "value")
  
  if(!is.null(colorvar)) vars2 <- c(vars2, colorvar)
  
  # datalist <- map(vars2, function(f){ s$Get(f) }) %>% 
  #   map(setNames, NULL) %>% 
  #   setNames(vars2) %>%
  #   map(as.vector) %>% 
  #   as_data_frame() %>% 
  #   tbl_df() 
  # 
  # datalist <-  datalist %>% 
  #   arrange_("level") %>%
  #   filter_("level != 1") %>% 
  #   rename_(.dots = c("parent" = "parent1", "name" = "levelName"))
  # 
  # datalist <- datalist %>% 
  #   mutate_(
  #     .dots = list(
  #       name = "gsub(\"[^[:alnum:]]\", \" \", name)",
  #       name = "trimws(name)",
  #       parent = "as.character(parent)",
  #       id = "as.character(id)",
  #       parent = "ifelse(level == 1, NA, parent)",
  #       sizevar = paste0("as.numeric(trimws(", sizevar, "))"),
  #       level = "level - 1"
  #     )
  #   )
  
  datalist <- map(vars2, function(f){ s$Get(f) }) %>% 
    map(setNames, NULL) %>% 
    map(as.vector) %>% 
    setNames(vars2) %>% 
    map_df(identity) %>% 
    tbl_df() 
  
  datalist <- datalist %>% 
    mutate(name = gsub("[^[:alnum:]]", " ", levelName),
           name = trimws(name),
           parent = as.character(parent1),
           id = as.character(id),
           value = as.numeric(trimws(value))) %>% 
    filter(level != 1) %>% 
    mutate(level = level - 1) %>% 
    arrange(level) %>% 
    mutate(parent = ifelse(level == 1, NA, parent)) %>% 
    select(-levelName)
  
  # datalist %>% 
  #   group_by(type_1) %>% 
  #   summarise(
  #     n = n(),
  #     m = sum(value)
  #   )
  #   
  
  if(!is.null(colorvar)) datalist <- mutate_(datalist, .dots = list(colorValue = colorvar))
  
  hc <- highchart() %>% 
    hc_add_series(
      type = "treemap",
      allowDrillToNode = TRUE,
      data = list_parse(datalist),
      ...
    )
  
  if(!is.null(colorvar)) hc <- hc_colorAxis(hc, enabled = TRUE)
  
  hc
  
}

hctreemap2(GNI2014, c("continent"), "population")
hctreemap2(GNI2014, c("continent"), "population", "GNI")

hctreemap2(GNI2014, c("country"), "population")
hctreemap2(GNI2014, c("country"), "population", "GNI", layoutAlgorithm = "squarified")
hctreemap2(GNI2014, c("country"), "population", "GNI", layoutAlgorithm = "sliceAndDice")
hctreemap2(GNI2014, c("country"), "population", "GNI", layoutAlgorithm = "stripes")
hctreemap2(GNI2014, c("country"), "population", "GNI", layoutAlgorithm = "strip")

hctreemap2(GNI2014, c("continent", "country"), "population")
hctreemap2(GNI2014, c("continent", "country"), "population", "GNI")

data("pokemon")
pokemon <- pokemon %>% 
  mutate(type_2 = ifelse(is.na(type_2), paste("only", type_1), type_2),
         count = 5)

hctreemap2(pokemon, c("type_1", "type_2", "pokemon"), "count")
hctreemap2(pokemon, c("type_1", "type_2", "pokemon"), "count", aggfun = max)
hctreemap2(pokemon, c("type_1", "type_2", "pokemon"), "count", aggfun = length)

# ... <- NULL
# data <- pokemon
# vars <- c("type_1", "type_2", "pokemon")
# aggfun <- function(x) sum(x, na.rm = TRUE)
# sizevar <- "count"
# colovar <- "count"



hctreemap2(pokemonc, c("type_1", "type_2",  ""), "n")


data("diamonds")
dc <- ungroup(count(diamonds, cut, c = color, clarity))
hctreemap2(dc, c("cut", "c", "clarity"), "n", colorvar = "n")

