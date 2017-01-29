# devtools::install_github("jcheng5/d3scatter")
library(crosstalk)
library(d3scatter)


shared_iris <- SharedData$new(iris)
shared_iris$key()

class(shared_iris)

d3scatter(shared_iris, ~Petal.Length, ~Petal.Width, ~Species)



# blabla ------------------------------------------------------------------
shared_iris <- SharedData$new(iris)

highchart_ct(shared_iris)
