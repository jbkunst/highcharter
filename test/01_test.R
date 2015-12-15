library("highcharter")
#### ex 1 ####
hc <- list()
hc$title <- list(title = "This is a title", x = -20)
hc$xAxis <- list(categories = c('Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                                'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'))
hc$series <- list(list(name = "Tokyo",
                       data = c(7.0, 6.9, 9.5, 14.5, 18.2, 21.5, 25.2, 26.5, 23.3, 18.3, 13.9, 9.6)),
                  list(name = "New York",
                       data = c(-0.2, 0.8, 5.7, 11.3, 17.0, 22.0, 24.8, 24.1, 20.1, 14.1, 8.6, 2.5)))
           
highchart(hc)


#### ex 2 ####
hc <- list()
hc$chart <- list(type = "bar")
hc$title <- list(title = "Stacked bar")
hc$xAxis <- list(categories = c('Apples', 'Oranges', 'Pears', 'Grapes', 'Bananas'))
hc$yAxis <- list(min = 0, title = list(text = 'Total Fruit Consumtion'))
hc$legend <- list(reversed = TRUE)
hc$series <- list(list(name = "John", data = c(5, 3, 4, 7, 2)),
                  list(name = "Jane", data = c(2, 2, 3, 2, 1)),
                  list(name = "Joe", data = c(3, 4, 4, 2, 5)))

highchart(hc)

hc$chart <- list(type = "column")
hc$plotOptions <- list(series = list(stacking = "normal"))
highchart(hc)

hc$chart <- list(type = "column", options3d = list(enabled = TRUE, beta = 20, alpha = 20))
highchart(hc)


