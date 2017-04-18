rm(list = ls())
data(GNI2014, business, package = "treemap")
library(dplyr)
library(tidyr)
library(purrr)
library(highcharter)
library(data.tree)


df <- tbl_df(business)
df <- tbl_df(GNI2014)
glimpse(df)

treemap::itreemap

vars <- paste0("NACE", 1:4)
vars <- c("continent", "country")

aggfun <- function(x) sum(x, na.rm = TRUE)

sizeValue <- "population"
colorValue <- "GNI"

aggf <- sum

#specify the tree hierarchy
# df$pathString <- paste("Root" ,df$Costcenter, df$Vendor, df$Tool,   sep = "/")
df <- df %>% 
  unite_("pathString", vars, sep = "/", remove = FALSE) %>% 
  mutate_("pathString" = "paste0(\"Root/\", pathString)")

glimpse(df)

s <- as.Node(df, mode="table")
s$Do(function(node) node$value <- Aggregate(node, attribute = sizeValue, aggFun = aggf), traversal = "post-order")
s$Set(id = 1:s$totalCount)
s$Set(parent1 = c(function(self) GetAttribute(self$parent, "id", format = identity)))

vars2 <- c("levelName", vars, sizeValue, colorValue, "id", "level", "parent1")

datalist <- map(vars2, function(f){ message(f); s$Get(f) }) %>% 
  map(setNames, NULL) %>% 
  setNames(vars2) %>% 
  map(as.vector) %>% 
  as_data_frame() %>% 
  tbl_df() %>% 
  mutate(name = gsub("[^[:alnum:]]", " ", levelName),
         name = trimws(name),
         parent = as.character(parent1),
         id = as.character(id)) %>% 
  mutate_(.dots = list(sizeValue = paste0("as.numeric(trimws(", sizeValue, "))"))) %>% 
  filter(level != 1) %>% 
  mutate(level = level - 1) %>% 
  arrange(level) %>% 
  mutate(parent = ifelse(level == 1, NA, parent)) %>% 
  rename_(.dots = list(value = sizeValue)) %>%
  rename_(.dots = list(colorValue = colorValue)) 
  

glimpse(datalist)


list3 <- list_parse(datalist)

highchart() %>% 
  hc_add_series(
    type = "bar",
    # layoutAlgorithm = "squarified",
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
  hc_colorAxis() %>% 
  hc_add_theme(hc_theme_smpl())


