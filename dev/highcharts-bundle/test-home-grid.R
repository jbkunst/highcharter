# Build the site first, then run against its local server:
# Rscript dev/highcharts-bundle/test-home-grid.R http://127.0.0.1:8765
# Requires chromote and Chrome. No viewport resize or control interaction is
# allowed before the initial scatter visibility assertions.
library(chromote)

args <- commandArgs(trailingOnly = TRUE)
site <- if (length(args)) sub("/+$", "", args[1]) else "http://127.0.0.1:8765"
browser <- ChromoteSession$new()
tryCatch(
  {
    js <- function(code) {
      result <- browser$Runtime$evaluate(code, returnByValue = TRUE)
      if (!is.null(result$exceptionDetails)) {
        stop(result$exceptionDetails$exception$description)
      }
      result$result$value
    }
    browser$Network$enable()
    browser$Network$setCacheDisabled(cacheDisabled = TRUE)
    browser$Page$addScriptToEvaluateOnNewDocument(
      source = paste0(
        "window.viewportResizes = 0;",
        "window.addEventListener('resize', () => window.viewportResizes++);"
      )
    )
    browser$Emulation$setEmulatedMedia(
      features = list(list(
        name = "prefers-reduced-motion",
        value = "reduce"
      ))
    )

    for (width in c(1280L, 390L)) {
      for (page in c("/", "/home-gallery.html")) {
        # Set the viewport before navigation, never to fix a rendered chart.
        browser$Emulation$setDeviceMetricsOverride(
          width = width,
          height = 1120,
          deviceScaleFactor = 1,
          mobile = FALSE
        )
        url <- paste0(site, page, "?initial-grid=", width)
        browser$Page$navigate(url)
        expected <- jsonlite::toJSON(url, auto_unbox = TRUE)
        for (attempt in seq_len(150L)) {
          ready <- js(paste0(
            "(()=>{try{if(location.href!==",
            expected,
            ")return false;",
            "const w=document.querySelector('iframe.home-gallery')?.contentWindow||window;",
            "return w.document.querySelector('.transition-grid-page')?.dataset.ready==='true'",
            "}catch(e){return false}})()"
          ))
          if (isTRUE(ready)) {
            break
          }
          Sys.sleep(0.1)
        }
        stopifnot(isTRUE(ready))
        js(paste0(
          "window.w=document.querySelector('iframe.home-gallery')?.contentWindow||window;",
          "window.g=w.document;window.root=g.querySelector('.transition-grid-page');",
          "window.charts=w.Highcharts.charts.filter(c=>c&&root.contains(c.renderTo));",
          "window.scatter=charts.find(c=>c.renderTo.dataset.family==='countries');",
          "window.map=charts.find(c=>c.renderTo.dataset.family==='map');void 0;"
        ))
        initial <- js(paste0(
          "(()=>{const series=scatter.series.filter(s=>s.type==='bubble');",
          "const points=series.flatMap(s=>s.points);return {",
          "phase:root.dataset.phase,resizes:window.viewportResizes,",
          "points:points.length,visible:points.filter(p=>p.graphic&&",
          "p.graphic.element.getBoundingClientRect().width>=4&&",
          "w.getComputedStyle(p.graphic.element).visibility!=='hidden').length,",
          "clips:series.every(s=>{const ref=s.group.attr('clip-path');",
          "const id=ref.match(/#([^)'\"]+)/)?.[1];",
          "const rect=id&&g.getElementById(id)?.querySelector('rect');",
          "return rect&&Number(rect.getAttribute('width'))>0&&",
          "Number(rect.getAttribute('height'))>0}),",
          "footer:!!root.querySelector('.grid-source'),",
          "worldZoom:map.mapView.zoom}})()"
        ))
        stopifnot(
          initial$phase == "0",
          initial$resizes == 0L,
          initial$points == 179L,
          initial$visible == initial$points,
          isTRUE(initial$clips),
          !initial$footer
        )
        message(
          page,
          " at ",
          width,
          "px: ",
          initial$visible,
          " initial scatter points; no viewport resize or footer"
        )

        js(paste0(
          "const picker=root.querySelector('.grid-step');picker.value=2;",
          "picker.dispatchEvent(new w.Event('change'));"
        ))
        regional <- js(paste0(
          "({center:map.mapView.center,zoom:map.mapView.zoom,",
          "tracking:scatter.series.filter(s=>s.type==='bubble').every(s=>",
          "s.options.enableMouseTracking===(s.name==='South America')),",
          "story:root.querySelector('.grid-story').textContent,",
          "labels:scatter.series.flatMap(s=>s.points).filter(p=>",
          "p.options.dataLabels?.enabled).map(p=>p.name)})"
        ))
        stopifnot(
          regional$center[1] < -40,
          regional$center[2] < 0,
          regional$zoom > initial$worldZoom + 0.5,
          isTRUE(regional$tracking),
          grepl("South America", regional$story),
          setequal(unlist(regional$labels), c("Chile", "Uruguay"))
        )
        table <- js(paste0(
          "(()=>{const history=charts.find(c=>c.renderTo.dataset.family==='history');",
          "history.tooltip.refresh(history.series.map(s=>s.points.find(p=>p.x===2020)));",
          "const table=g.querySelector('.highcharts-tooltip table');",
          "return {html:history.options.tooltip.useHTML,shared:history.options.tooltip.shared,",
          "rows:table?.rows.length,cells:table&&[...table.rows].every(r=>r.cells.length===2),",
          "units:table?.textContent.includes('trillion')}})()"
        ))
        stopifnot(
          isTRUE(table$html),
          isTRUE(table$shared),
          table$rows == 6L,
          isTRUE(table$cells),
          isTRUE(table$units)
        )
      }
    }
    message(
      "HOME_GRID_PASSED: cold initial drawing, standalone/iframe, desktop/mobile, South America"
    )
  },
  finally = browser$close()
)
