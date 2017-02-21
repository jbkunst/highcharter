# 274
library(highcharter)
options(highcharter.theme = hc_theme_smpl())


# AnomalyDetection --------------------------------------------------------
library(AnomalyDetection)


data(raw_data)
res = AnomalyDetectionTs(raw_data, max_anoms=0.02, direction='both', plot=TRUE)
res$plot

length(res)
names(res)

str(res$anoms)

head(raw_data)

str(res$anoms)
class(res)


# CausalImpact ------------------------------------------------------------
library(CausalImpact)

set.seed(1)
x1 <- 100 + arima.sim(model = list(ar = 0.999), n = 100)
y <- 1.2 * x1 + rnorm(100)
y[71:100] <- y[71:100] + 10
data <- cbind(y, x1)

pre.period <- c(1, 70)
post.period <- c(71, 100)

impact <- CausalImpact(data, pre.period, post.period)
plot(impact)

names(impact)
names(impact$series)
head(impact$series)
names(impact$summary)
names(impact$report)
names(impact$model)


plot(impact)

library(tidyr)
impact$series %>% 
  as_data_frame() %>% 
  gather(name, value) %>% 
  group_by(name) %>% 
  summarise(data = list(value)) %>% 
  hc_add_series_list(highchart(), .)

series2 <- impact$series %>% 
  as_data_frame() %>% 
  mutate(id = seq(1, nrow(.)))

yaxis <- create_yaxis(naxis = 3)
yaxis <- map2(yaxis, c("original", "pointwise", "cumulative"), function(x, y) {
  # x$title <- list(text = y)
  str(x)
  x
})
class(yaxis) <- "hc_yaxis_list"
plot(impact)
glimpse(series2)
series2

highchart() %>% 
  hc_yAxis_multiples(yaxis) %>% 
  hc_add_series(series2, "line", hcaes(id, response), yAxis = 0, name = "response") %>% 
  hc_add_series(series2, "line", hcaes(id, point.pred), yAxis = 0, name = "response") %>% 
  hc_add_series(series2, "arearange", hcaes(id, low = point.pred.lower, high = point.pred.upper),
                yAxis = 0, name = "response") %>% 
  hc_add_series(series2, "line", hcaes(id, point.effect), yAxis = 1, name = "response") %>% 
  hc_add_series(series2, "arearange", hcaes(id, low = point.effect.lower, high = point.effect.upper),
                yAxis = 1, name = "response") %>% 
  hc_add_series(series2, "line", hcaes(id, cum.effect), yAxis = 2, name = "response") %>% 
  hc_add_series(series2, "arearange", hcaes(id, low = cum.effect.lower, high = cum.effect.upper),
                yAxis = 2, name = "response") %>% 
  hc_tooltip(shared = TRUE) 
