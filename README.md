# HIGHCHARTER

[![CRAN_Status_Badge](https://www.r-pkg.org/badges/version/highcharter?color=brightgreen)](https://cran.r-project.org/package=highcharter)
[![CRAN downloads](https://cranlogs.r-pkg.org/badges/highcharter?color=brightgreen)](https://www.r-pkg.org/pkg/highcharter)
[![Project Status: Active – The project has reached a stable, usablestate and is being activelydeveloped.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![Lifecycle:stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html)
[![Codecov test coverage](https://codecov.io/gh/jbkunst/highcharter/branch/master/graph/badge.svg)](https://app.codecov.io/gh/jbkunst/highcharter?branch=master)
[![R-CMD-check](https://github.com/jbkunst/highcharter/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/jbkunst/highcharter/actions/workflows/R-CMD-check.yaml)
[![Last commit](https://img.shields.io/github/last-commit/jbkunst/highcharter.svg?logo=github&color=brightgreen)](https://github.com/jbkunst/highcharter/issues)
[![GitHub closed issues](https://img.shields.io/github/issues-raw/jbkunst/highcharter.svg?logo=github&color=brightgreen)](https://github.com/jbkunst/highcharter/issues)
[![GitHub issues](https://img.shields.io/github/issues-closed-raw/jbkunst/highcharter.svg?logo=github&color=brightgreen)](https://github.com/jbkunst/highcharter/issues)
[![Github Stars](https://img.shields.io/github/stars/jbkunst/highcharter.svg?logo=github&color=brightgreen)](https://github.com/jbkunst/highcharter)

Highcharter is a **[R](https://cran.r-project.org/)** wrapper for 
**[Highcharts](https://www.highcharts.com/)**  javascript library and its modules.
Highcharts is very flexible and customizable javascript charting library and 
it has a great and powerful API.

The main features of highcharter are:

* Chart various R objects with one function: with `hchart(x)` you can 
chart `data.frames`, `numeric` or `character` vectors, `ts`,
 `xts`, `forecast`, `survfit`  objects.
* Support Highstock You can create a candlestick charts in 2 lines 
of code. Support `xts` class from the {quantmod} package.
* Support Highmaps Create choropleth charts or add 
information in `geojson` format.
* Themes: you configure your chart in multiples ways. There are
 implemented themes like economist, financial times, google, 538 among 
 others.
* A lot of features and plugins: motion, draggable points, font-awesome,
tooltips, annotations.

<div w3-include-html="extra-index-examples.html"></div>

<iframe src="extra-index-examples.html" scrolling="no" frameborder="no"></iframe>

## Installation

CRAN version:

```r
install.packages("highcharter")
```

Development version:

```r
remotes::install_github("jbkunst/highcharter")
```

## How to start

There are a lot of vignettes to show how highcharter works and what you 
can do:

- `vignette("highcharter")` to explore the basics of the package. 
- `vignette("first-steps")` to know how to make a visualization from a data frame. 
- `vignette("showcase")` to see highcharts flexibility in terms of 
customization and design.
- `vignette("highcharts-api")` show the main functions to configure charts with
the implemented Highcharts API.
- `vignette("highchartsjs-api-basics")` explain the relationship between the
highchartsJS API and highcharter.


## Licence 

Highcharter has a dependency on Highcharts, a commercial JavaScript charting library. Highcharts offers both a commercial license as well as a free non-commercial license. Please review the licensing options and terms before using this software, as the `highcharter` license neither provides nor implies a license for Highcharts.

Highcharts (https://highcharts.com) is a Highsoft product which is not free for commercial and Governmental use.

## Discount for highcharter users

Highsoft provide a discount to the highcharter users. It is a 50% discount on our Single Developer license. More details in https://newsletter.highcharts.com/foss/.
