% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/highcharts-api.R
\name{hc_legend}
\alias{hc_legend}
\title{Legend options for highcharter objects}
\usage{
hc_legend(hc, ...)
}
\arguments{
\item{hc}{A \code{highchart} \code{htmlwidget} object.}

\item{...}{Arguments defined in \url{https://api.highcharts.com/highcharts/legend}.}
}
\description{
The legend is a box containing a symbol and name for each series
item or point item in the chart. Each series (or points in case
of pie charts) is represented by a symbol and its name in the legend.
It is possible to override the symbol creator function and create
custom legend symbols.
}
\examples{

highchart() |> 
  hc_xAxis(categories = month.abb) |> 
  hc_add_series(name = "Tokyo", data = sample(1:12)) |> 
  hc_add_series(name = "London", data = sample(1:12) + 10) |>
  hc_add_series(name = "Other City", data = sample(1:12) + 20) |>
  hc_legend(
    align = "left",
    verticalAlign = "top",
    layout = "vertical",
    x = 0,
    y = 100
    ) 

}
