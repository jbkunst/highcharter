!function(t,e){"object"==typeof exports&&"object"==typeof module?module.exports=e(t._Highcharts,t._Highcharts.SeriesRegistry,t._Highcharts.Series.types.column):"function"==typeof define&&define.amd?define("highcharts/modules/renko",["highcharts/highcharts"],function(t){return e(t,t.SeriesRegistry,t.Series,["types"],["column"])}):"object"==typeof exports?exports["highcharts/modules/renko"]=e(t._Highcharts,t._Highcharts.SeriesRegistry,t._Highcharts.Series.types.column):t.Highcharts=e(t.Highcharts,t.Highcharts.SeriesRegistry,t.Highcharts.Series.types.column)}("undefined"==typeof window?this:window,(t,e,o)=>(()=>{"use strict";var r={448:t=>{t.exports=o},512:t=>{t.exports=e},944:e=>{e.exports=t}},s={};function i(t){var e=s[t];if(void 0!==e)return e.exports;var o=s[t]={exports:{}};return r[t](o,o.exports,i),o.exports}i.n=t=>{var e=t&&t.__esModule?()=>t.default:()=>t;return i.d(e,{a:e}),e},i.d=(t,e)=>{for(var o in e)i.o(e,o)&&!i.o(t,o)&&Object.defineProperty(t,o,{enumerable:!0,get:e[o]})},i.o=(t,e)=>Object.prototype.hasOwnProperty.call(t,e);var n={};i.d(n,{default:()=>b});var a=i(944),p=i.n(a),h=i(512),l=i.n(h);let{column:{prototype:{pointClass:c}}}=l().seriesTypes;var u=i(448),d=i.n(u);let{extend:g,merge:f,relativeLength:y,isNumber:m}=p();class x extends d(){constructor(){super(...arguments),this.hasDerivedData=!0,this.allowDG=!1}init(){super.init.apply(this,arguments),this.renkoData=[]}setData(t,e,o){this.renkoData=[],super.setData(t,e,o,!1)}getXExtremes(t){return this.processData(),{min:(t=this.getColumn("x",!0))[0],max:t[t.length-1]}}getProcessedData(){let t=this.dataTable.modified,e=[],o=[],r=[],s=this.getColumn("x",!0),i=this.getColumn("y",!0);if(!this.renkoData||this.renkoData.length>0)return{modified:t,closestPointRange:1,cropped:!1,cropStart:0};let n=this.options.boxSize,a=m(n)?n:y(n,i[0]),p=[],h=s.length,l=0,c=i[0];for(let t=1;t<h;t++){let e=i[t]-i[t-1];if(e>a){2===l&&(c+=a);for(let o=0;o<e/a;o++)p.push({x:s[t]+o,low:c,y:c+a,color:this.options.color,upTrend:!0}),c+=a;l=1}else if(Math.abs(e)>a){1===l&&(c-=a);for(let o=0;o<Math.abs(e)/a;o++)p.push({x:s[t]+o,low:c-a,y:c,color:this.options.downColor,upTrend:!1}),c-=a;l=2}}for(let t of(this.renkoData=p,p))e.push(t.x),o.push(t.y),r.push(t.low);return this.processedData=p,t.setColumn("x",e),t.setColumn("y",o),t.setColumn("low",r),{modified:t,cropped:!1,cropStart:0,closestPointRange:1}}}x.defaultOptions=f(d().defaultOptions,{boxSize:4,groupPadding:0,pointPadding:0,downColor:"#ff0000",navigatorOptions:{type:"renko"},fillColor:"transparent",borderWidth:2,lineWidth:0,stickyTracking:!0,borderRadius:{where:"all"},tooltip:{pointFormat:'<span style="color:{point.color}">●</span> {series.name}: <b>{point.low:.2f} - {point.y:.2f}</b><br/>'}}),g(x.prototype,{pointClass:class extends c{getClassName(){return super.getClassName.call(this)+(this.upTrend?" highcharts-point-up":" highcharts-point-down")}}}),l().registerSeriesType("renko",x);let b=p();return n.default})());