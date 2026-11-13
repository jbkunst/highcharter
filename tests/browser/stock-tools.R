# Rscript tests/browser/stock-tools.R /tmp/stock-tools.html
library(highcharter)
library(htmltools)

plain <- highchart(type = "stock", elementId = "plain") |>
  hc_add_series(AirPassengers)
tools <- highchartstock(elementId = "tools") |>
  hc_add_series(AirPassengers) |>
  hc_stockTools(gui = list(buttons = c("zoomChange", "fullScreen")))

checks <- tags$script(HTML("
window.addEventListener('load', function () {
  const plain = Highcharts.charts.find(c => c && c.renderTo.id === 'plain');
  const tools = Highcharts.charts.find(c => c && c.renderTo.id === 'tools');
  const toolbar = tools && tools.stockTools && tools.stockTools.listWrapper;
  if (!plain || !plain.hasRendered || plain.stockTools?.guiEnabled ||
      !toolbar?.querySelector('.highcharts-zoom-x') ||
      !toolbar.querySelector('.highcharts-full-screen')) {
    throw Error('Unexpected Stock Tools toolbar or missing chart');
  }
  document.body.dataset.stockToolsTest = 'passed';
});
"))
save_html(tagList(plain, tools, checks), commandArgs(trailingOnly = TRUE)[[1L]])
