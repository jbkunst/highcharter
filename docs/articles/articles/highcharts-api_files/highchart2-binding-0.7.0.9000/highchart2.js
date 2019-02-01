HTMLWidgets.widget({

  name: 'highchart2',

  type: 'output',

  initialize: function(el, width, height) {

    return {
      // TODO: add instance fields as required
    };

  },

  renderValue: function(el, x, instance) {
    
    if(x.debug) {
      window.xclone = JSON.parse(JSON.stringify(x));
      console.log(el);
      console.log("theme", x.theme);
      console.log("conf_opts", x.conf_opts);
    }

    
    if(x.fonts !== undefined) {
      
      x.fonts = ((typeof(x.fonts) == "string") ? [x.fonts] : x.fonts);
    
      x.fonts.forEach(function(s){
        var urlfont = 'https://fonts.googleapis.com/css?family=' + s;
        // http://stackoverflow.com/questions/4724606 
        if (!$("link[href='" + urlfont + "']").length) {
          $('<link href="' + urlfont + '" rel="stylesheet" type="text/css">').appendTo("head");
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
    

    
    
    $("#" + el.id).highcharts(x.hc_opts);
     
  },

  resize: function(el, width, height, instance) {
    
    /* http://stackoverflow.com/questions/18445784/ */
    var chart = $("#" +el.id).highcharts();
    var height = chart.renderTo.clientHeight; 
    var width = chart.renderTo.clientWidth; 
    chart.setSize(width, height); 

  }

});
