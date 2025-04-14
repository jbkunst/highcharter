!function(t,e){"object"==typeof exports&&"object"==typeof module?module.exports=e(t._Highcharts,t._Highcharts.SeriesRegistry):"function"==typeof define&&define.amd?define("highcharts/modules/flowmap",["highcharts/highcharts"],function(t){return e(t,t.SeriesRegistry)}):"object"==typeof exports?exports["highcharts/modules/flowmap"]=e(t._Highcharts,t._Highcharts.SeriesRegistry):t.Highcharts=e(t.Highcharts,t.Highcharts.SeriesRegistry)}("undefined"==typeof window?this:window,(t,e)=>(()=>{"use strict";var o={512:t=>{t.exports=e},944:e=>{e.exports=t}},i={};function s(t){var e=i[t];if(void 0!==e)return e.exports;var r=i[t]={exports:{}};return o[t](r,r.exports,s),r.exports}s.n=t=>{var e=t&&t.__esModule?()=>t.default:()=>t;return s.d(e,{a:e}),e},s.d=(t,e)=>{for(var o in e)s.o(e,o)&&!s.o(t,o)&&Object.defineProperty(t,o,{enumerable:!0,get:e[o]})},s.o=(t,e)=>Object.prototype.hasOwnProperty.call(t,e);var r={};s.d(r,{default:()=>M});var n=s(944),a=s.n(n),h=s(512),p=s.n(h);let{seriesTypes:{mapline:{prototype:{pointClass:l}}}}=p(),{pick:d,isString:f,isNumber:g}=a(),c=class extends l{isValid(){let t=!!(this.options.to&&this.options.from);return[this.options.to,this.options.from].forEach(function(e){t=!!(t&&e&&(f(e)||g(d(e[0],e.lat))&&g(d(e[1],e.lon))))}),t}},{series:{prototype:{pointClass:m}},seriesTypes:{column:y,map:u,mapline:x}}=p(),{addEvent:w,arrayMax:P,arrayMin:b,defined:L,extend:W,isArray:v,merge:k,pick:A,relativeLength:O}=a();class C extends x{static getLength(t,e){return Math.sqrt(t*t+e*e)}static normalize(t,e){let o=this.getLength(t,e);return[t/o,e/o]}static markerEndPath(t,e,o,i){let s=O(i.width||0,this.getLength(e[0]-t[0],e[1]-t[1])),r=i.markerType||"arrow",[n,a]=this.normalize(e[0]-t[0],e[1]-t[1]),h=[];if("arrow"===r){let[i,r]=t;i-=n*s,r-=a*s,h.push(["L",i,r]),h.push(["L",o[0],o[1]]),[i,r]=e,i+=n*s,r+=a*s,h.push(["L",i,r])}if("mushroom"===r){let[i,r]=t,[p,l]=e,[d,f]=o,g=(p-i)/2+i,c=(l-r)/2+r;i-=n*s,r-=a*s,h.push(["L",i,r]),p+=n*s,l+=a*s,h.push(["Q",(d-g)*2+g,(f-c)*2+c,p,l])}return h}animate(t){let e=this.points;t||e.forEach(t=>{if(t.shapeArgs&&v(t.shapeArgs.d)&&t.shapeArgs.d.length){let e=t.shapeArgs.d,o=e[0][1],i=e[0][2];if(o&&i){let s=[];for(let t=0;t<e.length;t++){s.push([...e[t]]);for(let r=1;r<e[t].length;r++)s[t][r]=r%2?o:i}t.graphic&&(t.graphic.attr({d:s}),t.graphic.animate({d:e}))}}})}getLinkWidth(t){let e=this.options.width,o=t.options.weight||this.options.weight;if(t.options.weight=o,e&&!o)return e;let i=this.smallestWeight,s=this.greatestWeight;if(!L(o)||!i||!s)return 0;let r=this.options.minWidth;return(o-i)*(this.options.maxWidth-r)/(s-i||1)+r}autoCurve(t,e,o,i,s,r){let n={x:o-t,y:i-e},a={x:(o-t)/2+t,y:(i-e)/2+e},h={x:a.x-s,y:a.y-r},p=n.x*h.x+n.y*h.y,l=Math.atan2(n.x*h.y-n.y*h.x,p),d=180*l/Math.PI;return d<0&&(d=360+d),-(.7*Math.sin(l=d*Math.PI/180))}pointAttribs(t,e){let o=u.prototype.pointAttribs.call(this,t,e);return o.fill=A(t.options.fillColor,t.options.color,"none"===this.options.fillColor?null:this.options.fillColor,this.color),o["fill-opacity"]=A(t.options.fillOpacity,this.options.fillOpacity),o["stroke-width"]=A(t.options.lineWidth,this.options.lineWidth,1),t.options.opacity&&(o.opacity=t.options.opacity),o}translate(){this.chart.hasRendered&&(this.isDirtyData||!this.hasRendered)&&(this.processData(),this.generatePoints());let t=[],e=0,o=0;this.points.forEach(i=>{let s,r,n=this.chart,a=n.mapView,h=i.options,p=()=>{i.series.isDirty=!0},l=t=>{let e=n.get(t);if(e instanceof m&&e.plotX&&e.plotY)return w(e,"update",p),{x:e.plotX,y:e.plotY}},d=t=>v(t)?{lon:t[0],lat:t[1]}:t;"string"==typeof h.from?s=l(h.from):"object"==typeof h.from&&a&&(s=a.lonLatToPixels(d(h.from))),"string"==typeof h.to?r=l(h.to):"object"==typeof h.to&&a&&(r=a.lonLatToPixels(d(h.to))),i.fromPos=s,i.toPos=r,s&&r&&(e+=(s.x+r.x)/2,o+=(s.y+r.y)/2),A(i.options.weight,this.options.weight)&&t.push(A(i.options.weight,this.options.weight))}),this.smallestWeight=b(t),this.greatestWeight=P(t),this.centerOfPoints={x:e/this.points.length,y:o/this.points.length},this.points.forEach(t=>{if(!this.getLinkWidth(t)){t.shapeArgs={d:[]};return}t.fromPos&&(t.plotX=t.fromPos.x,t.plotY=t.fromPos.y),t.shapeType="path",t.shapeArgs=this.getPointShapeArgs(t),t.color=A(t.options.color,t.series.color)})}getPointShapeArgs(t){let{fromPos:e,toPos:o}=t;if(!e||!o)return{};let i=this.getLinkWidth(t)/2,s=t.options,r=k(this.options.markerEnd,s.markerEnd),n=A(s.growTowards,this.options.growTowards),a=e.x||0,h=e.y||0,p=o.x||0,l=o.y||0,d=A(s.curveFactor,this.options.curveFactor),f=r&&r.enabled&&r.height||0;if(L(d)||(d=this.autoCurve(a,h,p,l,this.centerOfPoints.x,this.centerOfPoints.y)),f){f=O(f,4*i);let t=p-a,e=l-h,o=a+(t*=.5),s=h+(e*=.5),r=t,n=o+(t=e)*d,g=s+(e=-r)*d,[c,m]=C.normalize(n-p,g-l);c*=f,m*=f,p+=c,l+=m}let g=p-a,c=l-h,m=a+(g*=.5),y=h+(c*=.5),u=g;g=c,c=-u;let[x,w]=C.normalize(g,c),P=1+.25*Math.sqrt(d*d);x*=i*P,w*=i*P;let b=m+g*d,W=y+c*d,[v,M]=C.normalize(b-a,W-h);u=v,v=M,M=-u,v*=i,M*=i;let[T,E]=C.normalize(b-p,W-l);u=T,T=-E,E=u,T*=i,E*=i,n&&(v/=i,M/=i,x/=4,w/=4);let j={d:[["M",a-v,h-M],["Q",b-x,W-w,p-T,l-E],["L",p+T,l+E],["Q",b+x,W+w,a+v,h+M],["Z"]]};if(r&&r.enabled&&j.d){let t=C.markerEndPath([p-T,l-E],[p+T,l+E],[o.x,o.y],r);j.d.splice(2,0,...t)}let z=t.options.from,H=t.options.to,S=z.lat,R=z.lon,_=H.lat,D=H.lon;return S&&R&&(t.options.from=`${+S}, ${+R}`),_&&D&&(t.options.to=`${+_}, ${+D}`),j}}C.defaultOptions=k(x.defaultOptions,{animation:!0,dataLabels:{enabled:!1},fillOpacity:.5,markerEnd:{enabled:!0,height:"40%",width:"40%",markerType:"arrow"},width:1,maxWidth:25,minWidth:5,lineWidth:void 0,tooltip:{headerFormat:'<span style="font-size: 0.8em">{series.name}</span><br/>',pointFormat:"{point.options.from} → {point.options.to}: <b>{point.options.weight}</b>"}}),W(C.prototype,{pointClass:c,pointArrayMap:["from","to","weight"],drawPoints:y.prototype.drawPoints,dataColumnKeys:y.prototype.dataColumnKeys,useMapGeometry:!0}),p().registerSeriesType("flowmap",C);let M=a();return r.default})());