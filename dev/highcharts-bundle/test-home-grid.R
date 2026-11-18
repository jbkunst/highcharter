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
        for (attempt in seq_len(300L)) {
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
        if (!isTRUE(ready)) {
          stop(
            "Grid did not become ready: ",
            js(paste0(
              "(()=>{const w=document.querySelector('iframe.home-gallery')?.contentWindow||window;",
              "return JSON.stringify({url:location.href,document:document.readyState,",
              "grid:w.document.querySelector('.transition-grid-page')?.dataset})})()"
            ))
          )
        }
        js(paste0(
          "window.w=document.querySelector('iframe.home-gallery')?.contentWindow||window;",
          "window.g=w.document;window.root=g.querySelector('.transition-grid-page');",
          "window.charts=w.Highcharts.charts.filter(c=>c&&root.contains(c.renderTo));",
          "window.scatter=charts.find(c=>c.renderTo.dataset.family==='countries');",
          "window.map=charts.find(c=>c.renderTo.dataset.family==='map');",
          "window.tradeAreas=charts.find(c=>c.renderTo.dataset.family==='history').series.map(s=>s.area.element);void 0;"
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
        home_signature <- js(paste0(
          "JSON.stringify(charts.map(c=>({caption:c.options.caption.text,",
          "series:c.series.map(s=>({id:s.options.id,",
          "data:s.options.data.map(p=>[p.id,p.x,p.y,p.value,p.z,p.name,p.dataLabels?.format])}))})))"
        ))
        message(
          page,
          " at ",
          width,
          "px: ",
          initial$visible,
          " initial scatter points; no viewport resize or footer"
        )

        if (page == "/") {
          frame <- js(paste0(
            "(()=>{const frame=document.querySelector('iframe.home-gallery');",
            "return {height:frame.clientHeight,content:root.getBoundingClientRect().height,",
            "scroll:g.documentElement.scrollHeight,viewport:g.documentElement.clientHeight,",
            "controls:root.querySelector('.grid-controls').getBoundingClientRect().bottom}})()"
          ))
          stopifnot(
            frame$height >= ceiling(frame$content),
            frame$scroll <= frame$viewport,
            frame$controls <= frame$height
          )
          message(
            "  Full iframe content and controls visible without inner scrolling"
          )
        }

        events <- js(paste0(
          "(()=>{const h=charts.find(c=>c.renderTo.dataset.family==='history');",
          "const box=h.container.getBoundingClientRect();return h.series.flatMap(s=>",
          "s.points.filter(p=>p.options.dataLabels?.enabled).map(p=>{",
          "const label=p.dataLabel.element.getBoundingClientRect();return {",
          "year:p.x,leader:p.y===Math.max(...h.series.map(s=>s.points.find(q=>q.x===p.x).y)),",
          "gap:box.top+h.plotTop+p.plotY-label.bottom,",
          "inside:label.left>=box.left&&label.right<=box.right&&label.top>=box.top,",
          "text:p.dataLabel.element.textContent}}))})()"
        ))
        stopifnot(
          length(events) == 2L,
          setequal(vapply(events, `[[`, numeric(1), "year"), c(2008, 2020)),
          all(vapply(
            events,
            function(e) {
              isTRUE(e$leader) && isTRUE(e$inside) && e$gap >= 16
            },
            logical(1)
          ))
        )
        js(paste0(
          "const percentPicker=root.querySelector('.grid-step');percentPicker.value=1;",
          "percentPicker.dispatchEvent(new w.Event('change'));"
        ))
        percent <- js(paste0(
          "(()=>{const h=charts.find(c=>c.renderTo.dataset.family==='history');",
          "const years=h.series[0].points.map(p=>p.x);",
          "const valid=years.every(year=>{const points=h.series.map(s=>s.points.find(p=>p.x===year));",
          "const total=points.reduce((sum,p)=>sum+p.percentage,0);",
          "const bands=points.map(p=>[Math.min(p.plotY,p.yBottom),Math.max(p.plotY,p.yBottom)]).sort((a,b)=>a[0]-b[0]);",
          "return Math.abs(total-100)<0.001&&bands.every((b,i)=>i===0||bands[i-1][1]<=b[0]+0.1)});",
          "h.tooltip.refresh(h.series.map(s=>s.points.find(p=>p.x===2020)));",
          "const table=g.querySelector('.highcharts-tooltip table');return {valid,",
          "sameAreas:h.series.every((s,i)=>s.area.element===tradeAreas[i]),",
          "stacking:h.series.every(s=>s.options.stacking==='percent'),",
          "min:h.yAxis[0].min,max:h.yAxis[0].max,",
          "rows:table?.rows.length,units:table?.textContent.includes('%')&&",
          "!table?.textContent.includes('trillion')}})()"
        ))
        stopifnot(
          isTRUE(percent$valid),
          isTRUE(percent$sameAreas),
          isTRUE(percent$stacking),
          percent$min == 0,
          percent$max == 100,
          percent$rows == 6L,
          isTRUE(percent$units)
        )
        message("  Crisis point labels and non-overlapping 100% stacks passed")

        js(paste0(
          "const picker=root.querySelector('.grid-step');picker.value=2;",
          "picker.dispatchEvent(new w.Event('change'));"
        ))
        regional <- js(paste0(
          "({center:map.mapView.center,zoom:map.mapView.zoom,",
          "tracking:scatter.series.filter(s=>s.type==='bubble').every(s=>",
          "s.options.enableMouseTracking===(s.name==='South America')),",
          "caption:scatter.options.caption.text,",
          "labels:scatter.series.flatMap(s=>s.points).filter(p=>",
          "p.options.dataLabels?.enabled).map(p=>p.name)})"
        ))
        stopifnot(
          regional$center[1] < -40,
          regional$center[2] < 0,
          regional$zoom > initial$worldZoom + 0.5,
          isTRUE(regional$tracking),
          grepl("South America", regional$caption),
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
      # The canonical article must display the same initial chart data while
      # keeping its full recipe available through native keyboard disclosures.
      browser$Page$navigate(paste0(site, "/articles/from-data-to-charts.html"))
      for (attempt in seq_len(200L)) {
        article_ready <- js(
          "document.querySelectorAll('.transition-grid-page[data-ready=true]').length===4"
        )
        if (isTRUE(article_ready)) {
          break
        }
        Sys.sleep(0.1)
      }
      stopifnot(isTRUE(article_ready))
      article <- js(paste0(
        "(()=>{const charts=Highcharts.charts.filter(Boolean);",
        "const folds=[...document.querySelectorAll('main details')];return {",
        "signature:JSON.stringify(charts.map(c=>({caption:c.options.caption.text,",
        "series:c.series.map(s=>({id:s.options.id,",
        "data:s.options.data.map(p=>[p.id,p.x,p.y,p.value,p.z,p.name,p.dataLabels?.format])}))}))),",
        "folded:folds.length>=6&&folds.every(d=>!d.open),",
        "code:folds[0].textContent.includes('api.worldbank.org'),",
        "visible:charts.every(c=>!c.container.closest('details')&&",
        "c.container.getBoundingClientRect().width>0),",
        "overflow:document.documentElement.scrollWidth>innerWidth}})()"
      ))
      stopifnot(
        identical(article$signature, home_signature),
        isTRUE(article$folded),
        isTRUE(article$code),
        isTRUE(article$visible),
        !article$overflow
      )
      phases <- js(paste0(
        "(()=>{const players=[...document.querySelectorAll('.transition-grid-page')];",
        "return players.every(player=>{const picker=player.querySelector('.grid-step');",
        "const widget=player.querySelector('.html-widget');",
        "for(const stage of ['1','2','3']){picker.value=stage;",
        "picker.dispatchEvent(new Event('change'));if(widget.dataset.phase!==stage)return false;}",
        "player.querySelector('.grid-reset').click();",
        "return players.every(p=>p.querySelector('.html-widget').dataset.phase==='0');});})()"
      ))
      stopifnot(isTRUE(phases))
      js("document.querySelector('main details summary').focus();void 0")
      for (type in c("keyDown", "keyUp")) {
        browser$Input$dispatchKeyEvent(
          type = type,
          key = "Enter",
          code = "Enter",
          text = if (type == "keyDown") "\r" else "",
          windowsVirtualKeyCode = 13,
          nativeVirtualKeyCode = 13
        )
      }
      stopifnot(isTRUE(js("document.querySelector('main details').open")))
      message(
        "  Canonical article data, visible charts and keyboard folding passed"
      )
    }
    message(
      "HOME_GRID_PASSED: cold initial drawing, standalone/iframe, desktop/mobile, South America"
    )
  },
  finally = browser$close()
)
