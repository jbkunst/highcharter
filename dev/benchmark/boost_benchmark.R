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
df <- data.frame(date=zoo::index(x), zoo::coredata(x))
df <- data.frame(df[1], utils::stack(df[2:ncol(df)]))
l <- apply(df, MARGIN = 2, function(x) return(x))
df_char <- cbind.data.frame(l, stringsAsFactors = FALSE)

# Wrapper to test the performance.
list_parse_wrapper <- function(x, boost = FALSE) {
  options("highcharter.boost" = boost)
  list_parse(x)
}
add_series_wrapper <- function(x, boost = FALSE) {
  # Call add series for group logic.
  options("highcharter.boost" = boost)
  hc <- highchart() %>%
    hc_add_series(x, type = "line",
      hcaes(x = date, y = values, group = ind)
    )
}

# Performance test scenarios on list_parse().
list_parse_org_with_factor <- function() { list_parse_wrapper(df, FALSE) }
list_parse_org_no_factor <- function() { list_parse_wrapper(df_char, FALSE) }
list_parse_boost_no_factor <- function() { list_parse_wrapper(df_char, TRUE) }
list_parse_boost_with_factor <- function() { list_parse_wrapper(df, TRUE) }

# Performance test scenarios on list_parse() with grouped series.
add_series_org_group <- function() { add_series_wrapper(df_char, FALSE) }
add_series_boost_group <- function() { add_series_wrapper(df_char, TRUE) }

# Run benchmark tests.
res <- microbenchmark::microbenchmark(
  list_parse_org_with_factor(),
  list_parse_boost_with_factor(),
  list_parse_org_no_factor(),
  list_parse_boost_no_factor(),
  add_series_org_group(),
  add_series_boost_group(),
  times = 10
)

print(res)
