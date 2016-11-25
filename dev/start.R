library("highcharter")

#### ex 0 ####
rm(list = ls())
hc <- highchart(debug = TRUE) %>%
  hc_title(text = "Fruit Consumtion") %>% 
  hc_subtitle(text = "This is Legen-Wait For It... DARY! LEGENDARY!") %>% 
  hc_chart(type = "column") %>% 
  hc_xAxis(categories = c("Apples", "Oranges", "Pears", "Grapes", "Bananas")) %>% 
  hc_add_series(name = "Ted Mosby", data = c(3, 4, 4, 2, 5))

hc

hc <- hc %>% 
  hc_add_series(name = "Barney Stinson", data = c(5, 3, 4, 7, 2),
               dataLabels = list(align = "center", enabled = TRUE)) %>% 
  hc_add_series(name = "Marshall Eriksen", data = c(2, 2, 3, 2, 1))

hc

hc <- hc %>%
  hc_chart(type = "column", options3d = list(enabled = TRUE, beta = 15, alpha = 15)) %>% 
  hc_plotOptions(series = list(stacking = "normal"))

hc

#### ex 1 ####
hc_opts <- list()
hc_opts$title <- list(text = "This is a title", x = -20)
hc_opts$xAxis <- list(categories = c('Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                                'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'))
hc_opts$series <- list(list(name = "Tokyo",
                       data = c(7.0, 6.9, 9.5, 14.5, 18.2, 21.5, 25.2, 26.5, 23.3, 18.3, 13.9, 9.6)))

highchart(hc_opts)

hc_opts$series <- append(hc_opts$series,
                    list(list(name = "New York",
                              type = "spline",
                              lineWidth = 5,
                              data = c(-0.2, 0.8, 5.7, 11.3, 17.0, 22.0, 24.8, 24.1, 20.1, 14.1, 8.6, 2.5),
                              dataLabels = list(align = "left", enabled = TRUE))))
highchart(hc_opts)

hc_opts$series <- append(hc_opts$series,
                    list(list(name = "Berlin",
                              type = "column",
                              data = c(-0.9, 0.6, 3.5, 8.4, 13.5, 17.0, 18.6, 17.9, 14.3, 9.0, 3.9, 1.0))))
highchart(hc_opts)


hc_opts$series <- append(hc_opts$series,
                    list(list(name = "London",
                              type = "area",
                              fillOpacity = 0.25,
                              data = c(3.9, 4.2, 5.7, 8.5, 11.9, 15.2, 17.0, 16.6, 14.2, 10.3, 6.6, 4.8))))
highchart(hc_opts)

#### ex 2 ####
hc_opts <- list()
hc_opts$chart <- list(type = "bar")
hc_opts$title <- list(title = "Stacked bar")
hc_opts$xAxis <- list(categories = c('Apples', 'Oranges', 'Pears', 'Grapes', 'Bananas'))
hc_opts$yAxis <- list(min = 0, title = list(text = 'Total Fruit Consumtion'))
hc_opts$legend <- list(reversed = TRUE)
hc_opts$series <- list(list(name = "John", data = c(5, 3, 4, 7, 2)),
                       list(name = "Jane", data = c(2, 2, 3, 2, 1)),
                       list(name = "Joe", data = c(3, 4, 4, 2, 5)))

highchart(hc_opts)

hc_opts$chart <- list(type = "column")
hc_opts$plotOptions <- list(series = list(stacking = "normal"))

highchart(hc_opts)



