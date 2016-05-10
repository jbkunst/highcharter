# http://robjhyndman.com/hyndsight/forecast7-ggplot2/

library(highcharter)
suppressPackageStartupMessages(library(forecast))
library(ggplot2)

options(highcharter.theme = hc_theme_smpl())

# autoplot of a ts object
autoplot(mdeaths)
hchart(mdeaths, name = "Male Deaths")


# autoplot of a forecast object
fc <- forecast(fdeaths)
autoplot(fc)
hchart(fc)


# autoplot of an stl object
autoplot(stl(mdeaths, s.window = "periodic", robust = TRUE))
hchart(stl(mdeaths, s.window = "periodic", robust = TRUE))
tas


# Plotting multiple forecasts in one plot
fmdeaths <- cbind(Males = mdeaths, Females = fdeaths)
fit <- tslm(fmdeaths ~ trend + season)
fcast <- forecast(fit, h = 10)
autoplot(fcast)
hchart(fcast)


# Plotting the components of an ETS model
fit <- ets(mdeaths)
autoplot(fit)
hchart(fit)


# Plotting the inverse characteristic roots of an ARIMA model
fit <- auto.arima(mdeaths, D = 1)
autoplot(fit)
# not yet


# acf and pacf
ggAcf(mdeaths, main = "")
hchart(acf(mdeaths, plot = FALSE, lag.max = 24))


ggPacf(mdeaths, main = "")
hchart(pacf(mdeaths, plot = FALSE, lag.max = 24))


# object <- cbind(mdeaths, fdeaths)
# hchart(object)
# hchart(object, heights = c(4, 1))
# hchart(object, separate = FALSE)
