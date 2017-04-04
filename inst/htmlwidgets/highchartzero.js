HTMLWidgets.widget({

  name: 'highchartzero',

  type: 'output',

  initialize: function(el, width, height) {

    return {
      // TODO: add instance fields as required
    }

  },

  renderValue: function(el, x, instance) {
    
    $("#" + el.id).highcharts(x.hc_opts);
    
  },

  resize: function(el, width, height, instance) {
    
    /* http://stackoverflow.com/questions/18445784/ */
    var chart = $("#" +el.id).highcharts();
    var w = chart.renderTo.clientWidth; 
    var h = chart.renderTo.clientHeight; 
    chart.setSize(w, h); 

  }

});
