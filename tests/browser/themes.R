# Rscript tests/browser/themes.R /tmp/themes.html (with highcharter installed)
library(highcharter)
library(htmltools)

hc_set_theme("bloom")
series <- list(list(data = c(1, 3, 2)))
charts <- tagList(
  highchart(elementId = "bloom") |> hc_add_series(data = c(1, 3, 2)),
  highchart(
    elementId = "axes",
    hc_opts = list(
      series = series,
      yAxis = list(list(), list(opposite = FALSE))
    )
  ),
  highchart(elementId = "other", theme = hc_theme("ft")) |>
    hc_add_series(data = c(1, 3, 2))
)
charts <- tagList(
  charts,
  lapply(c("hcrt", "smpl", "carbon", "cloudscape"), function(name) {
    tagList(
      highchart(theme = hc_theme(name), elementId = paste0(name, "-points")) |>
        hc_chart(type = "scatter") |>
        hc_add_series(data = c(1, 3, 2)) |>
        hc_add_series(data = c(2, 1, 3)),
      highchart(theme = hc_theme(name), elementId = paste0(name, "-cells")) |>
        hc_add_series(
          type = "heatmap",
          data = list(list(0, 0, 1), list(1, 0, 2))
        )
    )
  })
)
checks <- tags$script(HTML(
  "
window.addEventListener('load', function() {
  function sides(id) {
    return HighcharterWidget.getChart(id).yAxis.map(axis => axis.side).join(',');
  }
  if (sides('bloom') !== '1' || sides('axes') !== '1,3' || sides('other') !== '3') {
    throw new Error('Incorrect axis position from theme or chart options');
  }
  ['hcrt', 'smpl', 'carbon', 'cloudscape'].forEach(name => {
    const scatter = HighcharterWidget.getChart(name + '-points');
    const heatmap = HighcharterWidget.getChart(name + '-cells');
    if (!scatter.series.every(series => series.symbol === 'circle') ||
        heatmap.series[0].options.marker.symbol !== 'rect') {
      throw new Error(name + ': circles must not override rectangular heatmap cells');
    }
  });
  document.body.dataset.status = 'passed';
});
"
))
save_html(tagList(charts, checks), commandArgs(trailingOnly = TRUE)[[1]])
