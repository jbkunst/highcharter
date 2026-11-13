# Rscript tests/browser/themes.R /tmp/themes.html (with highcharter installed)
library(highcharter)
library(htmltools)

hc_set_theme("bloom")
series <- list(list(data = c(1, 3, 2)))
charts <- tagList(
  highchart(elementId = "bloom") |> hc_add_series(data = c(1, 3, 2)),
  highchartzero(elementId = "axes", hc_opts = list(
    series = series, yAxis = list(list(), list(opposite = FALSE))
  )),
  highchart(elementId = "other", theme = hc_theme("ft")) |>
    hc_add_series(data = c(1, 3, 2))
)
checks <- tags$script(HTML("
window.addEventListener('load', function() {
  function sides(id) {
    return HighcharterWidget.getChart(id).yAxis.map(axis => axis.side).join(',');
  }
  if (sides('bloom') !== '1' || sides('axes') !== '1,3' || sides('other') !== '3') {
    throw new Error('Incorrect axis position from theme or chart options');
  }
  document.body.dataset.status = 'passed';
});
"))
save_html(tagList(charts, checks), commandArgs(trailingOnly = TRUE)[[1]])
