# Create a Highcharts chart widget

This function creates a Highchart chart using htmlwidgets. The widget
can be rendered on HTML pages generated from R Markdown, Shiny, or other
applications.

## Usage

``` r
highchart(
  hc_opts = list(),
  theme = getOption("highcharter.theme"),
  type = "chart",
  width = NULL,
  height = NULL,
  elementId = NULL,
  google_fonts = getOption("highcharter.google_fonts")
)
```

## Arguments

- hc_opts:

  A `list` object containing options defined as
  <https://api.highcharts.com/highcharts/>.

- theme:

  A `hc_theme` class object-

- type:

  A character value to set if use Highchart, Highstock or Highmap.
  Options are `"chart"`, `"stock"` and `"map"`.

- width:

  A numeric input in pixels.

- height:

  A numeric input in pixels.

- elementId:

  Use an explicit element ID for the widget.

- google_fonts:

  A boolean value. If TRUE (default), adds a reference to the Google
  Fonts API to the HTML head, downloading CSS for the font families
  defined in the Highcharts theme from https://fonts.googleapis.com. Set
  to FALSE if you load your own fonts using CSS. This option as default
  is controlled by `"highcharter.google_fonts"` option.
