library(tidyverse)

data(gapminder, package = "gapminder")

gapminder <- gapminder %>% 
  filter(year == max(year)) %>% 
  select(country, pop, continent)

hc <- hchart(gapminder, "packedbubble", hcaes(name = country, value = pop, group = continent))

q95 <- as.numeric(quantile(gapminder$pop, .95))

hc %>% 
  hc_tooltip(
    useHTML = TRUE,
    pointFormat = "<b>{point.name}:</b> {point.value}"
  ) %>% 
  hc_plotOptions(
    packedbubble = list(
      maxSize = "150%",
      zMin = 0,
      layoutAlgorithm = list(
        gravitationalConstant =  0.05,
        splitSeries =  TRUE, # TRUE to group points
        seriesInteraction = TRUE,
        dragBetweenSeries = TRUE,
        parentNodeLimit = TRUE
      ),
      dataLabels = list(
        enabled = TRUE,
        format = "{point.name}",
        filter = list(
          property = "y",
          operator = ">",
          value = q95
        ),
        style = list(
          color = "black",
          textOutline = "none",
          fontWeight = "normal"
        )
      )
    )
  )
  
