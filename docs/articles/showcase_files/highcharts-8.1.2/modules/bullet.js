/*
 Highcharts JS v8.1.2 (2020-06-16)

 Bullet graph series type for Highcharts

 (c) 2010-2019 Kacper Madej

 License: www.highcharts.com/license
*/
(function(a){"object"===typeof module&&module.exports?(a["default"]=a,module.exports=a):"function"===typeof define&&define.amd?define("highcharts/modules/bullet",["highcharts"],function(d){a(d);a.Highcharts=d;return a}):a("undefined"!==typeof Highcharts?Highcharts:void 0)})(function(a){function d(a,b,n,d){a.hasOwnProperty(b)||(a[b]=d.apply(null,n))}a=a?a._modules:{};d(a,"modules/bullet.src.js",[a["parts/Globals.js"],a["parts/Utilities.js"]],function(a,b){var d=b.isNumber,r=b.merge,k=b.pick,t=b.relativeLength;
b=b.seriesType;var f=a.seriesTypes.column.prototype;b("bullet","column",{targetOptions:{width:"140%",height:3,borderWidth:0},tooltip:{pointFormat:'<span style="color:{series.color}">\u25cf</span> {series.name}: <b>{point.y}</b>. Target: <b>{point.target}</b><br/>'}},{pointArrayMap:["y","target"],parallelArrays:["x","y","target"],drawPoints:function(){var a=this,l=a.chart,b=a.options,n=b.animationLimit||250;f.drawPoints.apply(this);a.points.forEach(function(c){var p=c.options,e=c.targetGraphic,f=c.target,
m=c.y;if(d(f)&&null!==f){var g=r(b.targetOptions,p.targetOptions);var u=g.height;var h=c.shapeArgs;var q=t(g.width,h.width);var v=a.yAxis.translate(f,!1,!0,!1,!0)-g.height/2-.5;h=a.crispCol.apply({chart:l,borderWidth:g.borderWidth,options:{crisp:b.crisp}},[h.x+h.width/2-q/2,v,q,u]);e?(e[l.pointCount<n?"animate":"attr"](h),d(m)&&null!==m?e.element.point=c:e.element.point=void 0):c.targetGraphic=e=l.renderer.rect().attr(h).add(a.group);l.styledMode||e.attr({fill:k(g.color,p.color,a.zones.length&&(c.getZone.call({series:a,
x:c.x,y:f,options:{}}).color||a.color)||void 0,c.color,a.color),stroke:k(g.borderColor,c.borderColor,a.options.borderColor),"stroke-width":g.borderWidth});d(m)&&null!==m&&(e.element.point=c);e.addClass(c.getClassName()+" highcharts-bullet-target",!0)}else e&&(c.targetGraphic=e.destroy())})},getExtremes:function(a){var b=this.targetData;a=f.getExtremes.call(this,a);b&&b.length&&(b=f.getExtremes.call(this,b),d(b.dataMin)&&(a.dataMin=Math.min(k(a.dataMin,Infinity),b.dataMin)),d(b.dataMax)&&(a.dataMax=
Math.max(k(a.dataMax,-Infinity),b.dataMax)));return a}},{destroy:function(){this.targetGraphic&&(this.targetGraphic=this.targetGraphic.destroy());f.pointClass.prototype.destroy.apply(this,arguments)}});""});d(a,"masters/modules/bullet.src.js",[],function(){})});
//# sourceMappingURL=bullet.js.map