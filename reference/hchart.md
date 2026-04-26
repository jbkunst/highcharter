# Create a highchart object from a particular data type

`hchart` uses `highchart` to draw a particular plot for an object of a
particular class in a single command. This defines the S3 generic that
other classes and packages can extend.

## Usage

``` r
hchart(object, ...)
```

## Arguments

- object:

  A R object.

- ...:

  Additional arguments for the data series
  (<https://api.highcharts.com/highcharts/series>).

## Details

Run `methods(hchart)` to see what objects are supported.
