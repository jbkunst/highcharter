# Create a Highcharts chart widget

This widgets don't support options yet.

## Usage

``` r
highchartzero(
  hc_opts = list(),
  theme = NULL,
  width = NULL,
  height = NULL,
  elementId = NULL
)
```

## Arguments

- hc_opts:

  A `list` object containing options defined as
  <https://api.highcharts.com/highcharts/>.

- theme:

  A `hc_theme` class object.

- width:

  A numeric input in pixels.

- height:

  A numeric input in pixels.

- elementId:

  Use an explicit element ID for the widget.

## Details

This function creates a Highchart chart using htmlwidgets. The widget
can be rendered on HTML pages generated from R Markdown, Shiny, or other
applications.
