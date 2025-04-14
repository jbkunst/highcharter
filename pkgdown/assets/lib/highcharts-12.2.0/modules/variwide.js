!function(t,s){"object"==typeof exports&&"object"==typeof module?module.exports=s(t._Highcharts,t._Highcharts.SeriesRegistry):"function"==typeof define&&define.amd?define("highcharts/modules/variwide",["highcharts/highcharts"],function(t){return s(t,t.SeriesRegistry)}):"object"==typeof exports?exports["highcharts/modules/variwide"]=s(t._Highcharts,t._Highcharts.SeriesRegistry):t.Highcharts=s(t.Highcharts,t.Highcharts.SeriesRegistry)}("undefined"==typeof window?this:window,(t,s)=>(()=>{"use strict";var i={512:t=>{t.exports=s},944:s=>{s.exports=t}},e={};function r(t){var s=e[t];if(void 0!==s)return s.exports;var o=e[t]={exports:{}};return i[t](o,o.exports,r),o.exports}r.n=t=>{var s=t&&t.__esModule?()=>t.default:()=>t;return r.d(s,{a:s}),s},r.d=(t,s)=>{for(var i in s)r.o(s,i)&&!r.o(t,i)&&Object.defineProperty(t,i,{enumerable:!0,get:s[i]})},r.o=(t,s)=>Object.prototype.hasOwnProperty.call(t,s);var o={};r.d(o,{default:()=>S});var a=r(944),h=r.n(a),n=r(512),l=r.n(n);let{composed:p}=h(),{addEvent:c,pushUnique:d,wrap:x}=h();function f(t){this.variwide&&this.cross&&this.cross.attr("stroke-width",t.point?.crosshairWidth)}function u(){let t=this;this.variwide&&this.chart.labelCollectors.push(function(){return t.tickPositions.filter(s=>!!t.ticks[s].label).map((s,i)=>{let e=t.ticks[s].label;return e.labelrank=t.zData[i],e})})}function g(t){let s=this.axis,i=s.horiz?"x":"y";s.variwide&&(this[i+"Orig"]=t.pos[i],this.postTranslate(t.pos,i,this.pos))}function y(t,s,i){let e=this.axis,r=t[s]-e.pos;e.horiz||(r=e.len-r),r=e.series[0].postTranslate(i,r),e.horiz||(r=e.len-r),t[s]=e.pos+r}function v(t,s,i,e,r,o,a,h){let n=Array.prototype.slice.call(arguments,1),l=r?"x":"y";this.axis.variwide&&"number"==typeof this[l+"Orig"]&&(n[+!r]=this[l+"Orig"]);let p=t.apply(this,n);return this.axis.variwide&&this.axis.categories&&this.postTranslate(p,l,this.pos),p}let{column:{prototype:{pointClass:w}}}=l().seriesTypes,{isNumber:m}=h(),{column:b}=l().seriesTypes,{addEvent:A,crisp:T,extend:k,merge:P,pick:O}=h();class z extends b{processData(t){this.totalZ=0,this.relZ=[],l().seriesTypes.column.prototype.processData.call(this,t);let s=this.getColumn("z");(this.xAxis.reversed?s.slice().reverse():s).forEach(function(t,s){this.relZ[s]=this.totalZ,this.totalZ+=t},this),this.xAxis.categories&&(this.xAxis.variwide=!0,this.xAxis.zData=s)}postTranslate(t,s,i){let e=this.xAxis,r=this.relZ,o=e.reversed?r.length-t:t,a=e.reversed?-1:1,h=e.toPixels(e.reversed?(e.dataMax||0)+e.pointRange:e.dataMin||0),n=e.toPixels(e.reversed?e.dataMin||0:(e.dataMax||0)+e.pointRange),l=Math.abs(n-h),p=this.totalZ,c=this.chart.inverted?n-(this.chart.plotTop-a*e.minPixelPadding):h-this.chart.plotLeft-a*e.minPixelPadding,d=o/r.length*l,x=(o+a)/r.length*l,f=O(r[o],p)/p*l,u=O(r[o+a],p)/p*l;return i&&(i.crosshairWidth=u-f),c+f+(s-(c+d))*(u-f)/(x-d)}translate(){this.crispOption=this.options.crisp,this.options.crisp=!1,super.translate(),this.options.crisp=this.crispOption}correctStackLabels(){let t,s,i,e,r=this.options,o=this.yAxis;for(let a of this.points)e=a.x,s=a.shapeArgs.width,(i=o.stacking.stacks[(this.negStacks&&a.y<(r.startFromThreshold?0:r.threshold)?"-":"")+this.stackKey])&&(t=i[e])&&!a.isNull&&t.setOffset(-(s/2)||0,s||0,void 0,void 0,a.plotX,this.xAxis)}}z.compose=function(t,s){if(d(p,"Variwide")){let i=s.prototype;c(t,"afterDrawCrosshair",f),c(t,"afterRender",u),c(s,"afterGetPosition",g),i.postTranslate=y,x(i,"getLabelPosition",v)}},z.defaultOptions=P(b.defaultOptions,{pointPadding:0,groupPadding:0}),A(z,"afterColumnTranslate",function(){let t=this.xAxis,s=this.chart.inverted,i=-1;for(let e of this.points){let r,o;++i;let a=e.shapeArgs||{},{x:h=0,width:n=0}=a,{plotX:l=0,tooltipPos:p,z:c=0}=e;t.variwide?(r=this.postTranslate(i,h,e),o=this.postTranslate(i,h+n)):(r=l,o=t.translate(e.x+c,!1,!1,!1,!0)),this.crispOption&&(r=T(r,this.borderWidth),o=T(o,this.borderWidth)),a.x=r,a.width=Math.max(o-r,1),e.plotX=(r+o)/2,p&&(s?p[1]=t.len-a.x-a.width/2:p[0]=a.x+a.width/2)}this.options.stacking&&this.correctStackLabels()},{order:2}),k(z.prototype,{irregularWidths:!0,keysAffectYAxis:["y"],pointArrayMap:["y","z"],parallelArrays:["x","y","z"],pointClass:class extends w{isValid(){return m(this.y)&&m(this.z)}}}),l().registerSeriesType("variwide",z);let M=h();z.compose(M.Axis,M.Tick);let S=h();return o.default})());