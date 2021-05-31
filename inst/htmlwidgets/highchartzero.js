HTMLWidgets.widget({

  name: 'highchartzero',

  type: 'output',

  initialize: function(el, width, height) {

    return {
      // TODO: add instance fields as required
    };

  },

  renderValue: function(el, x, instance) {
    
    $("#" + el.id).highcharts(x.hc_opts);
    
  },

  resize: function(el, width, height, instance) {
    
    /* http://stackoverflow.com/questions/18445784/ */
    var chart = $("#" +el.id).highcharts();
    
    if (chart && chart.options.chart.reflow === true) {  // _check for reflow option_
      var w = chart.renderTo.clientWidth; 
      var h = chart.renderTo.clientHeight; 
      chart.setSize(w, h); 
    }
    
  }

});
