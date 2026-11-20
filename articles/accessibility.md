# Accessible charts

Highcharter includes the Highcharts accessibility module in the shared
bundle. Give the chart a title and identify the units on its axes. Use
the caption for the takeaway and the point description for details when
navigating the series. Keep a distinct marker or dash style when several
series use color.

``` r

highchart() |>
  hc_title(text = "Daily bicycle trips") |>
  hc_xAxis(categories = c("Mon", "Tue", "Wed"), title = list(text = "Day")) |>
  hc_yAxis(title = list(text = "Trips")) |>
  hc_add_series(data = c(24, 35, 30), name = "North route") |>
  hc_add_series(
    data = c(18, 28, 26),
    name = "South route",
    dashStyle = "Dash",
    marker = list(symbol = "diamond")
  ) |>
  hc_caption(text = "Both routes had the most trips on Tuesday.") |>
  hc_chart(animation = FALSE) |>
  hc_plotOptions(series = list(animation = FALSE)) |>
  hc_accessibility(
    enabled = TRUE,
    landmarkVerbosity = "one",
    point = list(valueDescriptionFormat = "{xDescription}, {value} trips."),
    keyboardNavigation = list(enabled = TRUE)
  ) |>
  hc_exporting(enabled = TRUE, showTable = TRUE)
```

Use Tab to reach the chart, the arrow keys to explore points, and Tab
again to reach the legend and export controls. The HTML data table
offers the values in reading order. Give every interactive chart a
visible focus indicator. For a longer explanation, reference an adjacent
paragraph by its unique CSS selector in
`hc_accessibility(linkedDescription = "#route-summary")`. Use
`screenReaderSection` to customize the text before or after the chart.

For Maps, name each region or point and include the unit in its value
description. For Stock, identify the financial instrument and date. See
the [Maps](https://jkunst.com/highcharter/articles/maps.md) and
[Stock](https://jkunst.com/highcharter/articles/stock.md) examples. The
example above disables introductory animations. The home example
respects reduced motion and lets readers select either measurement.
Sonification is available through
[`hc_sonification()`](https://jkunst.com/highcharter/reference/hc_sonification.md)
for readers who choose to play the chart.

[Highcharts accessibility
guide](https://www.highcharts.com/docs/accessibility/accessibility-module)

## A patterned pie chart

Mara Averick adapted the Highcharts accessible pie chart for highcharter
and shared it in [issue
\#736](https://github.com/jbkunst/highcharter/issues/736). Her design
gives each slice a distinct pattern and labels it with the reader’s name
and percentage. [Mara’s original example on
RPubs](https://rpubs.com/maraaverick/highcharter-accessible-pie-chart).

The values come from [WebAIM’s 2019 screen reader
survey](https://webaim.org/projects/screenreadersurvey8/#primary).
“Other” groups the four smallest responses. Tab to the pie and use the
arrow keys to hear each slice’s name and survey share with a screen
reader.

``` r

reader_slice <- function(name, share, color, path) {
  list(
    name = name,
    y = share,
    color = list(
      pattern = list(
        path = path,
        color = color,
        width = 5,
        height = 5,
        patternTransform = "scale(1.4 1.4)"
      )
    )
  )
}

highchart() |>
  hc_title(text = "Primary desktop/laptop screen readers") |>
  hc_subtitle(text = "WebAIM Screen Reader User Survey, 2019") |>
  hc_caption(
    text = "NVDA (40.6%) and JAWS (40.1%) were the most common responses."
  ) |>
  hc_add_series(
    type = "pie",
    name = "Screen reader usage",
    data = list(
      reader_slice(
        "NVDA",
        40.6,
        "#49a65e",
        "M 0 0 L 5 5 M 4.5 -0.5 L 5.5 0.5 M -0.5 4.5 L 0.5 5.5"
      ),
      reader_slice(
        "JAWS",
        40.1,
        "#5f98cf",
        "M 0 5 L 5 0 M -0.5 0.5 L 0.5 -0.5 M 4.5 5.5 L 5.5 4.5"
      ),
      reader_slice("VoiceOver", 12.9, "#f45b5b", "M 2 0 L 2 5 M 4 0 L 4 5"),
      reader_slice("ZoomText/Fusion", 2, "#434348", "M 0 2 L 5 2 M 0 4 L 5 4"),
      reader_slice(
        "Other",
        4.4,
        "#708090",
        "M 0 1.5 L 2.5 1.5 L 2.5 0 M 2.5 5 L 2.5 3.5 L 5 3.5"
      )
    ),
    borderWidth = 3,
    dataLabels = list(
      enabled = TRUE,
      connectorColor = "#777",
      format = "{point.name}: {point.y:.1f}%"
    )
  ) |>
  hc_tooltip(valueSuffix = "%", borderColor = "#8ae") |>
  hc_accessibility(
    point = list(valueDescriptionFormat = "{point.name}, {point.y}%.")
  ) |>
  hc_exporting(enabled = TRUE)
```

## Screen readers and sound

Accessibility does not make a chart play sound automatically. A screen
reader speaks its descriptions when you navigate to the chart.
Sonification is a separate, opt-in way of listening to the values as
musical notes.

``` r

highchart() |>
  hc_title(text = "Listen to the weekly pattern") |>
  hc_xAxis(categories = c("Mon", "Tue", "Wed", "Thu", "Fri")) |>
  hc_add_series(name = "Trips", data = c(24, 35, 30, 42, 38)) |>
  hc_exporting(
    enabled = TRUE,
    buttons = list(contextButton = list(menuItems = list("playAsSound")))
  ) |>
  hc_sonification(enabled = TRUE, duration = 1800, masterVolume = 0.35)
```

Choose **Play as sound** in the export menu. Playback starts only after
that action; it does not compete with screen-reader speech when the page
opens.
