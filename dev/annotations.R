# https://stackoverflow.com/questions/48993377/

library(highcharter)

day <- 24 * 3600 * 1000
start <- datetime_to_timestamp(as.Date("2017/01/01"))


highchart(type = "stock") %>% 
  hc_add_annotation(
    labelOptions = list(
      backgroundColor = 'rgba(255,255,255,0.5)',
      verticalAlign = 'top',
      y = 15
    ),
    labels = list(
      list(
        point = list(
          xAxis = 0,
          yAxis = 0,
          x = datetime_to_timestamp(as.Date("2017/01/02")),
          y = 1.5
        ),
        text = "Some annotation"
      )
    )
  ) %>% 
  hc_xAxis(
    minRange = 1
  ) %>% 
  hc_add_series(
    pointStart = start,
    pointInterval = day,
    data = c(3, 4, 1)
  )


# example 2 ---------------------------------------------------------------
library(xts)

dt <- seq(as.Date("2014/1/30"), as.Date("2018/2/6"), "days")
dt <- dt[!weekdays(dt) %in% c("Saturday", "Sunday")]
n <- length(dt)
x <- xts(rnorm(n), order.by=dt)
y <- xts(rnorm(n), order.by=dt)
z <- xts(rnorm(n), order.by=dt)


highchart(type = "stock") %>% 
  hc_title(text = "Some time series") %>% 
  hc_add_series(x, color='green', name="x", showInLegend = TRUE) %>%
  hc_add_series(y, color='red', name="y", showInLegend = TRUE) %>% 
  hc_add_series(z, color='blue', name="z", showInLegend = TRUE) %>% 
  hc_navigator(enabled=FALSE) %>% 
  hc_scrollbar(enabled=FALSE) %>%
  hc_legend(enabled=TRUE, layout="horizontal") %>%
  hc_add_annotation(
    labels = list(
      list(
        point = list(
          xAxis = 0,
          yAxis = 0,
          x = datetime_to_timestamp(as.Date(index(x)[900])),
          y = 1
        ),
        text = "Hello world! How can I make this work!"
      )
    )
  )
