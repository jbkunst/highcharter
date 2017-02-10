library(data.table)
library(highcharter)

dt <- data.table(x=rep(c("b","a","c"),each=3), y=c(1,3,6), v=1:9)
head(dt)


hchart(dt, "scatter", hcaes(x = v, y))

highchart() %>% 
  hc_add_series(dt, "scatter", hcaes(x = v, y))
