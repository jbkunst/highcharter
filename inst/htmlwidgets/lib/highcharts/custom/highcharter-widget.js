(function(global) {
  function getChart(elOrId) {
    var id = typeof elOrId === 'string' ? elOrId : elOrId.id;
    return Highcharts.charts.find(function(chart) {
      return chart && chart.renderTo && chart.renderTo.id === id;
    });
  }

  function loadFonts(fonts) {
    if (fonts === null || fonts === undefined) return;
    if (typeof fonts === 'string') fonts = [fonts];

    fonts.forEach(function(font) {
      var url = 'https://fonts.googleapis.com/css?family=' + font;
      if (!document.querySelector("link[href='" + url + "']")) {
        var link = document.createElement('link');
        link.href = url;
        link.rel = 'stylesheet';
        link.type = 'text/css';
        document.head.appendChild(link);
      }
    });
  }

  function prepareMapSeries(options, debug) {
    if (!Array.isArray(options.series)) return;
    options.series = options.series.map(function(series) {
      if (series.geojson === true) {
        if (debug) console.log('geojson', series.type, typeof series.series);
        series.data = Highcharts.geojson(series.data, series.type);
      }
      return series;
    });
  }

  function setBackground(el, x) {
    var themeChart = x.theme && x.theme.chart ? x.theme.chart : {};
    var optionsChart = x.hc_opts.chart || {};
    var image = themeChart.divBackgroundImage || optionsChart.divBackgroundImage;
    if (image) {
      el.style.backgroundImage = 'url(' + image + ')';
      el.style.backgroundSize = 'cover';
    }
  }

  function renderValue(el, x) {
    if (x.debug) {
      global.xclone = JSON.parse(JSON.stringify(x));
      global.elclone = el;
      console.log(el);
      console.log('hc_opts', x.hc_opts);
      console.log('theme', x.theme);
      console.log('conf_opts', x.conf_opts);
    }

    loadFonts(x.fonts);
    ResetHighchartsOptions();
    if (x.theme !== null) Highcharts.setOptions(x.theme);
    setBackground(el, x);
    Highcharts.setOptions(x.conf_opts);

    var chart;
    if (x.type === 'stock') {
      chart = Highcharts.stockChart(el, x.hc_opts);
    } else if (x.type === 'map') {
      prepareMapSeries(x.hc_opts, x.debug);
      chart = Highcharts.mapChart(el, x.hc_opts);
    } else if (x.type === 'gantt') {
      chart = Highcharts.ganttChart(el, x.hc_opts);
    } else {
      chart = Highcharts.chart(el, x.hc_opts);
    }

    if (x.hc_opts.motion !== undefined) {
      el.style.position = 'relative';
    }
    chart.setSize(null, null, false);
  }

  function resize(el) {
    var chart = getChart(el);
    if (chart && chart.options.chart.reflow === true) {
      chart.setSize(null, null, false);
    }
  }

  global.HighcharterWidget = {
    initialize: function() { return {}; },
    renderValue: renderValue,
    resize: resize,
    getChart: getChart
  };

  if (HTMLWidgets.shinyMode && !global.HighcharterShinyHandlersRegistered) {
    global.HighcharterShinyHandlersRegistered = true;

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
