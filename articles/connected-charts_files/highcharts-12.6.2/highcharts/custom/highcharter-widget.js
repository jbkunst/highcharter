(function(global) {
  // Highcharts 12.6 still reads these labels from its global defaults during
  // render and redraw. Use the owning chart's language for each synchronous call.
  function useChartLanguage(proceed) {
    var defaults = Highcharts.getOptions();
    var previous = defaults.lang;
    defaults.lang = (this.chart || this).options.lang;
    try {
      return proceed();
    } finally {
      defaults.lang = previous;
    }
  }

  // Stock fills button text and titles in place during init. The default
  // buttons are shared by Stock charts, so each chart needs its own copies.
  Highcharts.wrap(Highcharts.RangeSelector.prototype, 'init', function(proceed, chart) {
    var range = chart.options.rangeSelector;
    range.buttons = range.buttons.map(function(button) { return Highcharts.merge(button); });
    return proceed();
  });

  Highcharts.wrap(Highcharts.Axis.prototype, 'defaultLabelFormatter', useChartLanguage);
  Highcharts.wrap(Highcharts.Chart.prototype, 'showResetZoom', useChartLanguage);
  ['drawInput', 'renderButtons', 'updateButtonStates'].forEach(function(method) {
    Highcharts.wrap(Highcharts.RangeSelector.prototype, method, useChartLanguage);
  });

  function getChart(elOrId) {
    var id = typeof elOrId === 'string' ? elOrId : elOrId.id;
    return Highcharts.charts.find(function(chart) {
      return chart && chart.renderTo && chart.renderTo.id === id;
    });
  }

  function connectChart(chart, connection) {
    chart.hcConnection = connection;
    function peers(mode) {
      return Highcharts.charts.filter(other => other && other !== chart &&
        other.hcConnection?.group === connection.group &&
        other.hcConnection.sync.includes(mode));
    }

    if (connection.sync.includes('hover')) {
      let lastX;
      function hover(x) {
        if (x === lastX) return;
        lastX = x;
        for (const other of peers('hover')) {
          const axis = other.xAxis[0];
          if (!axis) continue;
          const points = [];
          if (x !== undefined) {
            for (const s of axis.series) {
              if (!s.visible || s.options.isInternal || s.options.enableMouseTracking === false) continue;
              const p = s.points?.find(p => p && p.x === x && !p.isNull && p.visible !== false);
              if (p) points.push(p);
              if (points.length && !other.tooltip?.shared) break;
            }
          }
          if (points.length) {
            other.tooltip?.refresh(other.tooltip.shared ? points : points[0]);
            axis.drawCrosshair(undefined, points[0]);
          } else {
            other.tooltip?.hide(0);
            axis.hideCrosshair();
          }
        }
      }
      Highcharts.wrap(chart.pointer, 'runPointActions', function(proceed, ...args) {
        proceed.apply(this, args);
        hover(chart.hoverPoint?.x);
      });
      Highcharts.wrap(chart.pointer, 'reset', function(proceed, ...args) {
        proceed.apply(this, args);
        hover(chart.hoverPoint?.x);
      });
    }

    if (connection.sync.includes('zoom') && chart.xAxis[0]) {
      Highcharts.addEvent(chart.xAxis[0], 'afterSetExtremes', function(e) {
        if (e.trigger === 'hc-connect') return;
        const {userMin, userMax} = this.getExtremes();
        const reset = userMin == null && userMax == null;
        for (const other of peers('zoom')) {
          const axis = other.xAxis[0];
          if (!axis) continue;
          axis.setExtremes(userMin, userMax, true, false, {trigger: 'hc-connect'});
          if (!reset && !other.resetZoomButton) other.showResetZoom();
          if (reset && other.resetZoomButton) other.resetZoomButton = other.resetZoomButton.destroy();
        }
      });
    }

    if (connection.sync.includes('legend')) {
      Highcharts.addEvent(chart.legend, 'itemClick', function(e) {
        const item = e.legendItem, id = item.options?.id;
        if (!id || e.defaultPrevented) return;
        for (const other of peers('legend')) {
          other.get(id)?.setVisible?.(!item.visible);
        }
      });
    }
  }

  function prepareMapSeries(options) {
    if (!Array.isArray(options.series)) return;
    options.series = options.series.map(function(series) {
      if (series.geojson === true) {
        var geojson = typeof series.data === 'string' ? JSON.parse(series.data) : series.data;
        return Object.assign({}, series, { data: Highcharts.geojson(geojson, series.type) });
      }
      return series;
    });
  }

  // Highcharts fits polygon and line series, but does not include mappoint bounds.
  function fitGeojsonLayers(options, theme) {
    var series = options.series;
    if (!Array.isArray(series) || options.mapView || (theme && theme.mapView) ||
        (options.chart && options.chart.map) || !series.every(s => s.geojson === true)) return;
    var visible = series.filter(s => s.affectsMapView !== false);
    if (!visible.some(s => s.type === 'mappoint') ||
        !visible.some(s => s.type === 'map' || s.type === 'mapline')) return;

    var west = Infinity, east = -Infinity, south = Infinity, north = -Infinity;
    function visit(coords) {
      if (typeof coords[0] === 'number') {
        west = Math.min(west, coords[0]);
        east = Math.max(east, coords[0]);
        south = Math.min(south, coords[1]);
        north = Math.max(north, coords[1]);
      } else {
        coords.forEach(visit);
      }
    }
    visible.forEach(s => s.data.forEach(p => visit(p.geometry.coordinates)));
    if (west <= east && south <= north) {
      options.mapView = {
        fitToGeometry: { type: 'MultiPoint', coordinates: [[west, south], [east, north]] },
        padding: 8
      };
    }
  }

  function setBackground(el, x) {
    var themeChart = x.theme && x.theme.chart ? x.theme.chart : {};
    var optionsChart = x.hc_opts.chart || {};
    var image = Object.prototype.hasOwnProperty.call(optionsChart, 'divBackgroundImage') ?
      optionsChart.divBackgroundImage : themeChart.divBackgroundImage;
    if (image) {
      el.style.backgroundImage = 'url(' + image + ')';
      el.style.backgroundSize = optionsChart.divBackgroundSize || themeChart.divBackgroundSize || 'cover';
      el.dataset.highcharterBackground = 'true';
    } else if (el.dataset.highcharterBackground) {
      el.style.backgroundImage = '';
      el.style.backgroundSize = '';
      delete el.dataset.highcharterBackground;
    }
  }

  function renderValue(el, x, instance, defaults) {
    ResetHighchartsOptions(defaults);
    Highcharts.setOptions({ exporting: { buttons: { contextButton: { symbol: 'menuball' } } } });
    if (x.theme) Highcharts.setOptions(x.theme);
    setBackground(el, x);
    if (x.conf_opts) Highcharts.setOptions(x.conf_opts);

    // Highcharts reads opposite from each axis's constructor options before
    // applying global theme defaults. Explicit chart options take precedence.
    var options = Object.assign({}, x.hc_opts);
    ['xAxis', 'yAxis'].forEach(function(key) {
      var themeAxis = x.theme && x.theme[key];
      if (!themeAxis || themeAxis.opposite === undefined) return;
      function positionAxis(axis) {
        return Object.assign({ opposite: themeAxis.opposite }, axis);
      }
      options[key] = Array.isArray(options[key]) ?
        options[key].map(positionAxis) : positionAxis(options[key]);
    });

    if (x.connect) {
      if (x.connect.sync.includes('hover')) {
        const axes = Array.isArray(options.xAxis) ? options.xAxis.slice() : [options.xAxis];
        axes[0] = Object.assign({crosshair: true}, axes[0]);
        options.xAxis = axes;
      }
      if (x.connect.sync.includes('zoom')) {
        options.chart = Highcharts.merge({zooming: {type: 'x'}}, options.chart);
      }
    }
    var chart;
    if (x.type === 'stock') {
      chart = Highcharts.stockChart(el, options);
    } else if (x.type === 'map') {
      prepareMapSeries(options);
      fitGeojsonLayers(options, x.theme);
      chart = Highcharts.mapChart(el, options);
    } else if (x.type === 'gantt') {
      chart = Highcharts.ganttChart(el, options);
    } else {
      chart = Highcharts.chart(el, options);
    }

    if (x.hc_opts.motion !== undefined) {
      el.style.position = 'relative';
    }

    // htmlwidgets can fill a Viewer or browser with height: 100%. Highcharts
    // falls back to 400px for that layout when the parent has no inline height.
    // Measure the widget for both htmlwidgets resize and Highcharts' own reflow.
    Highcharts.wrap(chart, 'setSize', function(proceed, width, height, animation) {
      return proceed(
        width == null ? el.clientWidth || undefined : width,
        height == null ? el.clientHeight || undefined : height,
        animation
      );
    });
    if (x.connect) connectChart(chart, x.connect);
    chart.setSize(null, null, false);
  }

  function resize(el) {
    var chart = getChart(el);
    if (chart && chart.options.chart.reflow === true) {
      chart.setSize(null, null, false);
    }
  }

  function sendEvent(target, scope, event) {
    if (!HTMLWidgets.shinyMode) return;
    const series = scope === 'point' ? target.series : target;
    const el = series.chart.renderTo;
    if (series.options.isInternal ||
        !el.matches('.highchart.html-widget-output, .highchartstock.html-widget-output')) return;

    let data = {name: series.name, seriesid: series.options.id};
    if (scope === 'point') {
      // Highcharts fires drag and drop before it applies the new coordinates.
      const position = event.newPoints?.[target.id]?.newValues;
      data = {
        series: series.name,
        seriesid: series.options.id,
        pointid: target.options.id,
        name: target.name,
        x: position?.x ?? target.x,
        y: position?.y ?? target.y,
        category: target.category?.name ?? target.category
      };
    }
    Shiny.setInputValue(el.id + '_' + scope + '_' + event.type, data, {priority: 'event'});
  }

  global.HighcharterWidget = {
    sendEvent: sendEvent,
    initialize: function() { return {}; },
    renderValue: renderValue,
    resize: resize,
    getChart: getChart
  };

  if (HTMLWidgets.shinyMode && !global.HighcharterShinyHandlersRegistered) {
    global.HighcharterShinyHandlersRegistered = true;

    Highcharts.addEvent(Highcharts.Point, 'click', function(event) {
      sendEvent(this, 'point', event);
    });

    Shiny.addCustomMessageHandler('addSeries', function(msg) {
      getChart(msg.id).addSeries(msg.series);
    });
    Shiny.addCustomMessageHandler('removeSeries', function(msg) {
      getChart(msg.id).get(msg.idSeries).remove();
    });
    Shiny.addCustomMessageHandler('removeAllSeries', function(msg) {
      var chart = getChart(msg.id);
      while (chart.series.length) chart.series[0].remove();
    });
    Shiny.addCustomMessageHandler('updateChart', function(msg) {
      getChart(msg.id).update(msg.options);
    });
    Shiny.addCustomMessageHandler('updateSeries', function(msg) {
      getChart(msg.id).get(msg.idSeries).update(msg.options);
    });
    Shiny.addCustomMessageHandler('updatePoint', function(msg) {
      getChart(msg.id).get(msg.idSeries).data[msg.idPoint].update(msg.options);
    });
    Shiny.addCustomMessageHandler('showLoading', function(msg) {
      var chart = getChart(msg.id);
      if (msg.showLoading) chart.showLoading(); else chart.hideLoading();
    });
    Shiny.addCustomMessageHandler('addPoint', function(msg) {
      getChart(msg.id).get(msg.idSeries)
        .addPoint(msg.point, msg.redraw, msg.shift, msg.animation);
    });
    Shiny.addCustomMessageHandler('removePoint', function(msg) {
      getChart(msg.id).get(msg.idSeries).removePoint(msg.i, msg.redraw);
    });
    Shiny.addCustomMessageHandler('setData', function(msg) {
      var chart = getChart(msg.id);
      if (chart) {
        var series = msg.idSeries === null || msg.idSeries === undefined ?
          chart.series[msg.serie] : chart.get(msg.idSeries);
        if (series) {
          series.setData(msg.data, msg.redraw, msg.animation, msg.updatePoints);
        }
      }
    });
    Shiny.addCustomMessageHandler('setExtremes', function(msg) {
      var chart = getChart(msg.id);
      if (!chart) return;
      var axis = typeof msg.axis === 'string' ?
        chart.get(msg.axis) : chart.xAxis[msg.axis];
      if (axis) {
        axis.setExtremes(msg.min, msg.max, msg.redraw, msg.animation);
      }
    });
    Shiny.addCustomMessageHandler('redraw', function(msg) {
      var chart = getChart(msg.id);
      if (chart) chart.redraw();
    });
  }
})(window);
