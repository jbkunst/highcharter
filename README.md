# highcharter

Highcharter brings interactive Highcharts charts, maps and financial time series to R.

<iframe class="home-gallery" src="home-gallery.html" title="Explore international development through animated charts" loading="lazy"></iframe>

[Explore chart types and their R examples](https://jkunst.com/highcharter/articles/series-gallery.html).

<div class="home-copy">

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

See the [maintainer guide](https://github.com/jbkunst/highcharter/blob/feat/highcharts-bundle/dev/readme.md#update-highcharts) to update Highcharts
and the [bundle guide](https://github.com/jbkunst/highcharter/blob/feat/highcharts-bundle/dev/highcharts-bundle/README.md) to change the module selection
or run the example grid.

The [development guide](https://github.com/jbkunst/highcharter/blob/feat/highcharts-bundle/dev/readme.md)
describes the `dev/` directories, website build, tests and maintenance commands.

## How to start

Start with [charting a data frame](https://jkunst.com/highcharter/articles/first-steps.html),
then explore [Maps](https://jkunst.com/highcharter/articles/maps.html),
[Stock](https://jkunst.com/highcharter/articles/stock.html) and
[accessible charts](https://jkunst.com/highcharter/articles/accessibility.html).

## Project links

[Source code](https://github.com/jbkunst/highcharter) ·
[Report an issue](https://github.com/jbkunst/highcharter/issues) ·
[Contributing](CONTRIBUTING.md) ·
[Code of conduct](CODE_OF_CONDUCT.md) ·
[Authors and citation](https://jkunst.com/highcharter/authors.html) ·
[Maintainer's website](https://jkunst.com)

## Licence

Highcharter has a dependency on Highcharts, a commercial JavaScript charting library. Highcharts offers both a commercial license as well as a free non-commercial license. Please review the licensing options and terms before using this software, as the `highcharter` license neither provides nor implies a license for Highcharts.

Highcharts (https://highcharts.com) is a Highsoft product which is not free for commercial and Governmental use.

</div>
