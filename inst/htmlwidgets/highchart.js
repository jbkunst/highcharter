HTMLWidgets.widget({

  name: 'highchart',

  type: 'output',

  initialize: function(el, width, height) {

    return {
      // TODO: add instance fields as required
    }

  },

  renderValue: function(el, x, instance) {
    
    if(x.debug) {
      console.log(el);
      console.log(x);
    }
    
    if(x.theme !== null) {
      Highcharts.setOptions(x.theme);
    }
    
    $("#" + el.id).highcharts(x.hc_opts);
    
  },

  resize: function(el, width, height, instance) {

  }

});
