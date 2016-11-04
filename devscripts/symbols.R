#+ include=FALSE
library(highcharter)
library(purrr)
library(dplyr)

#+include=TRUE
options(highcharter.theme = hc_theme_smpl())

dss <- map(c("cross", "plus"), function(s){
  
  x <- rnorm(20, runif(1)*2)
  y <- (rnorm(1) + 1)*x + runif(20)
  
  list(name = s,
       type = "scatter",
       data = list_parse(data_frame(x, y)),
       marker = list(symbol = s, enabled = TRUE))
  
})


highchart() %>% 
  hc_add_series_list(dss)

library(survival)

leukemia.surv <- survfit(Surv(time, status) ~ x, data = aml) 
hchart(leukemia.surv)


# Plot the cumulative hazard function
lsurv2 <- survfit(Surv(time, status) ~ x, aml, type='fleming') 
hchart(lsurv2, fun="cumhaz")

# Plot the fit of a Cox proportional hazards regression model
fit <- coxph(Surv(futime, fustat) ~ age, data = ovarian)
ovarian.surv <- survfit(fit, newdata=data.frame(age=60))
hchart(ovarian.surv, ranges = TRUE)
