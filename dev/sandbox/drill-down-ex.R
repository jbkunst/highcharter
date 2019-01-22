rm(list = ls())
suppressPackageStartupMessages(library("dplyr"))
suppressPackageStartupMessages(library("purrr"))
suppressPackageStartupMessages(library("highcharter"))

df <- data_frame(
  name = c("Animals", "Fruits", "Cars"),
  y = c(5, 2, 4),
  drilldown = tolower(name)
)

df

hc <- highchart() %>%
  hc_chart(type = "column") %>%
  hc_title(text = "Basic drilldown") %>%
  hc_xAxis(type = "category") %>%
  hc_legend(enabled = FALSE) %>%
  hc_plotOptions(
    series = list(
      boderWidth = 0,
      dataLabels = list(enabled = TRUE)
    )
  ) %>%
  hc_add_series(
    data = df,
    name = "Things",
    colorByPoint = TRUE
  )


dfan <- data_frame(
  name = c("Cats", "Dogs", "Cows", "Sheep", "Pigs"),
  value = c(4, 3, 1, 2, 1)
)

dffru <- data_frame(
  name = c("Apple", "Organes"),
  value = c(4, 2)
)

dfcar <- data_frame(
  name = c("Toyota", "Opel", "Volkswagen"),
  value = c(4, 2, 2)
)

hc <- hc %>%
  hc_drilldown(
    allowPointDrilldown = TRUE,
    series = list(
      list(
        id = "animals",
        data = list_parse2(dfan)
      ),
      list(
        id = "fruits",
        data = list_parse2(dffru)
      ),
      list(
        id = "cars",
        data = list_parse2(dfcar)
      )
    )
  )

hc

highchart()

data(GNI2014)
df1 <- tbl_df(GNI2014) %>% 
  group_by(name = continent, id = continent, drilldown = continent) %>% 
  summarise(y = sum(population)) %>% 
  arrange(desc(y))

df2 <- tbl_df(GNI2014) %>% 
  group_by(id = continent) %>% 
  do(data = list_parse2(select(., name = country, value = population)))


highchart() %>% 
  hc_chart(type = "column") %>%
  hc_add_series(data = df1, name = "Continents") %>% 
  hc_legend(enabled = FALSE) %>%
  hc_xAxis(type = "category") %>% 
  hc_drilldown(
    allowPointDrilldown = TRUE,
    series = list_parse(df2)
  )

