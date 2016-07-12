library(highcharter)

hc <- highcharts_demo()

hc$x$hc_opts
hc$x$theme


options(highcharter.theme = hc_theme_db())

highcharts_demo()

options(highcharter.theme = hc_theme(chart = list(backgroundColor = "transparent")))

highcharts_demo()



options(highcharter.theme = hc_theme_flat())

hc <- highcharts_demo()

options(highcharter.theme = hc_theme_chalk())

hc2 <- highcharts_demo()

options(highcharter.theme = hc_theme_db())

hc3 <- highchart() %>% 
  hc_add_series(data = rexp(100))

htmltools::browsable(hw_grid(hc, hc2, hc3))


opts <- getOption("highcharter.options")
names(opts)

opts1 <- getOption("highcharter.global")
opts2 <- getOption("highcharter.lang")
opts3 <- getOption("highcharter.chart")

optsv <- list(global = opts1, lang = opts2, chart = opts3)

identical(opts, optsv)



.join_hc_opts <- function() {
  list(global = getOption("highcharter.global"),
       lang = getOption("highcharter.lang"),
       chart = getOption("highcharter.chart"))
}
