library("dplyr")
citytemp <- data_frame(
  month = month.abb,
  tokyo = c(7.0, 6.9, 9.5, 14.5, 18.2, 21.5, 25.2, 26.5, 23.3, 18.3, 13.9, 9.6),
  new_york = c(-0.2, 0.8, 5.7, 11.3, 17.0, 22.0, 24.8, 24.1, 20.1, 14.1, 8.6, 2.5),
  berlin = c(-0.9, 0.6, 3.5, 8.4, 13.5, 17.0, 18.6, 17.9, 14.3, 9.0, 3.9, 1.0),
  london = c(3.9, 4.2, 5.7, 8.5, 11.9, 15.2, 17.0, 16.6, 14.2, 10.3, 6.6, 4.8))

save(citytemp, file = "data/citytemp.rda")


favorite_bars <- data_frame(
  bar = c("Mclaren's", "McGee's", "P & G",
          "White Horse Tavern", "King Cole Bar"),
  percent = c(30, 28, 27, 12, 3)
  )

save(favorite_bars, file = "data/favorite_bars.rda")

favorite_pies <- data_frame(
  pie = c("Strawberry Rhubarb", "Pumpkin", "Lemon Meringue",
          "Blueberry", "Key Lime"),
  percent = c(85, 64, 75, 100, 57)
  )

save(favorite_pies, file = "data/favorite_pies.rda")
