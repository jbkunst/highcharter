#+message=FALSE, warning=FALSE
library(highcharter)
library(dplyr)

options(highcharter.download_map_data = TRUE)

hcmap("custom/asia")

mapdata <- get_data_from_map(download_map_data("custom/asia"))

glimpse(mapdata)

fakedata <- mapdata %>% 
  select(`hc-a2`) %>% 
  mutate(fakevalue = rexp(nrow(.)) + 1)

glimpse(fakedata)

hcmap("custom/asia", data = fakedata, value = "fakevalue", joinBy = "hc-a2") %>% 
  hc_plotOptions(
    series = list(
      borderColor = "transparent",
      dataLabels = list(
        enabled = TRUE,
        format = "{point.properties.name}"
        )
      )
    ) %>% 
  hc_colorAxis(stops = color_stops()) %>%
  hc_legend(valueDecimals = 0, valueSuffix = "%") %>%
  hc_mapNavigation(enabled = TRUE) %>% 
  hc_add_theme(hc_theme_db())

