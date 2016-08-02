#' --- 
#' output: html_document
#' title: Issue 153
#' --- 
#'
#' From https://github.com/jbkunst/highcharter/issues/153

#+ message=FALSE
library(highcharter)
library(dplyr)
library(tidyr)

options(highcharter.theme = hc_theme_smpl())

#+
txt <- "Month | Impressions | Clicks |  CTR | CPC | Position | Cost | Conversions | Conv.rate | Cost_conv
2016-07-01 | 1385 | 161 | 11.6 | 0.2 | 1.7  | 36.3 | 3.33 | 2.1 | 10.9"

con <- textConnection(txt)

df <- read.table(con, sep = "|", header = TRUE)

df <- df[,-1]

df


# TRY 1 -------------------------------------------------------------------
df2 <- gather(df, name, y)

df2

df2 <- df2 %>% 
  mutate(x = row_number() - 1) %>% 
  group_by(name) %>% 
  do(data = list((list(x = .$x, y = .$y)))) %>% 
  mutate(yAxis = ifelse(name %in% c("Impressions", "Clicks"), 1, 0))

df2

series <- list_parse(df2)
series[[1]]

hc <- highchart() %>% 
  hc_xAxis(type = "category", categories = df2$name) %>%
  hc_yAxis_multiples (
    list(
      title = list(text = "%, posição e custos"),
      align = "right",

      opposite = TRUE
    ),
    list(
      title = list(text = "Impressões, cliques e outros"),
      align = "left"
    )
  ) %>% 
  hc_add_series_list(series)

hc 

hc_chart(hc, type = "column")
  

# TRY 2 -------------------------------------------------------------------
df3 <- df %>% 
  gather(name, y) %>% 
  mutate(x = row_number() - 1,
         group = ifelse(name %in% c("Impressions", "Clicks"), 1, 0)) %>% 
  group_by(group) %>% 
  do(data = list_parse(data_frame(x = .$x, y = .$y, name = .$name))) %>% 
  mutate(yAxis = group)

df3

series <- list_parse(df3)
series[[2]]

hc2 <- highchart() %>% 
  hc_xAxis(categories = names(df)) %>%
  hc_yAxis_multiples (
    list(
      title = list(text = "%, posição e custos"),
      align = "right",
      
      opposite = TRUE
    ),
    list(
      title = list(text = "Impressões, cliques e outros"),
      align = "left"
    )
  ) %>% 
  hc_add_series_list(series)

hc2

hc_chart(hc2, type = "column")
#' this work a little if you deselect some series






