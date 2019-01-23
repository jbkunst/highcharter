library(highcharter)
library(dplyr)
library(purrr)

df <- tibble(
  name = c("Animals", "Fruits"),
  y = c(5, 2),
  drilldown = tolower(name)
)

df

hc <- highchart() %>%
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
    type = "column",
    hcaes(name = name, y = y),
    name = "Things",
    colorByPoint = TRUE
  )

dfan <- data.frame(
  name = c("Cats", "Dogs", "Cows", "Sheep", "Pigs"),
  value = c(4, 3, 1, 2, 1)
)

dffru <- data.frame(
  name = c("Apple", "Organes"),
  value = c(4, 2)
)


dsan <- list_parse2(dfan)

dsfru <- list_parse2(dffru)

hc <- hc %>%
  hc_drilldown(
    allowPointDrilldown = TRUE,
    series = list(
      list(
        id = "animals",
        data = dsan
      ),
      list(
        id = "fruits",
        data = dsfru
      )
    )
  )

hc


