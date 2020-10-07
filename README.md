# HIGHCHARTER

[![CRAN_Status_Badge](https://www.r-pkg.org/badges/version/highcharter?color=brightgreen)](https://cran.r-project.org/package=highcharter)
[![CRAN downloads](https://cranlogs.r-pkg.org/badges/highcharter?color=brightgreen)](https://www.r-pkg.org/pkg/highcharter)
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

- `vignette("highcharter")` explore the basics of the package. 
- `vignette("showcase")` to see how much highcharts is flexible in terms of 
customization and design.
- `vignette("highcharts-api")` show the main functions to configure charts with
the implemented Highcharts API.
- `vignette("highchartsjs-api-basics")` explain the relationship between the
highchartsJS API and highcharter.

## Performance

Processing by Highcharter can be resource intensive; e.g. parsing data structures in R and into the **Highcharts JSON format**. Depending on your usage of the package there can be a benefit in tweaking the performance options:

* `options(highcharter.boost = TRUE)`, activates base R function for parsing data structures within R.
* `options(highcharter.rjson = TRUE)`, activates rjson::toJSON() instead of the standard shiny::toJSON().

The performance options can be a factor 10x faster, but it is recommended to check the compatibility with your usage. By default the performance options are turned off.

## Licence 

Highcharter has a dependency on Highcharts, a commercial JavaScript charting library. Highcharts offers both a commercial license as well as a free non-commercial license. Please review the licensing options and terms before using this software, as the `highcharter` license neither provides nor implies a license for Highcharts.

Highcharts (https://highcharts.com) is a Highsoft product which is not free for commercial and Governmental use.

## Discount for highcharter users

Highsoft provide a discount to the highcharter users. It is a 50% discount on our Single Developer license. More details in https://newsletter.highcharts.com/foss/.
