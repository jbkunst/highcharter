library('quantmod')

getSymbols("AAPL")

head(AAPL)
dim(AAPL)
str(AAPL)

chartSeries(AAPL)

getSymbols(c('QQQ','SPY'))    

