HTMLWidgets.widget({

  name: 'highchartzero',

  type: 'output',

  initialize: function(el, width, height) {

    return {
      // TODO: add instance fields as required
    };

  },

  renderValue: function(el, x, instance) {
    
    var defaults = Highcharts.getOptions();
    var previous = defaults.lang;
    if (x.hc_opts.lang) defaults.lang = HCDefaults.lang;
    try {
      $("#" + el.id).highcharts(x.hc_opts);
    } finally {
      defaults.lang = previous;
    }
    
  },

  resize: function(el, width, height, instance) {
    
    /* http://stackoverflow.com/questions/18445784/ */
    var chart = $("#" +el.id).highcharts();
    
    if (chart && chart.options.chart.reflow === true) {  // _check for reflow option_
      chart.setSize(null, null, false);
    }
    
  }

});
