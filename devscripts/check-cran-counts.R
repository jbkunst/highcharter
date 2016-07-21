library("dplyr")
library("lubridate")
library("cranlogs")
library("highcharter")

c("highcharter", "rbokeh", "dygraphs", "plotly", "ggvis", "metricsgraphics",
  "rAmCharts") %>% 
  cran_downloads(from = "2016-01-01", to = Sys.Date()) %>% 
  tbl_df() %>% 
  mutate(date = floor_date(date, unit="week")) %>% 
  group_by(date, package) %>% 
  summarize(count = sum(count)) %>% 
  arrange(date) %>% 
  hchart(type = "line", x = date, y = count, group = package) %>% 
  hc_tooltip(shared = TRUE) %>% 
  hc_add_theme(hc_theme_smpl())

