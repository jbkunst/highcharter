# Run from the repository root: Rscript tests/browser/sizing.R
pkgload::load_all(".", quiet = TRUE)
options(highcharter.google_fonts = FALSE)

check_sizing <- function() {
  directory <- tempfile("highcharter-sizing-")
  dir.create(directory)
  on.exit(unlink(directory, recursive = TRUE), add = TRUE)
  chart <- highchart(elementId = "fluid") |>
    hc_add_series(data = c(1, 3, 2))
  path <- file.path(directory, "fluid.html")
  htmlwidgets::saveWidget(chart, path, selfcontained = FALSE)

  browser <- chromote::ChromoteSession$new()
  on.exit(browser$close(), add = TRUE)
  evaluate <- function(js) {
    result <- browser$Runtime$evaluate(
      js,
      awaitPromise = TRUE,
      returnByValue = TRUE
    )
    if (!is.null(result$exceptionDetails)) {
      stop(result$exceptionDetails$text)
    }
    result$result$value
  }
  wait_for <- function(condition) {
    evaluate(paste0(
      "new Promise((resolve, reject) => {
      const deadline = Date.now() + 5000;
      const timer = setInterval(() => {
        if (",
      condition,
      ") { clearInterval(timer); resolve(true); }
        else if (Date.now() > deadline) {
          clearInterval(timer); reject(new Error('Sizing check timed out'));
        }
      }, 20);
    })"
    ))
  }
  viewport <- function(width, height) {
    browser$Emulation$setDeviceMetricsOverride(
      width = as.integer(width),
      height = as.integer(height),
      deviceScaleFactor = 1,
      mobile = FALSE
    )
  }
  fits <- "(() => {
    const c = window.Highcharts && Highcharts.charts.find(c => c);
    return c && c.hasRendered && Math.abs(c.chartWidth - c.renderTo.clientWidth) <= 1 &&
      Math.abs(c.chartHeight - c.renderTo.clientHeight) <= 1;
  })()"
  for (mode in c("browser", "viewer")) {
    viewport(1200, 900)
    browser$Page$navigate(paste0(
      "file:///",
      normalizePath(path, winslash = "/"),
      if (mode == "viewer") "?viewer_pane=1" else ""
    ))
    wait_for(fits)
    stopifnot(evaluate("Highcharts.charts.find(c => c).chartHeight") == 900)
    viewport(800, 650)
    wait_for(paste0(
      fits,
      " && Highcharts.charts.find(c => c).chartHeight === 650"
    ))
    viewport(1200, 1000)
    wait_for(paste0(
      fits,
      " && Highcharts.charts.find(c => c).chartHeight === 1000"
    ))
    message(mode, ": fills viewport and follows shrinking and growing")
  }

  widgets <- list(
    highchart(elementId = "chart"),
    highchart(type = "stock", elementId = "stock"),
    highchart(type = "map", elementId = "map"),
    highchart(type = "gantt", elementId = "gantt"),
    highchartstock(elementId = "tools")
  )
  panels <- lapply(widgets, function(widget) {
    htmltools::tags$div(
      class = "panel",
      style = "width: 600px; height: 520px;",
      htmlwidgets::onRender(
        widget,
        "function(el) { el.style.height = '100%'; }"
      )
    )
  })
  panels <- c(
    panels,
    list(
      highchart(width = 480, height = 280, elementId = "explicit") |>
        hc_add_series(data = c(1, 3, 2)),
      highchart(width = 480, height = 280, elementId = "fixed") |>
        hc_chart(reflow = FALSE)
    )
  )
  path <- file.path(directory, "mixed.html")
  htmltools::save_html(htmltools::tagList(panels), path)
  browser$Page$navigate(paste0("file:///", normalizePath(path, winslash = "/")))
  all_fit <- "Highcharts.charts.filter(c => c).length === 7 &&
    Highcharts.charts.filter(c => c).every(c =>
      Math.abs(c.chartWidth - c.renderTo.clientWidth) <= 1 &&
      Math.abs(c.chartHeight - c.renderTo.clientHeight) <= 1)"
  wait_for(paste0("window.Highcharts && ", all_fit))
  stopifnot(
    evaluate("HighcharterWidget.getChart('explicit').chartHeight") == 280
  )
  evaluate(
    "document.querySelectorAll('.panel').forEach(p => {
    p.style.width = '420px'; p.style.height = '700px';
  })"
  )
  wait_for(paste0(
    all_fit,
    " && HighcharterWidget.getChart('chart').chartHeight === 700"
  ))
  evaluate("document.querySelector('.panel').style.display = 'none'")
  evaluate("new Promise(resolve => setTimeout(resolve, 100))")
  evaluate(
    "const panel = document.querySelector('.panel');
    panel.style.height = '360px'; panel.style.display = 'block';"
  )
  wait_for(paste0(
    all_fit,
    " && HighcharterWidget.getChart('chart').chartHeight === 360"
  ))
  evaluate(
    "const fixed = document.getElementById('fixed'); fixed.style.height = '500px';"
  )
  evaluate("new Promise(resolve => setTimeout(resolve, 200))")
  stopifnot(evaluate("HighcharterWidget.getChart('fixed').chartHeight") == 280)
  message(
    "Mixed widgets: container resize, hidden panels, explicit sizes and reflow opt-out passed"
  )
}

check_sizing()
