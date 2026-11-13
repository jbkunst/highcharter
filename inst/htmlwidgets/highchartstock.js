HTMLWidgets.widget({
  name: 'highchartstock',
  type: 'output',

  initialize: HighcharterWidget.initialize,

  renderValue: function(el, x, instance) {
    x.type = 'stock';
    x.hc_opts.navigation = x.hc_opts.navigation || {};
    if (x.hc_opts.navigation.iconsURL === undefined) {
      x.hc_opts.navigation.iconsURL =
        window.HighcharterStockToolsBaseUrl + 'gfx/stock-icons/';
    }
    x.hc_opts.stockTools = x.hc_opts.stockTools || {};
    x.hc_opts.stockTools.gui = x.hc_opts.stockTools.gui || {};
    if (x.hc_opts.stockTools.gui.enabled === undefined) {
      x.hc_opts.stockTools.gui.enabled = true;
    }
    HighcharterWidget.renderValue(el, x, instance, window.HCStockToolsDefaults);
  },

  resize: HighcharterWidget.resize
});
