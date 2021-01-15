/*
 Highcharts JS v8.2.2 (2020-10-22)

 Dot plot series type for Highcharts

 (c) 2010-2019 Torstein Honsi

 License: www.highcharts.com/license
*/
(function(a){"object"===typeof module&&module.exports?(a["default"]=a,module.exports=a):"function"===typeof define&&define.amd?define("highcharts/modules/dotplot",["highcharts"],function(c){a(c);a.Highcharts=c;return a}):a("undefined"!==typeof Highcharts?Highcharts:void 0)})(function(a){function c(a,c,d,h){a.hasOwnProperty(c)||(a[c]=h.apply(null,d))}a=a?a._modules:{};c(a,"Series/DotplotSeries.js",[a["Core/Series/Series.js"],a["Core/Renderer/SVG/SVGRenderer.js"],a["Core/Utilities.js"]],function(a,
c,d){var h=d.extend,w=d.objectEach,r=d.pick;a.seriesType("dotplot","column",{itemPadding:.2,marker:{symbol:"circle",states:{hover:{},select:{}}}},{markerAttribs:void 0,drawPoints:function(){var a=this,c=a.chart.renderer,d=this.options.marker,l=this.yAxis.transA*a.options.itemPadding,m=this.borderWidth%2?.5:1;this.points.forEach(function(b){var e;var f=b.marker||{};var t=f.symbol||d.symbol,x=r(f.radius,d.radius),u="rect"!==t;b.graphics=e=b.graphics||{};var n=b.pointAttr?b.pointAttr[b.selected?"selected":
""]||a.pointAttr[""]:a.pointAttribs(b,b.selected&&"select");delete n.r;a.chart.styledMode&&(delete n.stroke,delete n["stroke-width"]);if(null!==b.y){b.graphic||(b.graphic=c.g("point").add(a.group));var k=b.y;var v=r(b.stackY,b.y);var p=Math.min(b.pointWidth,a.yAxis.transA-l);for(f=v;f>v-b.y;f--){var g=b.barX+(u?b.pointWidth/2-p/2:0);var q=a.yAxis.toPixels(f,!0)+l/2;a.options.crisp&&(g=Math.round(g)-m,q=Math.round(q)+m);g={x:g,y:q,width:Math.round(u?p:b.pointWidth),height:Math.round(p),r:x};e[k]?e[k].animate(g):
e[k]=c.symbol(t).attr(h(g,n)).add(b.graphic);e[k].isActive=!0;k--}}w(e,function(a,b){a.isActive?a.isActive=!1:(a.destroy(),delete a[b])})})}});c.prototype.symbols.rect=function(a,d,h,l,m){return c.prototype.symbols.callout(a,d,h,l,m)}});c(a,"masters/modules/dotplot.src.js",[],function(){})});
//# sourceMappingURL=dotplot.js.map