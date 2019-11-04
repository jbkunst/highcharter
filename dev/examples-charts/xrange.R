library(lubridate)

N <- 7
set.seed(1234)
df <- data_frame(
  start = Sys.Date() + months(sample(10:20, size = N)),
  end = start + months(sample(1:3, size = N, replace = TRUE)),
  cat = rep(1:5, length.out = N) - 1,
  progress = round(runif(N), 1)
)

df <- mutate_if(df, is.Date, datetime_to_timestamp)

hchart(df, "xrange", hcaes(x = start, x2 = end, y = cat, partialFill = progress),
       dataLabels = list(enabled = TRUE)) %>% 
  hc_xAxis(type = "datetime") %>% 
  hc_yAxis(categories = c("Prototyping", "Development", "Testing", "Validation", "Modelling"))
