# Generated from Highcharts 12.6.0 by dev/generate-highcharts-api.R

#' Accessibility options for highcharter objects
#'
#' Options for configuring
#' accessibility for the chart. Requires the accessibility module to be
#' loaded. For a description of the module and information on its features,
#' see Highcharts Accessibility.
#'
#' @param hc A `highchart` `htmlwidget` object.
#' @param ... Options defined in <https://api.highcharts.com/highcharts/accessibility>.
#' @example dev/examples-api/accessibility.R
#' @export
hc_accessibility <- function(hc, ...) {
  .hc_opt(hc, "accessibility", ...)
}

#' Annotations options for highcharter objects
#'
#' A collection of annotations to
#' add to the chart. The basic annotation allows adding custom labels or
#' shapes. The items can be tied to points, axis coordinates or chart pixel
#' coordinates.
#'
#' General options for all annotations can be set using the
#' `Highcharts.setOptions` function. In this case only single objects are
#' supported, because it alters the defaults for all items. For
#' initialization in the chart constructors however, arrays of annotations
#' are supported.
#'
#' See more in the general docs.
#'
#' @param hc A `highchart` `htmlwidget` object.
#' @param ... Options defined in <https://api.highcharts.com/highcharts/annotations>.
#' @example dev/examples-api/annotations.R
#' @export
hc_annotations <- function(hc, ...) {
  .hc_opt(hc, "annotations", ...)
}

#' Boost options for highcharter objects
#'
#' Options for the Boost module. The Boost module
#' allows certain series types to be rendered by WebGL instead of the
#' default SVG. This allows hundreds of thousands of data points to be
#' rendered in milliseconds. In addition to the WebGL rendering it saves
#' time by skipping processing and inspection of the data wherever possible.
#' This introduces some limitations to what features are available in boost
#' mode. See the docs for details.
#'
#' In addition to the global `boost` option, each series has a
#' boostThreshold that defines when the boost should kick in.
#'
#' Requires the `modules/boost.js` module.
#'
#' @param hc A `highchart` `htmlwidget` object.
#' @param ... Options defined in <https://api.highcharts.com/highcharts/boost>.
#' @example dev/examples-api/boost.R
#' @export
hc_boost <- function(hc, ...) {
  .hc_opt(hc, "boost", ...)
}

#' Caption options for highcharter objects
#'
#' The chart's caption, which will
#' render below the chart and will be part of exported charts. The caption
#' can be updated after chart initialization through the `Chart.update` or
#' `Chart.caption.update` methods.
#'
#' @param hc A `highchart` `htmlwidget` object.
#' @param ... Options defined in <https://api.highcharts.com/highcharts/caption>.
#' @example dev/examples-api/caption.R
#' @export
hc_caption <- function(hc, ...) {
  .hc_opt(hc, "caption", ...)
}

#' Chart options for highcharter objects
#'
#' General options for the chart.
#'
#' @param hc A `highchart` `htmlwidget` object.
#' @param ... Options defined in <https://api.highcharts.com/highcharts/chart>.
#' @example dev/examples-api/chart.R
#' @export
hc_chart <- function(hc, ...) {
  .hc_opt(hc, "chart", ...)
}

#' colorAxis options for highcharter objects
#'
#' A color axis for series. Visually, the
#' color axis will appear as a gradient or as separate items inside the
#' legend, depending on whether the axis is scalar or based on data classes.
#'
#' For supported color formats, see the docs article about colors.
#'
#' A scalar color axis is represented by a gradient. The colors either range
#' between the minColor and the maxColor, or for more fine grained control
#' the colors can be defined in stops. Often times, the color axis needs to
#' be adjusted to get the right color spread for the data. In addition to
#' stops, consider using a logarithmic axis type, or setting min and max to
#' avoid the colors being determined by outliers.
#'
#' When dataClasses are used, the ranges are subdivided into separate
#' classes like categories based on their values. This can be used for
#' ranges between two values, but also for a true category. However, when
#' your data is categorized, it may be as convenient to add each category to
#' a separate series.
#'
#' Color axis does not work with: `sankey`, `sunburst`, `dependencywheel`,
#' `networkgraph`, `venn`, `gauge` and `solidgauge` series types.
#'
#' Since v7.2.0 `colorAxis` can also be an array of options objects.
#'
#' See the Axis object for programmatic access to the axis.
#'
#' @param hc A `highchart` `htmlwidget` object.
#' @param ... Options defined in <https://api.highcharts.com/highcharts/colorAxis>.
#' @example dev/examples-api/colorAxis.R
#' @export
hc_colorAxis <- function(hc, ...) {
  .hc_opt(hc, "colorAxis", ...)
}

#' Colors options for highcharter objects
#'
#' An array containing the default
#' colors for the chart's series. When all colors are used, new colors are
#' pulled from the start again.
#'
#' Default colors can also be set on a series or series.type basis, see
#' column.colors, pie.colors.
#'
#' In styled mode, the colors option doesn't exist. Instead, colors are
#' defined in CSS and applied either through series or point class names, or
#' through the chart.colorCount option.
#'
#' @param hc A `highchart` `htmlwidget` object.
#' @param colors A vector of series colors.
#' @seealso <https://api.highcharts.com/highcharts/colors>
#' @example dev/examples-api/colors.R
#' @export
hc_colors <- function (hc, colors)
{
    assertthat::assert_that(is.vector(colors))
    if (length(colors) == 1L)
        colors <- list(colors)
    hc$x$hc_opts$colors <- colors
    hc
}

#' Connectors options for highcharter objects
#'
#' The Pathfinder module allows you to define connections between
#' any two points, represented as lines - optionally with markers for the
#' start and/or end points. Multiple algorithms are available for
#' calculating how the connecting lines are drawn.
#'
#' Connector functionality requires Highcharts Gantt to be loaded. In Gantt
#' charts, the connectors are used to draw dependencies between tasks.
#'
#' @param hc A `highchart` `htmlwidget` object.
#' @param ... Options defined in <https://api.highcharts.com/gantt/connectors>.
#' @example dev/examples-api/connectors.R
#' @export
hc_connectors <- function(hc, ...) {
  .hc_opt(hc, "connectors", ...)
}

#' Credits options for highcharter objects
#'
#' Highcharts by default puts a
#' credits label in the lower right corner of the chart. This can be changed
#' using these options.
#'
#' @param hc A `highchart` `htmlwidget` object.
#' @param ... Options defined in <https://api.highcharts.com/highcharts/credits>.
#' @example dev/examples-api/credits.R
#' @export
hc_credits <- function(hc, ...) {
  .hc_opt(hc, "credits", ...)
}

#' Data options for highcharter objects
#'
#' The Data module provides a
#' simplified interface for adding data to a chart from sources like CVS,
#' HTML tables or grid views. See also the tutorial article on the Data
#' module.
#'
#' It requires the `modules/data.js` file to be loaded.
#'
#' Please note that the default way of adding data in Highcharts, without
#' the need of a module, is through the series._type_.data option.
#'
#' @param hc A `highchart` `htmlwidget` object.
#' @param ... Options defined in <https://api.highcharts.com/highcharts/data>.
#' @example dev/examples-api/data.R
#' @export
hc_data <- function(hc, ...) {
  .hc_opt(hc, "data", ...)
}

#' Defs options for highcharter objects
#'
#' Options for configuring markers
#' for annotations.
#'
#' An example of the arrow marker:
#'
#' @param hc A `highchart` `htmlwidget` object.
#' @param ... Options defined in <https://api.highcharts.com/highcharts/defs>.
#' @example dev/examples-api/defs.R
#' @export
hc_defs <- function(hc, ...) {
  .hc_opt(hc, "defs", ...)
}

#' Drilldown options for highcharter objects
#'
#' Options for drill down, the concept of inspecting
#' increasingly high resolution data through clicking on chart items like
#' columns or pie slices.
#'
#' @param hc A `highchart` `htmlwidget` object.
#' @param ... Options defined in <https://api.highcharts.com/highcharts/drilldown>.
#' @example dev/examples-api/drilldown.R
#' @export
hc_drilldown <- function(hc, ...) {
  .hc_opt(hc, "drilldown", ...)
}

#' Exporting options for highcharter objects
#'
#' Options for the exporting
#' module. For an overview on the matter, see the docs and read our Fair
#' Usage Policy.
#'
#' @param hc A `highchart` `htmlwidget` object.
#' @param ... Options defined in <https://api.highcharts.com/highcharts/exporting>.
#' @example dev/examples-api/exporting.R
#' @export
hc_exporting <- function(hc, ...) {
  .hc_opt(hc, "exporting", ...)
}

#' Legend options for highcharter objects
#'
#' The legend is a box containing a
#' symbol and name for each series item or point item in the chart. Each
#' series (or points in case of pie charts) is represented by a symbol and
#' its name in the legend.
#'
#' It is possible to override the symbol creator function and create custom
#' legend symbols.
#'
#' @param hc A `highchart` `htmlwidget` object.
#' @param ... Options defined in <https://api.highcharts.com/highcharts/legend>.
#' @example dev/examples-api/legend.R
#' @export
hc_legend <- function(hc, ...) {
  .hc_opt(hc, "legend", ...)
}

#' Loading options for highcharter objects
#'
#' The loading options control the
#' appearance of the loading screen that covers the plot area on chart
#' operations. This screen only appears after an explicit call to
#' `chart.showLoading()`. It is a utility for developers to communicate to
#' the end user that something is going on, for example while retrieving new
#' data via an XHR connection. The "Loading..." text itself is not part of
#' this configuration object, but part of the `lang` object.
#'
#' @param hc A `highchart` `htmlwidget` object.
#' @param ... Options defined in <https://api.highcharts.com/highcharts/loading>.
#' @example dev/examples-api/loading.R
#' @export
hc_loading <- function(hc, ...) {
  .hc_opt(hc, "loading", ...)
}

#' mapNavigation options for highcharter objects
#'
#' The `mapNavigation` option handles buttons for navigation in
#' addition to `mousewheel` and `doubleclick` handlers for map zooming.
#'
#' @param hc A `highchart` `htmlwidget` object.
#' @param ... Options defined in <https://api.highcharts.com/highmaps/mapNavigation>.
#' @example dev/examples-api/mapNavigation.R
#' @export
hc_mapNavigation <- function(hc, ...) {
  .hc_opt(hc, "mapNavigation", ...)
}

#' mapView options for highcharter objects
#'
#' The `mapView` options control the initial view of the chart,
#' and how projection is set up for raw geoJSON maps (beta as of v9.3).
#'
#' To set the view dynamically after chart generation, see mapView.setView.
#'
#' @param hc A `highchart` `htmlwidget` object.
#' @param ... Options defined in <https://api.highcharts.com/highmaps/mapView>.
#' @example dev/examples-api/mapView.R
#' @export
hc_mapView <- function(hc, ...) {
  .hc_opt(hc, "mapView", ...)
}

#' Navigation options for highcharter objects
#'
#' A collection of options for
#' buttons and menus appearing in the exporting module or in Stock Tools.
#'
#' @param hc A `highchart` `htmlwidget` object.
#' @param ... Options defined in <https://api.highcharts.com/highcharts/navigation>.
#' @example dev/examples-api/navigation.R
#' @export
hc_navigation <- function(hc, ...) {
  .hc_opt(hc, "navigation", ...)
}

#' Navigator options for highcharter objects
#'
#' The navigator is a small series below the main series,
#' displaying a view of the entire data set. It provides tools to zoom in
#' and out on parts of the data as well as panning across the dataset.
#'
#' @param hc A `highchart` `htmlwidget` object.
#' @param ... Options defined in <https://api.highcharts.com/highstock/navigator>.
#' @example dev/examples-api/navigator.R
#' @export
hc_navigator <- function(hc, ...) {
  .hc_opt(hc, "navigator", ...)
}

#' noData options for highcharter objects
#'
#' Options for displaying a message like "No
#' data to display". This feature requires the file no-data-to-display.js to
#' be loaded in the page. The actual text to display is set in the
#' lang.noData option.
#'
#' @param hc A `highchart` `htmlwidget` object.
#' @param ... Options defined in <https://api.highcharts.com/highcharts/noData>.
#' @example dev/examples-api/noData.R
#' @export
hc_noData <- function(hc, ...) {
  .hc_opt(hc, "noData", ...)
}

#' Pane options for highcharter objects
#'
#' The pane serves as a container for axes and backgrounds for
#' circular gauges and polar charts.
#'
#' When used in `Highcharts.setOptions` for theming, the pane must be a
#' single object, otherwise arrays are supported.
#'
#' @param hc A `highchart` `htmlwidget` object.
#' @param ... Options defined in <https://api.highcharts.com/highcharts/pane>.
#' @example dev/examples-api/pane.R
#' @export
hc_pane <- function(hc, ...) {
  .hc_opt(hc, "pane", ...)
}

#' plotOptions options for highcharter objects
#'
#' The plotOptions is a wrapper
#' object for config objects for each series type. The config objects for
#' each series can also be overridden for each series item as given in the
#' series array.
#'
#' Configuration options for the series are given in three levels. Options
#' for all series in a chart are given in the plotOptions.series object.
#' Then options for all series of a specific type are given in the
#' plotOptions of that type, for example `plotOptions.line`. Next, options
#' for one single series are given in the series array.
#'
#' @param hc A `highchart` `htmlwidget` object.
#' @param ... Options defined in <https://api.highcharts.com/highcharts/plotOptions>.
#' @example dev/examples-api/plotOptions.R
#' @export
hc_plotOptions <- function(hc, ...) {
  .hc_opt(hc, "plotOptions", ...)
}

#' rangeSelector options for highcharter objects
#'
#' The range selector is a tool for selecting ranges to
#' display within the chart. It provides buttons to select preconfigured
#' ranges in the chart, like 1 day, 1 week, 1 month etc. It also provides
#' input boxes where min and max dates can be manually input.
#'
#' @param hc A `highchart` `htmlwidget` object.
#' @param ... Options defined in <https://api.highcharts.com/highstock/rangeSelector>.
#' @example dev/examples-api/rangeSelector.R
#' @export
hc_rangeSelector <- function(hc, ...) {
  .hc_opt(hc, "rangeSelector", ...)
}

#' Responsive options for highcharter objects
#'
#' Allows setting a set of rules to
#' apply for different screen or chart sizes. Each rule specifies additional
#' chart options.
#'
#' @param hc A `highchart` `htmlwidget` object.
#' @param ... Options defined in <https://api.highcharts.com/highcharts/responsive>.
#' @example dev/examples-api/responsive.R
#' @export
hc_responsive <- function(hc, ...) {
  .hc_opt(hc, "responsive", ...)
}

#' Scrollbar options for highcharter objects
#'
#' The scrollbar is a means of panning over the X axis of
#' a stock chart. Scrollbars can also be applied to other types of axes.
#'
#' Another approach to scrollable charts is the chart.scrollablePlotArea
#' option that is especially suitable for simpler cartesian charts on
#' mobile.
#'
#' In styled mode, all the presentational options for the scrollbar are
#' replaced by the classes `.highcharts-scrollbar-thumb`,
#' `.highcharts-scrollbar-arrow`, `.highcharts-scrollbar-button`,
#' `.highcharts-scrollbar-rifles` and `.highcharts-scrollbar-track`.
#'
#' @param hc A `highchart` `htmlwidget` object.
#' @param ... Options defined in <https://api.highcharts.com/highstock/scrollbar>.
#' @example dev/examples-api/scrollbar.R
#' @export
hc_scrollbar <- function(hc, ...) {
  .hc_opt(hc, "scrollbar", ...)
}

#' Series options for highcharter objects
#'
#' Series options for specific data
#' and the data itself. In TypeScript you have to cast the series options to
#' specific series types, to get all possible options for a series. (see
#' online documentation for example)
#'
#' @param hc A `highchart` `htmlwidget` object.
#' @param ... Options defined in <https://api.highcharts.com/highcharts/series>.
#' @example dev/examples-api/series.R
#' @export
hc_series <- function(hc, ...) {
  .hc_opt(hc, "series", ...)
}

#' Sonification options for highcharter objects
#'
#' Play chart data as sound. Set the playback duration, instruments and volume.
#'
#' @param hc A `highchart` `htmlwidget` object.
#' @param ... Options defined in <https://api.highcharts.com/highcharts/sonification>.
#' @example dev/examples-api/sonification.R
#' @export
hc_sonification <- function(hc, ...) {
  .hc_opt(hc, "sonification", ...)
}

#' stockTools options for highcharter objects
#'
#' Configure the stockTools gui strings in the chart. Requires
#' the stockTools module to be loaded. For a description of the module
#' and information on its features, see Highcharts StockTools.
#'
#' @param hc A `highchart` `htmlwidget` object.
#' @param ... Options defined in <https://api.highcharts.com/highstock/stockTools>.
#' @example dev/examples-api/stockTools.R
#' @export
hc_stockTools <- function(hc, ...) {
  .hc_opt(hc, "stockTools", ...)
}

#' Subtitle options for highcharter objects
#'
#' The chart's subtitle. This can
#' be used both to display a subtitle below the main title, and to display
#' random text anywhere in the chart. The subtitle can be updated after
#' chart initialization through the `Chart.setTitle` method.
#'
#' @param hc A `highchart` `htmlwidget` object.
#' @param ... Options defined in <https://api.highcharts.com/highcharts/subtitle>.
#' @example dev/examples-api/subtitle.R
#' @export
hc_subtitle <- function(hc, ...) {
  .hc_opt(hc, "subtitle", ...)
}

#' Time options for highcharter objects
#'
#' Time options that can apply
#' globally or to individual charts. These settings affect how `datetime`
#' axes are laid out, how tooltips are formatted, how series
#' pointIntervalUnit works and how the Highcharts Stock range selector
#' handles time.
#'
#' The common use case is that all charts in the same Highcharts object
#' share the same time settings, in which case the global settings are set
#' using `setOptions`.
#'
#' Since v6.0.5, the time options were moved from the `global` object to the
#' `time` object, and time options can be set on each individual chart.
#'
#' @param hc A `highchart` `htmlwidget` object.
#' @param ... Options defined in <https://api.highcharts.com/highcharts/time>.
#' @example dev/examples-api/time.R
#' @export
hc_time <- function(hc, ...) {
  .hc_opt(hc, "time", ...)
}

#' Title options for highcharter objects
#'
#' The chart's main title.
#'
#' @param hc A `highchart` `htmlwidget` object.
#' @param ... Options defined in <https://api.highcharts.com/highcharts/title>.
#' @example dev/examples-api/title.R
#' @export
hc_title <- function(hc, ...) {
  .hc_opt(hc, "title", ...)
}

#' Tooltip options for highcharter objects
#'
#' Options for the tooltip that
#' appears when the user hovers over a series or point.
#'
#' @param hc A `highchart` `htmlwidget` object.
#' @param ... Options defined in <https://api.highcharts.com/highcharts/tooltip>.
#' @param sort Sort shared tooltip points by descending value.
#' @param table Display the shared tooltip as an HTML table.
#' @example dev/examples-api/tooltip.R
#' @export
hc_tooltip <- function (hc, ..., sort = FALSE, table = FALSE)
{
    if (sort)
        hc <- .hc_tooltip_sort(hc)
    if (table)
        hc <- .hc_tooltip_table(hc)
    if (length(list(...)))
        hc <- .hc_opt(hc, "tooltip", ...)
    hc
}

#' xAxis options for highcharter objects
#'
#' The X axis or category axis.
#' Normally this is the horizontal axis, though if the chart is inverted
#' this is the vertical axis. In case of multiple axes, the xAxis node is an
#' array of configuration objects.
#'
#' See the Axis class for programmatic access to the axis.
#'
#' @param hc A `highchart` `htmlwidget` object.
#' @param ... Options defined in <https://api.highcharts.com/highcharts/xAxis>.
#' @example dev/examples-api/xAxis.R
#' @export
hc_xAxis <- function(hc, ...) {
  .hc_opt(hc, "xAxis", ...)
}

#' yAxis options for highcharter objects
#'
#' The Y axis or value axis.
#' Normally this is the vertical axis, though if the chart is inverted this
#' is the horizontal axis. In case of multiple axes, the yAxis node is an
#' array of configuration objects.
#'
#' See the Axis object for programmatic access to the axis.
#'
#' @param hc A `highchart` `htmlwidget` object.
#' @param ... Options defined in <https://api.highcharts.com/highcharts/yAxis>.
#' @example dev/examples-api/yAxis.R
#' @export
hc_yAxis <- function(hc, ...) {
  .hc_opt(hc, "yAxis", ...)
}

#' zAxis options for highcharter objects
#'
#' The Z axis or depth axis for 3D plots.
#'
#' See the Axis class for programmatic access to the axis.
#'
#' @param hc A `highchart` `htmlwidget` object.
#' @param ... Options defined in <https://api.highcharts.com/highcharts/zAxis>.
#' @example dev/examples-api/zAxis.R
#' @export
hc_zAxis <- function(hc, ...) {
  .hc_opt(hc, "zAxis", ...)
}

