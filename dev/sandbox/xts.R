library("xts")

xtsobj <- xts(stats::runif(100,0,1),
              seq(as.POSIXct("2016-01-04 08:00:00"),
                  as.POSIXct("2016-01-04 08:01:00"),
                  length = 100))

names(xtsobj) <- "price"


timestamps <- time(xtsobj) %>%
  as.POSIXct() %>% 
  as.numeric()
values <- as.numeric(xtsobj)
ds <- list_parse2(data.frame(timestamps, values))

highchart(type = "stock") %>%
  hc_add_series(marker = list(enabled = FALSE),
                data = ds, name = "data") %>% 
  hc_add_series(marker = list(enabled = FALSE),
                data = ds, name = "data2")


