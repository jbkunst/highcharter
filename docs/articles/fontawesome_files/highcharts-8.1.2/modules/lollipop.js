/*
 Highcharts JS v8.1.2 (2020-06-16)

 (c) 2009-2019 Sebastian Bochan, Rafal Sebestjanski

 License: www.highcharts.com/license
*/
(function(a){"object"===typeof module&&module.exports?(a["default"]=a,module.exports=a):"function"===typeof define&&define.amd?define("highcharts/modules/lollipop",["highcharts"],function(b){a(b);a.Highcharts=b;return a}):a("undefined"!==typeof Highcharts?Highcharts:void 0)})(function(a){function b(a,f,b,c){a.hasOwnProperty(f)||(a[f]=c.apply(null,b))}a=a?a._modules:{};b(a,"modules/lollipop.src.js",[a["parts/Globals.js"],a["parts/Utilities.js"]],function(a,b){b=b.seriesType;var e=a.seriesTypes.area.prototype,
c=a.seriesTypes.column.prototype;b("lollipop","dumbbell",{lowColor:void 0,threshold:0,connectorWidth:1,groupPadding:.2,pointPadding:.1,states:{hover:{lineWidthPlus:0,connectorWidthPlus:1,halo:!1}},tooltip:{pointFormat:'<span style="color:{series.color}">\u25cf</span> {series.name}: <b>{point.y}</b><br/>'}},{pointArrayMap:["y"],pointValKey:"y",toYData:function(b){return[a.pick(b.y,b.low)]},translatePoint:e.translate,drawPoint:e.drawPoints,drawDataLabels:c.drawDataLabels,setShapeArgs:c.translate},{pointSetState:e.pointClass.prototype.setState,
setState:a.seriesTypes.dumbbell.prototype.pointClass.prototype.setState,init:function(b,d,c){a.isObject(d)&&"low"in d&&(d.y=d.low,delete d.low);return a.Point.prototype.init.apply(this,arguments)}});""});b(a,"masters/modules/lollipop.src.js",[],function(){})});
//# sourceMappingURL=lollipop.js.map