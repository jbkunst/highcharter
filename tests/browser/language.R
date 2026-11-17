# Rscript tests/browser/language.R /tmp/language.html (with highcharter installed)
library(highcharter)
library(htmltools)

path <- commandArgs(trailingOnly = TRUE)[[1]]
dates <- as.numeric(as.Date(c("2024-01-01", "2025-01-01"))) * 86400000
stock <- function(id) {
  highchart(type = "stock", elementId = id, height = 300, width = 800) |>
    hc_yAxis(tickInterval = 1000) |>
    hc_add_series(data = list(c(dates[1], 1000), c(dates[2], 5000))) |>
    hc_exporting(
      enabled = TRUE,
      buttons = list(
        contextButton = list(
          menuItems = list("downloadCSV", "downloadXLS", "viewData")
        )
      )
    )
}
old <- hc_set_language("es")
spanish <- stock("es")
hc_set_language("pt")
portuguese <- stock("pt")
hc_set_language("fr-FR")
french <- stock("fr")
hc_set_language("nb-NO")
norwegian <- stock("nb")
hc_set_language("ja-JP")
japanese <- stock("ja")
hc_set_language("zh-CN")
chinese <- stock("zh")
hc_set_language("ko-KR")
korean <- stock("ko")
options(old)
charts <- tagList(
  spanish,
  portuguese,
  french,
  norwegian,
  japanese,
  chinese,
  korean
)

# Run after htmlwidgets has rendered every chart. Exercise the Spanish chart
# again after its neighbors have initialized their own Stock controls.
checks <- tags$script(HTML(
  "
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
  check('es', ['enero', '12.345,67', 'Desde', 'Hasta', 'Todo', 'Restablecer zoom', 'Men\\u00fa del gr\\u00e1fico']);
  check('pt', ['janeiro', '12.345,67', 'De', 'At\\u00e9', 'Tudo', 'Redefinir zoom', 'Menu do gr\\u00e1fico']);
  [['fr','fr-FR','T\\u00e9l\\u00e9charger CSV'],['nb','nb-NO','Last ned CSV'],['ja','ja-JP','CSV\\u3092\\u30c0\\u30a6\\u30f3\\u30ed\\u30fc\\u30c9'],['zh','zh-CN','\\u4e0b\\u8f7d CSV'],['ko','ko-KR','CSV \\ub2e4\\uc6b4\\ub85c\\ub4dc']].forEach(item => {
    const chart = HighcharterWidget.getChart(item[0]);
    const instant = Date.UTC(2024, 0, 1);
    const month = new Intl.DateTimeFormat(item[1], {month:'long',timeZone:'UTC'}).format(instant);
    const weekday = new Intl.DateTimeFormat(item[1], {weekday:'long',timeZone:'UTC'}).format(instant);
    if (chart.options.lang.downloadCSV !== item[2] ||
        chart.time.dateFormat('%[B]',instant) !== month ||
        chart.time.dateFormat('%[A]',instant) !== weekday) {
      throw Error(item[0] + ': incorrect date or download translation');
    }
  });
  document.body.dataset.languageTest = 'passed';
});"
))
save_html(tagList(charts, checks), path)
