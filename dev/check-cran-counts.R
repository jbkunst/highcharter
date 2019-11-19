library(dplyr)
library(lubridate)
library(cranlogs)
library(highcharter)
library(forcats)

pcks <- c("highcharter", "rbokeh", "dygraphs", "plotly", "ggvis", "billboarder",
          "metricsgraphics", "rAmCharts", "echarts4r", "rchess") 

data <- pcks %>% 
  # adjustedcranlogs::adj_cran_downloads(from = "2015-06-01", to = Sys.Date()) %>% 
  cranlogs::cran_downloads(from = "2015-06-01", to = Sys.Date()) %>% 
  tbl_df() %>% 
  mutate(date = floor_date(date, unit = "week")) %>% 
  group_by(date, package) %>% 
  summarize(count = sum(count)) %>% 
  ungroup() %>% 
  mutate(package = fct_reorder(package, -count)) %>% 
  group_by(package) %>% 
  arrange(date) %>% 
  filter(row_number() != n())


hchart(data, type = "line", hcaes(x = date, y = count, group = package)) %>% 
  hc_chart(zoomType = "x") %>% 
  hc_tooltip(sort = TRUE, table = TRUE) %>%
  hc_add_theme(hc_theme_smpl()) %>% 
  hc_navigator(enabled = TRUE) %>% 
  hc_yAxis(endOnTick = FALSE)
