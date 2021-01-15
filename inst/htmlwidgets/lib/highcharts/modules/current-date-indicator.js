/*
 Highcharts Gantt JS v8.2.2 (2020-10-22)

 CurrentDateIndicator

 (c) 2010-2019 Lars A. V. Cabrera

 License: www.highcharts.com/license
*/
(function(a){"object"===typeof module&&module.exports?(a["default"]=a,module.exports=a):"function"===typeof define&&define.amd?define("highcharts/modules/current-date-indicator",["highcharts"],function(b){a(b);a.Highcharts=b;return a}):a("undefined"!==typeof Highcharts?Highcharts:void 0)})(function(a){function b(a,c,b,d){a.hasOwnProperty(c)||(a[c]=d.apply(null,b))}a=a?a._modules:{};b(a,"Extensions/CurrentDateIndication.js",[a["Core/Axis/Axis.js"],a["Core/Utilities.js"],a["Core/Axis/PlotLineOrBand.js"]],
function(a,c,b){var d=c.addEvent,e=c.merge;c=c.wrap;var f={currentDateIndicator:!0,color:"#ccd6eb",width:2,label:{format:"%a, %b %d %Y, %H:%M",formatter:function(a,b){return this.axis.chart.time.dateFormat(b,a)},rotation:0,style:{fontSize:"10px"}}};d(a,"afterSetOptions",function(){var a=this.options,b=a.currentDateIndicator;b&&(b="object"===typeof b?e(f,b):e(f),b.value=new Date,a.plotLines||(a.plotLines=[]),a.plotLines.push(b))});d(b,"render",function(){this.label&&this.label.attr({text:this.getLabelText(this.options.label)})});
c(b.prototype,"getLabelText",function(a,b){var c=this.options;return c.currentDateIndicator&&c.label&&"function"===typeof c.label.formatter?(c.value=new Date,c.label.formatter.call(this,c.value,c.label.format)):a.call(this,b)})});b(a,"masters/modules/current-date-indicator.src.js",[],function(){})});
//# sourceMappingURL=current-date-indicator.js.map