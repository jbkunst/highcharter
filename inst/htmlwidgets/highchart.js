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
      console.log("hc_opts", x.hc_opts);
      console.log("theme", x.theme);
      console.log("conf_opts", x.conf_opts);
      
    }

    if(x.fonts !== undefined) {
      
      x.fonts = ((typeof(x.fonts) == "string") ? [x.fonts] : x.fonts);
    
      x.fonts.forEach(function(s){
        
        var urlfont = 'https://fonts.googleapis.com/css?family=' + s;
        
        /* http://stackoverflow.com/questions/4724606 */
        if (!$("link[href='" + urlfont + "']").length) {
          $('<link href="' + urlfont + '" rel="stylesheet" type="">').appendTo("head");
          
        }
        
      });
      
    }
    
    ResetHighchartsOptions();
    
    if(x.theme !== null) {
      
      Highcharts.setOptions(x.theme);
      
      if(x.theme.chart.divBackgroundImage !== null){
        
        Highcharts.wrap(Highcharts.Chart.prototype, 'getContainer', function (proceed) {
          proceed.call(this);
          $("#" + el.id).css('background-image', 'url(' + x.theme.chart.divBackgroundImage + ')');
          
        });
        
      }
      
    }
    
    Highcharts.setOptions(x.conf_opts);
    
    $("#" + el.id).highcharts(x.hc_opts);
    
  },

  resize: function(el, width, height, instance) {

  }

});
