# Chart example data

`spy-2025.csv` is a fixed snapshot of daily SPDR S&P 500 ETF Trust (SPY)
OHLC, volume and adjusted-close values from Yahoo Finance. Downloaded on
2026-11-16 with:

```r
x <- quantmod::getSymbols("SPY", from = "2025-01-01", to = "2026-01-01",
                         auto.assign = FALSE)
write.csv(data.frame(date = as.Date(zoo::index(x)), zoo::coredata(x)),
          "dev/examples-charts/data/spy-2025.csv", row.names = FALSE)
```

It supplies 250 trading days for the closing Stock dashboard. That example
adjusts OHLC using the supplied adjusted close and retains the reported volume.
Source: https://finance.yahoo.com/quote/SPY/history/

`world-tile-grid.csv` supplies the specialized tile-map example. Official
map boundaries and their provenance are described in [maps/README.md](maps/README.md).
