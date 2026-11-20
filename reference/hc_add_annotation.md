# Add annotations to a chart

Add annotations to a chart

## Usage

``` r
hc_add_annotation(hc, ...)

hc_add_annotations(hc, x)
```

## Arguments

- hc:

  A `highchart` widget.

- ...:

  Named options for one Highcharts annotation, including `labels` and
  `shapes`. See
  [`data_to_annotation_labels()`](https://jkunst.com/highcharter/reference/data_to_annotation_labels.md)
  to create labels from rows.

- x:

  A list of annotations or a data frame with one annotation per row.
