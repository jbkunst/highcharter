library(magrittr)
library(highcharter)

# Collect stocks date
if (!exists("aapl")) {
  aapl <- quantmod::getSymbols("AAPL", src = "yahoo", from = "2020-01-01", auto.assign = FALSE)
}
if (!exists("msft")) {
  msft <- quantmod::getSymbols("MSFT", src = "yahoo", from = "2020-01-01", auto.assign = FALSE)
}
if (!exists("goog")) {
  goog <- quantmod::getSymbols("GOOG", src = "yahoo", from = "2020-01-01", auto.assign = FALSE)
}
stocks <- list(aapl = aapl, msft = msft, google = goog) 

# Calculate returns and wealth index.
num_colors <- length(stocks)
l <- lapply(stocks, function(x) {
  close <- quantmod::Cl(x)
  returns <- quantmod::dailyReturn(close)
  colnames(returns) <- strsplit(colnames(x)[1], "[.]")[[1]][[1]]
  return(cumsum(returns))
})
x <- do.call(cbind, l)

# Create stacked columns as rows with performance.
df <- data.frame(Date=zoo::index(x), zoo::coredata(x))
df <- data.frame(df[1], utils::stack(df[2:ncol(df)]))

# Construct chart object.
hc <- highchart() %>%
  hc_title(text = "Grouped symbols") %>%
  hc_legend(layout = "vertical", align = "right", verticalAlign = "top") %>%
  hc_xAxis(type = "datetime") %>% 
  hc_chart(zoomType = "x") %>%
  hc_exporting(enabled = FALSE) %>%
  hc_add_yAxis(nid = 1, title = list(text = "Wealth index"), 
    labels = list(format = "{value}%")
  ) %>%
  hc_add_series(df, type = "line", yAxis = 0, lineWidth = 0.5,
    hcaes(x = Date, y = round(values * 100, 2), group = ind)  # percentage rounded
  ) %>% hc_colors(colors = rainbow(num_colors, s = 0.4))

print(hc)
