/*
 Highcharts JS v8.2.2 (2020-10-22)

 Bullet graph series type for Highcharts

 (c) 2010-2019 Kacper Madej

 License: www.highcharts.com/license
*/
(function(a){"object"===typeof module&&module.exports?(a["default"]=a,module.exports=a):"function"===typeof define&&define.amd?define("highcharts/modules/bullet",["highcharts"],function(b){a(b);a.Highcharts=b;return a}):a("undefined"!==typeof Highcharts?Highcharts:void 0)})(function(a){function b(a,k,f,b){a.hasOwnProperty(k)||(a[k]=b.apply(null,f))}a=a?a._modules:{};b(a,"Series/BulletSeries.js",[a["Core/Series/Series.js"],a["Core/Utilities.js"]],function(a,b){var f=b.isNumber,k=b.merge,l=b.pick,r=
b.relativeLength,e=a.seriesTypes.column.prototype;a.seriesType("bullet","column",{targetOptions:{width:"140%",height:3,borderWidth:0},tooltip:{pointFormat:'<span style="color:{series.color}">\u25cf</span> {series.name}: <b>{point.y}</b>. Target: <b>{point.target}</b><br/>'}},{pointArrayMap:["y","target"],parallelArrays:["x","y","target"],drawPoints:function(){var a=this,m=a.chart,b=a.options,t=b.animationLimit||250;e.drawPoints.apply(this);a.points.forEach(function(c){var p=c.options,d=c.targetGraphic,
e=c.target,n=c.y;if(f(e)&&null!==e){var g=k(b.targetOptions,p.targetOptions);var u=g.height;var h=c.shapeArgs;var q=r(g.width,h.width);var v=a.yAxis.translate(e,!1,!0,!1,!0)-g.height/2-.5;h=a.crispCol.apply({chart:m,borderWidth:g.borderWidth,options:{crisp:b.crisp}},[h.x+h.width/2-q/2,v,q,u]);d?(d[m.pointCount<t?"animate":"attr"](h),f(n)&&null!==n?d.element.point=c:d.element.point=void 0):c.targetGraphic=d=m.renderer.rect().attr(h).add(a.group);m.styledMode||d.attr({fill:l(g.color,p.color,a.zones.length&&
(c.getZone.call({series:a,x:c.x,y:e,options:{}}).color||a.color)||void 0,c.color,a.color),stroke:l(g.borderColor,c.borderColor,a.options.borderColor),"stroke-width":g.borderWidth});f(n)&&null!==n&&(d.element.point=c);d.addClass(c.getClassName()+" highcharts-bullet-target",!0)}else d&&(c.targetGraphic=d.destroy())})},getExtremes:function(a){var b=this.targetData;a=e.getExtremes.call(this,a);b&&b.length&&(b=e.getExtremes.call(this,b),f(b.dataMin)&&(a.dataMin=Math.min(l(a.dataMin,Infinity),b.dataMin)),
f(b.dataMax)&&(a.dataMax=Math.max(l(a.dataMax,-Infinity),b.dataMax)));return a}},{destroy:function(){this.targetGraphic&&(this.targetGraphic=this.targetGraphic.destroy());e.pointClass.prototype.destroy.apply(this,arguments)}});""});b(a,"masters/modules/bullet.src.js",[],function(){})});
//# sourceMappingURL=bullet.js.map