[![](https://raw.githubusercontent.com/jbkunst/highcharter/master/highcharter-logo.png)](http://jkunst.com/highcharter/)

---

[![Project Status: Active – The project has reached a stable, usable
state and is being actively
developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![Lifecycle:
stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://www.tidyverse.org/lifecycle/#stable)
[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/highcharter?color=brightgreen)](https://cran.r-project.org/package=highcharter)
[![CRAN downloads](http://cranlogs.r-pkg.org/badges/highcharter?color=brightgreen)](http://www.r-pkg.org/pkg/highcharter)
[![travis-status](https://api.travis-ci.org/jbkunst/highcharter.svg)](https://travis-ci.org/jbkunst/highcharter)
[![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/jbkunst/highcharter?branch=master&svg=true)](https://ci.appveyor.com/project/jbkunst/highcharter)
[![GitHub closed issues](https://img.shields.io/github/issues-raw/jbkunst/highcharter.svg)](https://github.com/jbkunst/highcharter/issues)
[![GitHub issues](https://img.shields.io/github/issues-closed-raw/jbkunst/highcharter.svg)](https://github.com/jbkunst/highcharter/issues)
[![Github Stars](https://img.shields.io/github/stars/jbkunst/highcharter.svg?style=social&label=Github)](https://github.com/jbkunst/highcharter)
<!-- badges: start -->
[![Codecov test coverage](https://codecov.io/gh/jbkunst/highcharter/branch/master/graph/badge.svg)](https://codecov.io/gh/jbkunst/highcharter?branch=master)
<!-- badges: end -->

---

R wrapper for highcharts. `highcharter` bring all the highcharts capabilites
so it is recommended know how highcharts API works to take a major advantage of 
this package. You can look  some [demos](http://www.highcharts.com/demo) charts
and explore chart types, syntax and all what highcharts can do.

## Highlights

- [Various](http://jkunst.com/highcharter/) chart type with the same style: 
scatters, bubble, line, time series, heatmaps, treemap, bar charts, networks.
- Chart various R object with [one function](http://jkunst.com/highcharter/hchart.html). 
With `hchart(x)` you can chart: data.frames, numeric, histogram, character, 
density, factors, ts, mts, xts, stl, ohlc, acf, forecast, mforecast, ets, 
igraph, dist, dendrogram, phylo, survfit classes.
- Support [Highstock charts](http://jkunst.com/highcharter/highstock.html). You can create a candlestick charts in 2 lines of code. Support `xts` objects from the quantmod package.
- Support [Highmaps charts](http://jkunst.com/highcharter/highmaps.html). It's easy to create choropleths or add information in geojson format.
- [Themes](http://jkunst.com/highcharter/themes.html): you configurate your 
chart in multiples ways. There are implemented themes like economist, financial 
times, google, 538 among others.
- [Plugins](http://jkunst.com/highcharter/plugins.html): motion, drag points, 
fontawesome, url-pattern, annotations.
- <3 and respect to Highcharts team.

## Resources

- Official package website: http://jkunst.com/highcharter/.
- [Highcharts API and highcharter](https://dantonnoriega.github.io/ultinomics.org/post/2017-04-05-highcharter-explainer.html) by
@dantonnoriega. 
- Replicating Highcharts Demos: https://cran.rstudio.com/web/packages/highcharter/vignettes/replicating-highcharts-demos.html
- CRAN site https://cran.r-project.org/web/packages/highcharter/.
- Some Shiny demos [here](http://104.140.247.162:3838/shiny-apps-highcharter/) and code [there](https://github.com/jbkunst/shiny-apps-highcharter).

## Installation:


CRAN version:
```r
install.packages("highcharter")
```

Development version:
```r
devtools::install_github("jbkunst/highcharter")

source("https://install-github.me/jbkunst/highcharter")
```

## Licence 

Highcharter has a dependency on Highcharts, a commercial JavaScript charting library. Highcharts offers both a commercial license as well as a free non-commercial license. Please review the licensing options and terms before using this software, as the `highcharter` license neither provides nor implies a license for Highcharts.

Highcharts (http://highcharts.com) is a Highsoft product which is not free for commercial and Governmental use.

## Discount for highcharter users

Highsoft provide a discount to the highcharter users. It is a 50% discount on our Single Developer license. More details in https://newsletter.highcharts.com/foss/.

## Code of Conduct

Please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md). By participating in this project you agree to abide by its terms.

