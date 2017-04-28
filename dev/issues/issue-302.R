library(dplyr)
library(tidyr)
library(highcharter)

# example 1 ---------------------------------------------------------------
data(citytemp)
citytemp$int <- seq_len(12L)

citytemp2 <- citytemp %>% 
  select(-new_york, -london) %>% 
  gather(city, temp, berlin, tokyo)

highchart() %>% 
  hc_xAxis(categories = citytemp$int) %>% 
  hc_add_series(name = "Berlin", data = citytemp$berlin) %>% 
  hc_add_series(name = "Tokyo", data = citytemp$tokyo) 

highchart() %>% 
  hc_xAxis(categories = citytemp$int) %>%
  hc_add_series(citytemp2, "line",  hcaes(x = int, y = temp, group = city)) 

highchart() %>% 
  hc_xAxis(categories = citytemp$int) %>%
  hc_add_series(citytemp2, "line",  hcaes(x = as.character(int), y = temp, group = city)) 

hchart(citytemp2, "line",  hcaes(x = as.character(int), y = temp, group = city))
hchart(citytemp2, "line",  hcaes(x = as.integer(int), y = temp, group = city))

# example 2 ---------------------------------------------------------------
year <- seq.int(from = 1750, to = 2050, by = 50)
Asia <- c(502, 635, 809, 947, 1402, 3634, 5268)
Africa <-  c(106, 107, 111, 133, 221, 767, 1766)
Europe <-  c(163, 203, 276, 408, 547, 729, 628) 
America <-  c(18, 31, 54, 156, 339, 818, 1201) 
Oceania <-  c(2, 2, 2, 6, 13, 30, 46)
df_area <- data.frame(year,Asia,Africa,Europe,America,Oceania) %>% gather(continent, pop, -year) 

hchart(df_area, "area", hcaes(x = year, y = pop, group = continent)) 

highchart() %>% 
  hc_add_series(df_area, "area", hcaes(x = year, y = pop, group = continent)) 

hchart(df_area, "area",
       hcaes(x = year, y = pop, group = continent)) %>% 
  hc_plotOptions(area = list(marker = list(enabled = FALSE)))

highchart() %>% 
  hc_add_series(df_area, "area", 
                hcaes(x = year, y = pop, group = continent)) %>% 
  hc_plotOptions(area = list(marker = list(enabled = FALSE)))


# session -----------------------------------------------------------------
devtools::session_info()
