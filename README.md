# HIGHCHARTER

---

[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/highcharter?color=brightgreen)](https://cran.r-project.org/package=highcharter)
[![CRAN downloads](http://cranlogs.r-pkg.org/badges/highcharter?color=brightgreen)](http://www.r-pkg.org/pkg/highcharter)
[![Project Status: Active – The project has reached a stable, usablestate and is being activelydeveloped.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![Lifecycle:stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://www.tidyverse.org/lifecycle/#stable)
[![Codecov test coverage](https://codecov.io/gh/jbkunst/highcharter/branch/master/graph/badge.svg)](https://codecov.io/gh/jbkunst/highcharter?branch=master)
[![Last commit](https://img.shields.io/github/last-commit/jbkunst/highcharter.svg)](https://github.com/jbkunst/highcharter/issues)
[![GitHub closed issues](https://img.shields.io/github/issues-raw/jbkunst/highcharter.svg)](https://github.com/jbkunst/highcharter/issues)
[![GitHub issues](https://img.shields.io/github/issues-closed-raw/jbkunst/highcharter.svg)](https://github.com/jbkunst/highcharter/issues)
[![check-windows](https://github.com/jbkunst/highcharter/workflows/check-windows/badge.svg)](https://github.com/jbkunst/highcharter/actions?workflow=check-windows)
[![check-mac](https://github.com/jbkunst/highcharter/workflows/check-mac/badge.svg)](https://github.com/jbkunst/highcharter/actions?workflow=check-mac)
[![check-linux](https://github.com/jbkunst/highcharter/workflows/check-linux/badge.svg)](https://github.com/jbkunst/highcharter/actions?workflow=check-linux)
[![Github Stars](https://img.shields.io/github/stars/jbkunst/highcharter.svg?style=social&label=Github)](https://github.com/jbkunst/highcharter)

Highcharter is a [R](https://cran.r-project.org/) wrapper for
**[Highcharts](https://www.highcharts.com/)**  javascript library and its modules.
Highcharts is very mature and flexible javascript charting library and
it has a great and powerful API^[See http://www.highcharts.com/demo].

The main features of this package are:

* Chart various R objects with one function. With hchart(x) you can
chart: data.frames, numeric, histogram, character, density, factors, ts,
 mts, xts, stl, ohlc, acf, forecast, mforecast, ets, igraph, dist,
  dendrogram, survfit classes.
* Support Highstock charts. You can create a candlestick charts in 2 lines
of code. Support xts objects from the quantmod package.
* Support Highmaps charts. It's easy to create choropleths or add
information in geojson format.
* Themes: you configurate your chart in multiples ways. There are
 implemented themes like economist, financial times, google, 538 among
 others.
* A lot of features and plugins: motion, draggable points, font-awesome, tooltips, annotations.

## Installation

CRAN version:
```r
install.packages("highcharter")
```

Development version:
```r
devtools::install_github("jbkunst/highcharter")
remotes::install_github("jbkunst/highcharter")
source("https://install-github.me/jbkunst/highcharter")
```

## Tutorials and examples

- [Highcharter cookbook](https://www.tmbish.me/lab/highcharter-cookbook/) by [Tom Bishop](https://twitter.com/bigbishdog)
- [Thinking in `highcharter`](https://dantonnoriega.github.io/ultinomics.org/posts/2017-04-05-highcharter-explainer.html) by [Danton Noriega](https://twitter.com/dantonnoriega)
- Examples in [Highcharter in Data, Code and Visualization](http://jkunst.com/blog/#highcharts)

## Licence

Highcharter has a dependency on Highcharts, a commercial JavaScript charting library. Highcharts offers both a commercial license as well as a free non-commercial license. Please review the licensing options and terms before using this software, as the `highcharter` license neither provides nor implies a license for Highcharts.

Highcharts (http://highcharts.com) is a Highsoft product which is not free for commercial and Governmental use.

## Discount for highcharter users

Highsoft provide a discount to the highcharter users. It is a 50% discount on our Single Developer license. More details in https://newsletter.highcharts.com/foss/.

## Code of Conduct

Please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md). By participating in this project you agree to abide by its terms.
