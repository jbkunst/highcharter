# Rscript tests/browser/tooltip-charts.R /tmp/tooltips.html
library(highcharter)
library(htmltools)

formatter <- tooltip_chart(
  "trend-values",
  hc_opts = list(
    chart = list(
      events = list(load = JS("function () { this.callbackRan = true; }"))
    ),
    title = list(text = "point.name"),
    series = list(list(), list(data = c(10, 20), color = "#334455"))
  ),
  width = 180,
  height = 95
)
widget <- function(id, offset) {
  points <- lapply(1:2, function(i) {
    list(
      name = paste(id, i),
      y = i,
      color = "#226699",
      `trend-values` = offset + i + 1:2
    )
  })
  highchart(elementId = id) |>
    hc_add_series(data = points) |>
    hc_tooltip(useHTML = TRUE, pointFormatter = formatter)
}

checks <- tags$script(HTML(
  "
window.addEventListener('load', async function () {
  const charts = ['north', 'south'].map(id => HighcharterWidget.getChart(id));
  for (const i of [0, 1, 0]) {
    for (const chart of charts) {
      const point = chart.series[0].points[i];
      chart.tooltip.refresh(point);
      await new Promise(resolve => setTimeout(resolve, 0));
      const mini = Highcharts.charts.find(c =>
        c && c !== chart && chart.renderTo.contains(c.renderTo));
      if (!mini || !mini.callbackRan || mini.options.title.text !== point.name ||
          mini.chartWidth !== 180 || mini.chartHeight !== 95 ||
          mini.series[0].color !== point.color ||
          String(mini.series[0].getColumn('y')) !== String(point['trend-values']) ||
          String(mini.series[1].getColumn('y')) !== '10,20' ||
          mini.series[1].color !== '#334455') {
        throw Error('Incorrect tooltip for ' + point.name);
      }
    }
  }
  if (Highcharts.charts.filter(Boolean).length !== 4) throw Error('Stale tooltip chart');
  charts.forEach(chart => chart.destroy());
  if (Highcharts.charts.some(Boolean)) throw Error('Tooltip survived its parent');
  document.body.dataset.tooltipTest = 'passed';
});
"
))
save_html(
  tagList(widget("north", 10), widget("south", 30), checks),
  commandArgs(trailingOnly = TRUE)[[1]]
)
