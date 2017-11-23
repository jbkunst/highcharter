library(dplyr)
library(lubridate)
library(cranlogs)
library(highcharter)
library(forcats)

pcks <- c("highcharter", "rbokeh", "dygraphs", "plotly",
  "ggvis", "metricsgraphics", "rAmCharts") 

pcks %>% 
  cran_downloads(from = "2015-06-01", to = Sys.Date()) %>% 
  tbl_df() %>% 
  mutate(date = floor_date(date, unit="week")) %>% 
  group_by(date, package) %>% 
  summarize(count = sum(count)) %>% 
  ungroup() %>% 
  mutate(package = fct_reorder(package, -count)) %>% 
  group_by(package) %>% 
  arrange(date) %>% 
  filter(row_number() != n()) %>%
  # mutate(count = cumsum(count)) %>%
  hchart(type = "line", hcaes(x = date, y = count, group = package)) %>% 
  hc_tooltip(sort = TRUE, table = TRUE) %>%
  hc_tooltip(split = TRUE) %>%
  hc_add_theme(hc_theme_smpl())


# devtools::install_github("ropenscilabs/packagemetrics")
# library(packagemetrics)
# pkg_df <- package_list_metrics(pcks)
# ft <- metrics_table(pkg_df)
# ft


