HTMLWidgets.widget({

  name: 'highchartct',

  type: 'output',

  initialize: function(el, width, height) {

    return {
      // TODO: add instance fields as required
    }

  },

   factory: function(el, width, height) {

    var firstRun = true;
    var scatter = d3scatter(el).width(width).height(height);

    return {
      renderValue: function(x) {
        var value = x.data;
        scatter
          .x_var(value.x_var)
          .y_var(value.y_var)
          .color_var(value.color_var)
          .color_spec(value.color_spec)
          .x_label(value.x_label)
          .y_label(value.y_label)
          .x_lim(value.x_lim)
          .y_lim(value.y_lim);

        scatter(!firstRun);
        firstRun = false;
      },
      resize: function(width, height) {
        scatter.width(width).height(height)(false);
      }
    };
  }

});
