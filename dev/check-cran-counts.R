library("dplyr")
library("lubridate")
library("cranlogs")
library("highcharter")

c("highcharter", "rbokeh", "dygraphs", "plotly",
  "ggvis", "metricsgraphics", "rAmCharts") %>% 
  cran_downloads(from = "2016-01-01", to = Sys.Date()) %>% 
  tbl_df() %>% 
  mutate(date = floor_date(date, unit="week")) %>% 
  group_by(date, package) %>% 
  summarize(count = sum(count)) %>% 
  ungroup() %>% 
  group_by(package) %>% 
  filter(row_number() != n()) %>%
  arrange(date) %>% 
  hchart(type = "line", hcaes(x = date, y = count, group = package)) %>% 
  hc_tooltip(sort = TRUE, table = TRUE) %>% 
  hc_add_theme(hc_theme_smpl())

