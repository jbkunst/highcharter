highchart() %>% 
  hc_chart(type = "bar") %>% 
  hc_title(text = "stuff") %>% 
  hc_yAxis(title = list(text = ""), 
           labels = list(format = "{value}"), min=0) %>% 
  hc_plotOptions(column = list( 
    series=list(stacking='normal'),
    dataLabels = list(enabled = FALSE), 
    enableMouseTracking = TRUE)) %>% 
  hc_legend(enabled = FALSE) %>% 
  hc_xAxis(reversed=FALSE,opposite=TRUE,reversed=FALSE, linkedTo=0) %>% 
  hc_add_series(list(name="Value",color=c("#766A62"),data=list(-10, -5, -6)))    %>%
  hc_add_series(list(name="Value",color=c("#766A62"),data=list(-2, -5, -3)))  %>%
  hc_add_series(list(name="neutral",id='neutral',color=c("#766A62"),data=list(-2, -5, -3)))  %>%
  hc_add_series(list(name="Value",color=c("#766A62"),data=list(5, 1,6)))  %>%
  hc_add_series(list(name="Value",color=c("#766A62"),data=list(2, 5, 3)))  %>%
  hc_add_series(list(linkedTo='neutral',name="neutral",color=c("#766A62"),data=list(6, 8, 2)))


data(package = "likert")
data(sasr, package = "likert")
head(sasr)
str(sasr)

library(tidyr)
library(dplyr)
library(stringr)

names(sasr)
sasr %>% 
  gather(key, value) %>% 
  count(key, value) %>%
  ungroup() %>% 
  filter(!is.na(value)) %>% 
  filter(str_detect(key, "SASR1")) %>%
  mutate(value = factor(value,
                        levels = c("Strongly Disagree", "Disagree", "Neither", "Agree", "Strongly Agree")),
         n = ifelse(value %in% c("Strongly Disagree", "Disagree"), -n, n),
         key = ifelse(str_detect(key, "^SASR\\d{1}$"),
                      paste0("SARS0", str_extract(key, "\\d")),
                      key)) %>% 
  arrange(key, value) %>% 
  group_by(name = value) %>% 
  do(data = list_parse(data_frame(name = .$key, y = .$n))) %>% 
  list_parse() %>%
  hc_add_series_list(highchart(), .) %>% 
  hc_chart(type = "bar") %>% 
  hc_plotOptions(series = list(stacking = "normal"))

sasr2 %>% 
  group_by()
