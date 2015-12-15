HTMLWidgets.widget({

  name: 'highchart',

  type: 'output',

  initialize: function(el, width, height) {

    return {
      // TODO: add instance fields as required
    }

  },

  renderValue: function(el, x, instance) {

    console.log(x.hc);
    
    console.log(el.id);
    
     $("#" + el.id).highcharts(x.hc);
    
  },

  resize: function(el, width, height, instance) {

  }

});
