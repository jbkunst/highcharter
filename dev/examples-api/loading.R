# Simulate a short wait so the loading overlay and both fades are visible.
highcharts_demo() |>
  hc_loading(showDuration = 200, hideDuration = 300) |>
  hc_chart(events = list(load = htmlwidgets::JS("function () {
    const chart = this;
    chart.showLoading('Loading temperatures...');
    setTimeout(function () {
      if (chart.container) chart.hideLoading();
    }, 1200);
  }")))
