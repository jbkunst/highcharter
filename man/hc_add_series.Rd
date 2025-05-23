% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/highcharts-api-add.R
\name{hc_add_series}
\alias{hc_add_series}
\title{Adding data to highchart objects}
\usage{
hc_add_series(hc, data = NULL, ...)
}
\arguments{
\item{hc}{A \code{highchart} \code{htmlwidget} object.}

\item{data}{An R object like numeric, list, ts, xts, etc.}

\item{...}{Arguments defined in \url{https://api.highcharts.com/highcharts/plotOptions.series}.}
}
\description{
Adding data to highchart objects
}
\examples{

highchart() |>
  hc_add_series(data = abs(rnorm(5)), type = "column") |>
  hc_add_series(data = purrr::map(0:4, function(x) list(x, x)), type = "scatter", color = "orange")
}
