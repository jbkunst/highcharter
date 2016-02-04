library("seasonal")

m <- seas(AirPassengers)

final(m)

plot(m)

summary(m)

class(m)

m <- seas(x = AirPassengers, 
          regression.variables = c("td1coef", "easter[1]", "ao1951.May"), 
          arima.model = "(0 1 1)(0 1 1)", 
          regression.aictest = NULL,
          outlier = NULL, 
          transform.function = "log")

plot(m)

static(m)
static(m, coef = TRUE)

m <- seas(AirPassengers)
fcs <- series(m, "forecast.forecasts")
class(fcs)

hchart(series(seas(AirPassengers), "forecast.forecasts"), color = "red") %>% 
  hc_add_series_ts(AirPassengers) 

m <- seas(AirPassengers, regression.aictest = c("td", "easter"))
plot(m)
plot(m, trend = TRUE)

pacf(resid(m))
spectrum(diff(resid(m)))
plot(density(resid(m)))
qqnorm(resid(m))

inspect(m)
  
