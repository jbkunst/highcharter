# Rscript tests/browser/stock-tools-inline.R /tmp/stock-tools-inline.html
library(highcharter)

chart <- highchartstock() |>
  hc_add_series(AirPassengers) |>
  htmlwidgets::onRender(
    "function(el) {
    const button = el.querySelector('.highcharts-indicators [style*=background-image]');
    if (!button || !getComputedStyle(button).backgroundImage.includes('data:image/svg+xml')) {
      throw Error('The standalone Stock Tools indicator icon was not embedded');
    }
    document.body.dataset.stockToolsInlineTest = 'passed';
  }"
  )

htmlwidgets::saveWidget(chart, commandArgs(trailingOnly = TRUE)[[1L]])
