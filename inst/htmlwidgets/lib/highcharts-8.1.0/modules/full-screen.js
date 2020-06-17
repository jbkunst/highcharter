/*
 Highstock JS v8.1.0 (2020-05-05)

 Advanced Highstock tools

 (c) 2010-2019 Highsoft AS
 Author: Torstein Honsi

 License: www.highcharts.com/license
*/
(function(a){"object"===typeof module&&module.exports?(a["default"]=a,module.exports=a):"function"===typeof define&&define.amd?define("highcharts/modules/full-screen",["highcharts"],function(c){a(c);a.Highcharts=c;return a}):a("undefined"!==typeof Highcharts?Highcharts:void 0)})(function(a){function c(a,g,c,f){a.hasOwnProperty(g)||(a[g]=f.apply(null,c))}a=a?a._modules:{};c(a,"modules/full-screen.src.js",[a["parts/Globals.js"],a["parts/Utilities.js"]],function(a,c){var d=c.addEvent;c=a.Chart;var f=
function(){function a(b){this.chart=b;this.isOpen=!1;b=b.renderTo;this.browserProps||("function"===typeof b.requestFullscreen?this.browserProps={fullscreenChange:"fullscreenchange",requestFullscreen:"requestFullscreen",exitFullscreen:"exitFullscreen"}:b.mozRequestFullScreen?this.browserProps={fullscreenChange:"mozfullscreenchange",requestFullscreen:"mozRequestFullScreen",exitFullscreen:"mozCancelFullScreen"}:b.webkitRequestFullScreen?this.browserProps={fullscreenChange:"webkitfullscreenchange",requestFullscreen:"webkitRequestFullScreen",
exitFullscreen:"webkitExitFullscreen"}:b.msRequestFullscreen&&(this.browserProps={fullscreenChange:"MSFullscreenChange",requestFullscreen:"msRequestFullscreen",exitFullscreen:"msExitFullscreen"}))}a.prototype.close=function(){var b=this.chart;if(this.isOpen&&this.browserProps&&b.container.ownerDocument instanceof Document)b.container.ownerDocument[this.browserProps.exitFullscreen]();this.unbindFullscreenEvent&&this.unbindFullscreenEvent();this.isOpen=!1;this.setButtonText()};a.prototype.open=function(){var b=
this,a=b.chart;if(b.browserProps){b.unbindFullscreenEvent=d(a.container.ownerDocument,b.browserProps.fullscreenChange,function(){b.isOpen?(b.isOpen=!1,b.close()):(b.isOpen=!0,b.setButtonText())});var c=a.renderTo[b.browserProps.requestFullscreen]();if(c)c["catch"](function(){alert("Full screen is not supported inside a frame.")});d(a,"destroy",b.unbindFullscreenEvent)}};a.prototype.setButtonText=function(){var a,c=this.chart,d=c.exportDivElements,e=c.options.exporting,f=null===(a=null===e||void 0===
e?void 0:e.buttons)||void 0===a?void 0:a.contextButton.menuItems;a=c.options.lang;(null===e||void 0===e?0:e.menuItemDefinitions)&&(null===a||void 0===a?0:a.exitFullscreen)&&a.viewFullscreen&&f&&d&&d.length&&(d[f.indexOf("viewFullscreen")].innerHTML=this.isOpen?a.exitFullscreen:e.menuItemDefinitions.viewFullscreen.text||a.viewFullscreen)};a.prototype.toggle=function(){this.isOpen?this.close():this.open()};return a}();a.Fullscreen=f;d(c,"beforeRender",function(){this.fullscreen=new a.Fullscreen(this)});
return a.Fullscreen});c(a,"masters/modules/full-screen.src.js",[],function(){})});
//# sourceMappingURL=full-screen.js.map