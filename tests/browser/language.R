# Rscript tests/browser/language.R /tmp/language.html (with highcharter installed)
library(highcharter)
library(htmltools)

path <- commandArgs(trailingOnly = TRUE)[[1]]
dates <- as.numeric(as.Date(c("2024-01-01", "2025-01-01"))) * 86400000
stock <- function(id) {
  highchart(type = "stock", elementId = id, height = 300, width = 800) |>
    hc_yAxis(tickInterval = 1000) |>
    hc_add_series(data = list(c(dates[1], 1000), c(dates[2], 5000)))
}
options(highcharter.lang = hc_language("es-CL"))
charts <- tagList(stock("es"), stock("pt") |> hc_add_language("pt-BR"))

# Run after htmlwidgets has rendered both charts. Exercise the Spanish chart
# again after the Portuguese one has initialized its own Stock controls.
checks <- tags$script(HTML("
window.addEventListener('load', function() {
  function check(id, expected) {
    var chart = HighcharterWidget.getChart(id);
    chart.xAxis[0].setExtremes(Date.UTC(2024, 2, 1), Date.UTC(2024, 11, 1));
    chart.yAxis[0].setExtremes(0, 7000);
    chart.showResetZoom();
    var range = chart.rangeSelector;
    var actual = [
      chart.time.dateFormat('%B', Date.UTC(2024, 0, 1)),
      chart.numberFormatter(12345.67, 2),
      range.minLabel.textStr, range.maxLabel.textStr,
      range.buttons[range.buttons.length - 1].text.textStr,
      chart.resetZoomButton.text.textStr,
      chart.langFormat('accessibility.exporting.chartMenuLabel', {})
    ];
    if (JSON.stringify(actual) !== JSON.stringify(expected)) {
      throw Error(id + ': ' + JSON.stringify(actual));
    }
  }
  check('es', ['enero', '12.345,67', 'Desde', 'Hasta', 'Todo', 'Restablecer zoom', 'Menú del gráfico']);
  check('pt', ['janeiro', '12.345,67', 'De', 'Até', 'Tudo', 'Redefinir zoom', 'Menu do gráfico']);
  document.body.dataset.languageTest = 'passed';
});"))
save_html(tagList(charts, checks), path)
