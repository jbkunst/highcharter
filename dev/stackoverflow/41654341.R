library(data.table)
library(highcharter)
options(highcharter.theme = hc_theme_smpl())

mydata <- data.table(
  year = rep(2001:2015,3),
  car = c(rep('BMW',15),
          rep('VW',15),
          rep('AUDI',15)),
  sales = c(50000*rnorm(n = 15,mean = 1,sd = .8),
            30000*rnorm(n = 15,mean = 1,sd = .6),
            60000*rnorm(n = 15,mean = 1,sd = .2)),
  polution = c(1*rnorm(n = 15,mean = 1,sd = .8),
               5*rnorm(n = 15,mean = 1,sd = .6),
               2*rnorm(n = 15,mean = 1,sd = .2)))

mydata

library(tidyr)
library(dplyr)
library(dtplyr)

mydata2 <- gather(mydata, key, value, -year, -car)
mydata2 <- tbl_df(mydata2)
mydata2

myseries <- mydata2 %>%
  group_by(car, key) %>% 
  do(data = list_parse2(data.frame(.$year, .$value))) %>% 
  ungroup()

myseries <- mutate(
  myseries,
  name = car,
  auxvar = rep(c(TRUE, FALSE), 3), # auxiliar var
  id = ifelse(auxvar, tolower(name), NA),
  linkedTo = ifelse(!auxvar, tolower(name), NA),
  yAxis = ifelse(!auxvar, 0, 1),
  color = colorize(name)
  )

myseries


highchart() %>% 
  hc_add_series_list(myseries) %>% 
  hc_yAxis_multiples(list(
    title=list(text="MM $"),
    align= "right",
    top = "0%",
    height = "60%",
    showFirstLabel=FALSE,
    showLastLabel=FALSE,
    opposite=FALSE
  ),
  list(
    title=list(text="Polution"),
    align= "left",
    top = "61%",
    height = "39%",
    showFirstLabel=FALSE,
    showLastLabel=FALSE,
    opposite=T,
    labels = list(format = "{value}%")
    ))
