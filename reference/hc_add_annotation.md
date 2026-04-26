# Helper to add annotations from data frame or list

Helper to add annotations from data frame or list

## Usage

``` r
hc_add_annotation(hc, ...)

hc_add_annotations(hc, x)
```

## Arguments

- hc:

  A `highchart` `htmlwidget` object.

- ...:

  Arguments defined in
  <https://api.highcharts.com/highcharts/annotations>.

- x:

  A `list` or a `data.frame` of annotations.

## Details

The `x` elements must have `xValue` and `yValue` elements
