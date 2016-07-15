library("dplyr")

favorite_bars <- data_frame(
  bar = c("Mclaren's", "McGee's", "P & G",
          "White Horse Tavern", "King Cole Bar"),
  percent = c(30, 28, 27, 12, 3)
)


devtools::use_data(favorite_bars, overwrite = TRUE)

#### favorite_pies ####
favorite_pies <- data_frame(
  pie = c("Strawberry Rhubarb", "Pumpkin", "Lemon Meringue",
          "Blueberry", "Key Lime"),
  percent = c(85, 64, 75, 100, 57)
)

devtools::use_data(favorite_pies, overwrite = TRUE)
