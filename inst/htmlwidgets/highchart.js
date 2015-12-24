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

    if(x.fonts !== undefined) {
      
      x.fonts = ((typeof(x.fonts) == "string") ? [x.fonts] : x.fonts);
    
      x.fonts.forEach(function(s){
        Highcharts.createElement('link', {
        href: 'https://fonts.googleapis.com/css?family=' + s,
        rel: 'stylesheet',
        type: 'text/css'
        }, null, document.getElementsByTagName('head')[0]);
        
      });
      
    }
    
    if(x.theme !== null) {
      
      ResetHighchartsOptions();
      
      Highcharts.setOptions(x.theme);
      
      if(x.theme.chart.divBackgroundImage !== null){
        
        Highcharts.wrap(Highcharts.Chart.prototype, 'getContainer', function (proceed) {
          proceed.call(this);
          $("#" + el.id).css('background-image', 'url(' + x.theme.chart.divBackgroundImage + ')');
        });
        
      }
      
    }
    
    $("#" + el.id).highcharts(x.hc_opts);
    
  },

  resize: function(el, width, height, instance) {

  }

});
