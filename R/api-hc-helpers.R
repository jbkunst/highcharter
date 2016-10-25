.hc_tooltip_table <- function(hc, ...) {
  # http://stackoverflow.com/a/22327749/829971
  hc %>% 
    highcharter::hc_tooltip(
      useHTML = TRUE,
      headerFormat = '<small>{point.key}</small><table>',
      pointFormat = '<tr><td style="color: {series.color}">{series.name}: </td><td style="text-align: right"><b>{point.y}</b></td></tr>',
      footerFormat = '</table>'
    )
}

.hc_tooltip_sort <- function(hc, ...) {
  # http://stackoverflow.com/a/16954666/829971
  hc %>% 
    highcharter::hc_tooltip(
      shared = TRUE,
      formatter = JS(
        "function(tooltip){
          function isArray(obj) {
          return Object.prototype.toString.call(obj) === '[object Array]';
          }
          
          function splat(obj) {
          return isArray(obj) ? obj : [obj];
          }
          
          var items = this.points || splat(this), series = items[0].series, s;
          
          // sort the values
          items.sort(function(a, b){
          return ((a.y < b.y) ? -1 : ((a.y > b.y) ? 1 : 0));
          });
          items.reverse();
          
          return tooltip.defaultFormatter.call(this, tooltip);
        }"))
  
}
