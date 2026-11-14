# highcharter

Highcharter brings interactive Highcharts charts, maps and financial time series to R.

[Explore the interactive chart gallery](https://jkunst.com/highcharter/series-gallery.html).

## Installation

CRAN version:

```r
install.packages("highcharter")
```

Development version:

```r
remotes::install_github("jbkunst/highcharter")
```

## Highcharts bundle

`highchart()` and `highchartstock()` share one bundled Highcharts
engine per page. Charts, Stock, Maps, Gantt, official series, accessibility and common
feature modules are included. `highchartstock()` adds the Stock Tools GUI and technical
indicators. Third-party plugins remain optional through `hc_add_dependency()`.
Each widget keeps its own chart and resizes to its container when reflow is enabled.

See the [maintainer guide](https://github.com/jbkunst/highcharter/blob/HEAD/dev/readme.md#update-highcharts) to update Highcharts
and the [bundle guide](https://github.com/jbkunst/highcharter/blob/HEAD/dev/highcharts-bundle/README.md) to change the module selection
or run the example grid.

## How to start

Start with [charting a data frame](https://jkunst.com/highcharter/articles/first-steps.html),
then explore [Maps](https://jkunst.com/highcharter/articles/maps.html),
[Stock](https://jkunst.com/highcharter/articles/stock.html) and
[accessible charts](https://jkunst.com/highcharter/articles/accessibility.html).

## Licence 

Highcharter has a dependency on Highcharts, a commercial JavaScript charting library. Highcharts offers both a commercial license as well as a free non-commercial license. Please review the licensing options and terms before using this software, as the `highcharter` license neither provides nor implies a license for Highcharts.

Highcharts (https://highcharts.com) is a Highsoft product which is not free for commercial and Governmental use.
