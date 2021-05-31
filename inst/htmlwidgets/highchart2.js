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
      window.elclone = $(el);
      console.log(el);
      console.log("hc_opts", x.hc_opts);
      console.log("theme", x.theme);
      console.log("conf_opts", x.conf_opts);
    }

    if(x.fonts !== undefined) {
      
      x.fonts = ((typeof(x.fonts) == "string") ? [x.fonts] : x.fonts);
    
      x.fonts.forEach(function(s){
        /* http://stackoverflow.com/questions/4724606 */
        var urlfont = 'https://fonts.googleapis.com/css?family=' + s;
        if (!$("link[href='" + urlfont + "']").length) {
          $('<link href="' + urlfont + '" rel="stylesheet" type="text/css">').appendTo("head");
        }
        
      });
      
    }
    
    ResetHighchartsOptions();
    
    if(x.theme !== null) {
      
      if(x.debug) console.log("adding THEME");
      
      Highcharts.setOptions(x.theme);
      
    }
    
    if((x.theme && x.theme.chart.divBackgroundImage !== undefined) |
         (x.hc_opts.chart  && x.hc_opts.chart.divBackgroundImage !== undefined)) {
           
      if(x.debug) console.log("adding BackgroundImage");     
           
      var bkgrnd = x.theme.chart.divBackgroundImage || x.hc_opts.chart.divBackgroundImage;
      
      Highcharts.wrap(Highcharts.Chart.prototype, "getContainer", function (proceed) {
        
        proceed.call(this);
        
        $("#" + el.id).css("background-image", "url(" + bkgrnd + ")");
        $("#" + el.id).css("-webkit-background-size", "cover");
        $("#" + el.id).css("-moz-background-size", "cover");
        $("#" + el.id).css("-o-background-size", "cover");
        $("#" + el.id).css("background-size", "cover");
        
      });
      
    }
    
    Highcharts.setOptions(x.conf_opts);
     
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
