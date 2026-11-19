var HCDefaults = $.extend(true, {}, Highcharts.getOptions(), {});

function ResetHighchartsOptions(defaults = HCDefaults) {
    // Fortunately, Highcharts returns the reference to defaultOptions itself
    // We can manipulate this and delete all the properties
    var defaultOptions = Highcharts.getOptions();
    for (var prop in defaultOptions) {
        if (typeof defaultOptions[prop] !== 'function') delete defaultOptions[prop];
    }
    // Fall back to the defaults that we captured initially, this resets the theme
    Highcharts.setOptions(defaults);
    if (defaults === HCDefaults && window.HCStockToolsDefaults) {
        // Existing Stock toolbars read these options when an indicator is added.
        // Keep navigation bindings and the toolbar itself local to the Stock widget.
        Highcharts.setOptions({
            plotOptions: window.HCStockToolsDefaults.plotOptions,
            lang: window.HCStockToolsDefaults.lang
        });
    }
}
