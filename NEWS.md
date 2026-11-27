# highcharter (development version)

Bundled Highcharts JS: 12.6.2.

* `hc_connect()` links tooltips, crosshairs, X zoom and legend visibility
  across widgets in HTML documents, including separate Quarto chunks.

* Cluster dendrograms use a native treegraph with rectangular branches at
  the observed merge heights. Set `link$type` to change the branch shape.

## Upgrading from CRAN 0.9.5

* CRAN 0.9.5 shipped Highcharts JS 9.3.1. Development on GitHub moved to
  Highcharts JS 12.6.0 in highcharter 0.12.6.1 and now bundles 12.6.2.
* highcharter now requires R 4.1 or later. New code can use the base R pipe
  `|>`. Packages that import `%>%` from highcharter should import it from
  magrittr instead.
* Charts, Stock, Maps and Gantt share one JavaScript bundle with accessibility
  enabled. Use `highchartstock()` for Stock Tools and technical indicators.
* `hchart()` now draws fitted decision trees, random forest error curves,
  glmnet cross-validation intervals, cluster dendrograms and phylogenies.
* The [migration guide](#migrate-highcharter-calls) covers retired chart shortcuts,
  widget constructors, Shiny bindings, theme presets and axis helpers.

## Breaking changes

* With an empty mapping, `hchart()` and `hcpxy_set_data()` now pass a data
  frame's `color` column directly to Highcharts as the point color, matching
  `hc_add_series()`. In tooltips for these points, use `{point.color}` in
  place of `{point.colorv}`. With a mapping such as `hcaes(x, y)`, an
  unmapped `color` column remains available as `{point.colorv}`.

* Treemaps and sunbursts use one color from the chart theme per first-level
  group. Children inherit their parent's color. `data_to_hierarchical()`
  now omits the node's `color` field by default. To fix colors explicitly,
  pass a vector to its `colors` argument. This replaces the
  `highcharter.color_palette` option.

* Removed the R options `highcharter.verbose`, `highcharter.debug` and
  `highcharter.download_map_data`. For indented widget JSON, use
  `options(htmlwidgets.TOJSON_ARGS = list(pretty = TRUE))`. For maps outside
  the package, `hcmap()` downloads in R by default. Pass
  `download_map_data = FALSE` to load the map in the browser.

* `world_income` replaces `gni2014` with Atlas-method GNI per capita
  (current US dollars) and population for 2024 and 2025.

* Removed the bundled geometries `usgeojson`, `worldgeojson` and
  `uscountygeojson`. Their `hcmap()` keys are `"us"`,
  `"custom/world-robinson-lowres"` and `"countries/us/us-all-all"`,
  respectively. The `unemployment` dataset was also removed.

* `city_weather` supplies daily temperatures for four cities in 2025. Average
  `temp_mean` by city and month to migrate examples using `citytemp` or
  `citytemp_long`. For a daily range, select one city and use `temp_min` and
  `temp_max`. This replaces the `weather` sample from San Francisco in 2014.
  The historical `globaltemp` and `mountains_panorama`
  datasets have been retired. The showcase defines `favorite_bars` and
  `favorite_pies` locally, keeps the star sample with the article, and uses
  annual MCV1 coverage in place of the historical `vaccines` incidence table.

* Widgets now use `yyjsonr` to write JSON. Remove
  `options(highcharter.rjson = TRUE)` from application code. Missing
  observations stay in their original positions and reach Highcharts as
  `null`. A missing optional field also preserves its point. For custom
  `htmlwidgets.TOJSON_ARGS`, the widget writer accepts `pretty` and `digits`.

* Removed `hcparcords()`. Pass your measurement columns to
  `data_to_parallel_coordinates()`, enable `parallelCoordinates = TRUE` in
  `hc_chart()` and add the result with `hc_add_series_list()`. Use
  `hc_xAxis(categories = names(measurements))` for the axis labels.
  Each axis now displays its original units. Supply series names or colors
  explicitly, one per observation. See the
  [migration example](https://jkunst.com/highcharter/articles/data-helpers.html#parallel-coordinates).

* `is.highchart()` recognizes the `highchart` and `highchartstock` widget
  classes. The legacy `highchart2` class is no longer recognized on its own.
  Tibbles use the `data.frame` method for `hchart()`.

* New charts use the same English preset as `hc_set_language("en")`. In
  English, `12,345.67` uses a comma for thousands. To keep a space, use
  `hc_set_language("en", thousandsSep = " ")`. Drilldown navigation uses the
  Highcharts breadcrumb labels.

* Removed the `google_fonts` argument from `highchart()` and `highchartstock()`
  and the `highcharter.google_fonts` option. Bundled families work offline by
  name. Other plain family names use fonts supplied by the page or device.
  To include an external font with the widget, set `chart.style.fontFamily`
  in `hc_theme()` to `sass::font_google("Noto Sans")`. Use `local = FALSE`
  for a link to Google Fonts. See `vignette("themes", package = "highcharter")`.

* Give each Highcharts option in `...` a name, for example
  `hc_title(hc, text = "Sales")`. Collections still accept positional objects,
  as in `hc_yAxis(hc, list(id = "sales"), list(id = "margin"))`.

* Renamed `df_to_annotations_labels()` to `data_to_annotation_labels()`.
  Pass the table as `data` and use `xAxis` and `yAxis` to select the axes
  for the labels.

* Shiny event helpers now include the event scope in the input name. For an
  output named `sales`, migrate `input$sales_mouseOver` to
  `input$sales_point_mouseOver` or `input$sales_series_mouseOver`, according
  to the helper used. Read point clicks at `input$sales_point_click`;
  Shiny registers them automatically.

* Removed `hc_rm_series()`. Select the series to include when building a
  chart. In Shiny, use `hcpxy_remove_series(proxy, id = ...)` to remove a
  series by its ID after the chart is rendered.

* `hc_xAxis()`, `hc_yAxis()` and `hc_zAxis()` now accept one or several
  axis definitions. Replace `hc_xAxis_multiples()` and `hc_zAxis_multiples()`
  with the corresponding axis function. `hc_yAxis_multiples()` remains a
  deprecated alias. Replace successive `hc_add_yAxis()` calls with a single
  `hc_yAxis()` call. Use `create_axis()` to calculate relative panel heights.

* Use `highchart()` in place of `highchartzero()`. In Shiny, replace
  `highchartOutputZ()` and `renderHighchartZ()` with `highchartOutput()`
  and `renderHighchart()` together. The regular widget applies the package
  options and uses the knitr figure dimensions. Set `width = "100%"` to
  fill the available width in R Markdown.

* Use `hcaes_string()` in place of the removed alias `hcaes_()`.

* `hchart()` and `hc_add_series()` now draw a separate line for each
  ordinary `xts` column. One instrument with Open, High, Low and Close
  produces candlesticks by default. For mixed OHLC instruments, select
  the columns for one instrument per call.

* The `fast` argument for data-frame series has been removed. Omit it in
  `hchart()` and `hc_add_series()`. Their point data stay editable as R lists
  until the widget is serialized.

* This release replaces the per-preset constructors with one public constructor.
  The collection keeps `tufte` as its single Tufte preset. The theme vignette
  shows how to recreate the former `tufte2` bar style. This release refreshes
  `ft` and `economist` and adds `carbon`, `cloudscape` and `bslib`.
  Cloudscape uses the AWS chart palette and Open Sans, with circular markers
  and gridlines on both axes. The bslib preset inherits Bootstrap colors and the base font.

## New features

* `hchart()` draws the counterfactual prediction, pointwise effect and
  cumulative effect from a `CausalImpact` fit with posterior intervals
  and a marker at the start of the intervention (#274).

* `color_stops()` accepts optional `positions` to place each supplied color
  at an exact point on the gradient.

* `hchart(ecdf(x))` draws an empirical cumulative distribution as a step line.

* `hchart()` draws random forest error histories, cross-validation points
  and standard error bars for glmnet, and individual XGBoost trees. Cluster
  dendrograms preserve merge heights, and radial or rectangular phylogenies
  preserve branch lengths. Random forests compare multiple error curves in
  a shared tooltip table. Crosshairs on glmnet charts let you compare error
  bars at the same metric value. Model packages are optional.

* `hchart()` draws classification and regression trees from `partykit` and
  `rpart`, and single C5.0 classification trees. Node area shows the number of
  observations. Donuts or bars show class composition and a color axis shows
  the mean response for regression. Light gray branches show the split
  condition in dark text with a white outline. Tree packages are optional.

* `hchart()` draws one-way tables as column charts and two-way tables as
  heatmaps, preserving category order, dimension labels and zero counts.

* `hc_gridAxis()` arranges pairs of axes in a rectangular grid.
  `hchart()` uses it to draw multivariate ACF, PACF and autocovariance
  objects with one panel per series pair and a common vertical scale.

* `hchart()` now accepts `type = "tilemap"` and `type = "contour"` for
  numeric matrices. The default is `"heatmap"`.

* `hchart()` and `hc_add_series()` draw each geometry family in a mixed
  `geojsonio` FeatureCollection, with polygons below lines and points.
  Supply `type` to draw just one family. Both `geo_json` and `geo_list` are supported.

* Charts, Stock, Maps and Gantt share one JavaScript bundle. Accessibility is included
  by default, including keyboard navigation (#755).

* The bundle now includes the official chart types and common feature modules. A new
  `highchartstock()` widget adds Stock Tools, advanced annotations and technical indicators.
  Third-party Motion, Regression, Grouped Categories and Draggable Legend plugins remain optional.

* `hc_add_series_list()` draws a single numeric value as one point, matching
  `hc_add_series()`. Histograms use the actual bin limits for their labels
  and draw unequal-width bins to scale.

* Ten new option wrappers cover accessibility, map views, time zones, data
  imports, empty charts, SVG definitions, sonification, navigation, Stock Tools
  and Gantt connectors. Each has a runnable example in its help page.

* `hc_set_language()` sets the language for new charts in the current R
  process. Chart controls are available in English (`en`, the default),
  Spanish (`es`), Portuguese (`pt`), French (`fr`), Norwegian Bokmål (`nb`),
  Japanese (`ja`), Korean (`ko`) and Simplified Chinese (`zh-CN`).
  Regional tags select the date and number formats used by the browser.
  `hc_language()` returns the corresponding options list.

* Theme presets now use `hc_theme("ft")` and live in individual YAML files.
  `hc_themes()` lists the collection. `hc_set_theme()` selects a preset or
  a custom theme for subsequent charts. See `vignette("themes", package = "highcharter")`.

* `hcpxy_set_extremes()` controls an x-axis range from Shiny. `hcpxy_set_data()`
  can now target a series by ID, which is safer when Stock indicators change series order.

* `hchart()` plots the original and adjusted series from a seasonal X-13 fit and labels its outliers.

* `hchart(stats::decompose(x))` displays the observed series, seasonality, trend
  and remainder in four panels. Series with frequencies outside the annual,
  quarterly and monthly calendars use their numeric time index.

* X-range series accept `Date` and `POSIXt` columns for both interval ends
  (`x` and `x2`).

## Changes

* Data-frame charts and empirical distributions use the Highcharts legend
  default. A single standalone line, column or scatter series now appears in
  the legend. Supply `name` to label it or `showInLegend = FALSE` to hide it.

* For matrices without row or column names, `hchart()` fits the axes to the
  grid in heatmap, tilemap and contour charts. The axes can still expand
  when adding another series.

* Passing an `lm` or `loess` object to `hc_add_series()` now warns and still
  draws the fitted curve and its band (plus or minus two standard errors).
  Both methods will remain available throughout the first release with this
  warning. To migrate, call `predict()` and pass a data frame to
  `hc_add_series()`, as in the
  [First steps example](https://jkunst.com/highcharter/articles/first-steps.html#a-more-advanced-example).

* Widgets attach the Latin WOFF2 files for the bundled families selected by
  their theme and chart options. Charts using system fonts need no font files.

* `hchart()` shows ACF and PACF as lollipops at their reported lags.
  Multivariate time series and decompositions use shared table tooltips.

* Histograms created by `hchart()` use square corners by default.

* The hcrt, carbon and smpl themes use regular-weight titles, labels and tooltip values.

* The sparkline tooltip shows the point value in one outlined line and stays
  inside the chart at either edge.
* The export menu defaults to three dots. The three Highcharts theme adaptations
  keep their original menu icon. Sand Signika tiles its sand texture at native size.
* `hcmap("jp")` reads the packaged map of Japan by country code.
  `hc_maps()` lists the 202 country maps and five custom maps available offline.
  `get_data_from_map()` reads join properties from GeoJSON and TopoJSON. Other
  collection paths retain CDN support. The income example uses `world_income`.
* ACF and PACF ticks stay within the correlation range, with room for endpoint markers.

* Forecast charts distinguish observations, forecasts and prediction intervals
  in the legend and shared tooltip. The tooltip shows both interval limits.
  Custom series names are supported.

* The hcrt and smpl presets use circular markers consistently across series.

* The classic Highcharts themes use the 12.6.0 palettes and legend backgrounds.
  Dark presets have more legible axis labels. Monokai now uses four distinct
  series colors. The Bloom preset places its value axis on the right, and
  sparkline presets hide their legends by default.

* The chalk, handdrawn and sandsignika presets embed their original backgrounds
  for offline use. The Carbon preset draws horizontal and vertical gridlines
  and uses circular point markers across series.

* highcharter uses base R for argument validation, model predictions, row conversion
  and option merging. Charts of `lm` and `loess` fits now include the fitted
  curve and its two-standard-error band.

* `xts` is optional. Charting OHLC prices also uses `quantmod`.

* `download_map_data()` uses R's configured download method by default.

* Attaching highcharter in an interactive session points to `?highcharter`
  for the licensing terms of the R package and the bundled Highcharts library.

## Bug fixes

* `hchart.survfit()` with `fun = "logpct"` now uses a logarithmic y-axis capped
  at 100 and maps non-positive survival values to `NA`, matching `fun = "log"`.

* `hchart()` now uses the levels of a factor mapped to `x` to order the
  x-axis categories, including when the data are split into series (#373).

* Table tooltips show whole counts without decimal places. Matrix heatmaps,
  tilemaps and contours honor `hc_tooltip(valueDecimals = ...)`.

* `hcmap()` and `hc_add_series_map()` use the column named by `value`
  even when the input already contains a different column called `value`.

* Joined maps use the data range for their color scale. Adding a map layer
  with `hc_add_series_map()` preserves any color axes already configured.
  Use `hc_colorAxis(min = 0)` for a scale that starts at zero.

* `hchart.survfit()` uses a logarithmic probability axis for `fun = "log"`
  and a logarithmic time axis for `fun = "cloglog"`. Curves and confidence
  bands have gaps where their values fall outside the scale's domain.

* `hchart()` now passes series options to matrix, distance and ACF plots.
  ETS component charts also accept series options and layout arguments such
  as `separate = FALSE`.

* Adding a forecast, linear model or loess fit preserves R's random-number
  state when linking the fitted series to its intervals.

* `color_stops(1)` places a single color at zero. Supply a positive integer
  for the number of stops.

* `export_hc()` appends `.js` to filenames such as `salesjs` and preserves
  the JavaScript extensions `.js`, `.mjs` and `.cjs`.

* Reusing one `tooltip_chart()` formatter across widgets now renders each
  mini chart in its own tooltip. The helper preserves `JS()` callbacks in
  `hc_opts` and accepts data column names containing spaces or hyphens.

* `hchart.survfit()` draws a separate curve for each Cox prediction profile
  within each stratum. Confidence bands follow the corresponding curve, and
  censoring markers include times with multiple censored observations.
  Censoring markers now use their curve's color by default. Use
  `markerColor = "black"` to draw all markers in black.
  This method requires survival 3.6-5 or later.

* Boxplots from `data_to_boxplot()` place outliers at the same x coordinate as
  their box when categories differ between series. Hiding a single boxplot
  series in the legend now also hides its outliers.

* Treemap and sunburst nodes from `data_to_hierarchical()` now keep the
  correct parent when labels on different paths produce the same ID.

* Stock Tools now loads its indicators and embeds its toolbar icons in
  self-contained HTML widgets and vignettes.

* Stock Tools can add technical indicators after another widget renders or
  re-renders on the same page (#595).

* Data-frame heatmaps position dates and times on either axis and accept omitted
  coordinates. Date cells span one day. Date-time cells use the shortest observed
  interval on their axis, or one second for a single time. Set `colsize` or
  `rowsize` to choose a different interval in milliseconds.

* Multivariate forecasts plot the predictions and intervals for each series
  on shared or separate axes. The legend toggles each confidence level
  across all panels.

* Shiny proxies now send zero messages when there are no series to add,
  remove or update, or no points to update.

* Forecast charts use the same time index for predictions and their intervals.
  Series with frequencies other than 1, 4 or 12 use a numeric axis.

* `data_to_sankey()` counts transitions between consecutive columns, skips
  links with missing endpoints and assigns unique link IDs. Numeric binning
  handles missing values and tied quantiles. Inputs with fewer than two
  columns return an empty link table.

* Axes with one category now display its label on the axis and in tooltips,
  including when the category is numeric (#395, #438).

* `hchart(data, type = "gantt")` selects the native Gantt constructor for data
  frames, preserving task rows, date axes and dependency links.

* Supplying a new `rules` list to `hc_responsive()` replaces the previous rules.

* Circle-only presets preserve rectangular heatmap cells. The hcrt theme uses
  IBM Plex Sans for credits. French, Norwegian Bokmål and Simplified Chinese
  use official Highcharts language packs. Japanese and Korean use AI-generated
  translations.

* `hcmap()` accepts an already loaded GeoJSON list without downloading map data.
  Network charts preserve the current theme while hiding their coordinate axes.

* With reflow enabled, charts fill the available widget width and height in
  the Viewer and standalone browser, including after resizing. Percentage-height containers no longer leave
  the chart at Highcharts' 400-pixel fallback height.

* The Motion plugin uses native array iteration with the bundled Highcharts.

* PCA charts now scale each component separately and label axes with the
  percentage of variance explained. Points are shown by default. Use
  `loadings = TRUE` for variable arrows and `label = TRUE` for observation names.

* `hcaes()` and `hcaes_string()` evaluate expressions in the environment
  where the mapping was created. Computed axes show the expression as their
  title. Date and date-time mappings use millisecond timestamps. Grouped
  data-frame charts build point lists using row indices.

* Data-frame charts can inherit the chart type or receive empty data.
  Point colors retain supplied hex values alongside missing values, and
  factor colors handle unused levels.

* Heatmaps of `dist` objects now respect the matrix display options
  `label` and `showInLegend`.

* Matrix heatmaps now use matrix positions directly, including when labels
  repeat or cells contain missing values. highcharter no longer requires tidyr.

## Migration guide

<a id="migrate-highcharter-calls"></a>

The first column includes calls exported by CRAN 0.9.5. Some of these were
already deprecated in that version.

| Previous call | Current call |
| --- | --- |
| `%>%` from highcharter | Use the base R pipe, or attach magrittr for existing scripts. In a package, add magrittr to `Imports` and change the namespace import to `importFrom(magrittr, "%>%")`. |
| `dt_tstp(x)`, `create_yaxis(...)` | Use `datetime_to_timestamp(x)` and `create_axis(...)`, respectively. |
| `df_to_annotations_labels(df = notes)` | `data_to_annotation_labels(data = notes)` |
| `hc_xAxis_multiples()`, `hc_yAxis_multiples()`, `hc_zAxis_multiples()` | Pass the same list of axes to `hc_xAxis()`, `hc_yAxis()` or `hc_zAxis()`. The Y alias emits a deprecation warning. |
| `hc_add_dependency("modules/...")` | Omit the call for built-in modules. Use `highchartstock()` for Stock Tools and technical indicators. Pass an explicit `"plugins/..."` path for packaged community plugins. |
| Repeated `hc_add_yAxis()` | Collect the axes in order, then call `hc_yAxis(axes)`. |
| `hc_theme_google()` and other preset constructors | Use `hc_theme("google")`, or `hc_set_theme("google")` for a session default. |
| `hcaes_()` | Use `hcaes_string()`. |
| `highchart2()`, `highchartzero()` | Use `highchart()`. |
| `highchartOutput2()`, `highchartOutputZ()` | Use `highchartOutput()` in the Shiny UI. |
| `renderHighchart2()`, `renderHighchartZ()` | Use `renderHighchart()` on the Shiny server. |
| `hcboxplot()` | Create the series with `data_to_boxplot()` and add them with `hc_add_series_list()`. Set `add_outliers = TRUE` to preserve the old default. See the example below. |
| `hctreemap()`, `hctreemap2()` | Start from the original data frame, build nodes with `data_to_hierarchical()`, then call `hchart(nodes, type = "treemap")`. [Hierarchy example](https://jkunst.com/highcharter/articles/data-helpers.html#hierarchy-nodes) |
| `hcspark(x)` | Add `x` with `hc_add_series(data = x)` and apply `hc_add_theme(hc_theme("sparkline"))`. |
| `hciconarray()` | For counts drawn as pictograms, use an item series. [Pictogram example](https://jkunst.com/highcharter/articles/showcase.html#count-with-pictograms) |
| `hc_add_dependency_fa()`, `fa_icon()`, `fa_icon_mark()` | Use `fontawesome::fa()` for SVG icons. For chart markers, pass the SVG as an image URL. [Marker example](https://jkunst.com/highcharter/articles/showcase.html#icons-as-markers) |
| `hw_grid(chart1, chart2, ncol = 2)` | Place separate widgets side by side with `bslib::layout_column_wrap(chart1, chart2, width = 1/2)`. Use `hc_gridAxis()` for panels within a single chart. |
| `fast = TRUE` in a data-frame chart | Omit the argument. Point data are R lists. |

This example replaces `hcboxplot(iris$Petal.Length, iris$Species)` and keeps
the outliers for each species.

```r
boxes <- data_to_boxplot(iris, Petal.Length, Species, add_outliers = TRUE)

highchart() |>
  hc_xAxis(categories = levels(iris$Species)) |>
  hc_add_series_list(boxes)
```

The reverse-dependency review found calls to the removed theme constructors in
highdir, RKorAPClient and UnalR. Their integrations need the replacements above.
AovBay also references the previously removed `hcboxplot()` helper. Its
`hc_yAxis_multiples()` call is covered by the deprecated alias.

## Contributor acknowledgements

A special thank you to everyone who helped build highcharter in its early
years, before AI coding assistants were commonplace. Dean shared his work on
boxplots, Adline made it possible to plot a matrix as a heatmap, and Paul
helped Shiny users update a chart without rebuilding it. Those features grew
out of people taking the time to share an example, write a patch or work
through a bug together.

I'm grateful to each of you who did that early work and to everyone who has
kept the package working since. Thank you for your time and generosity.

Joshua Kunst

| Contributor | Contribution | Project history |
| --- | --- | --- |
| Nuno Agostinho | Survival curves, density plots, scatter series and map data download fixes. | [PR #109](https://github.com/jbkunst/highcharter/pull/109), [scatter example](https://github.com/jbkunst/highcharter/commit/574e9b84218c7f93a4243bea8c42f97751e9f4ba), [PR #844](https://github.com/jbkunst/highcharter/pull/844) |
| Danton Noriega | Character-based aesthetic mappings for programmatic use. | [PR #249](https://github.com/jbkunst/highcharter/pull/249) |
| Charlie Joey Hadley | Support for multiple event types in `hc_add_event_point()`. | [implementation](https://github.com/jbkunst/highcharter/commit/3cfc22b49193185444ce95684e5b0545d75a0a57) |
| Eduardo Flores | The first tidy-data helper for adding series. | [PR #114](https://github.com/jbkunst/highcharter/pull/114) |
| Dean Kilfoyle | The original boxplot helper and suggestions for its implementation. | [issue #81](https://github.com/jbkunst/highcharter/issues/81) |
| Adline Dsilva | The original matrix heatmap implementation. | [implementation](https://github.com/jbkunst/highcharter/commit/a4a04dd80252a4831b6a01cd909501bc22666d8d) |
| [Kamil Slowikowski](https://orcid.org/0000-0002-2843-6370) | JavaScript serialization fixes for chart export and the `JS()` re-export. | [export fix](https://github.com/jbkunst/highcharter/commit/e6fe81a9ae3ab7d12a34f35e0a19b3b51fa1f42c), [re-export](https://github.com/jbkunst/highcharter/commit/4bcf29689b81931f4c9fc9d93e33f3057e83bb6e) |
| Christian Minich | Tidy evaluation and quasiquotation in aesthetic mappings. | [PR #423](https://github.com/jbkunst/highcharter/pull/423) |
| Jonathan Armond | Preserving unmapped columns in `mutate_mapping()`. | [fix](https://github.com/jbkunst/highcharter/commit/5f54456a763d83683d0c9e2578e78f8e0b638815) |
| David Breuer | The `quiet` option for map downloads. | [PR #450](https://github.com/jbkunst/highcharter/pull/450) |
| Mauricio Vargas | Package testing, coverage and GitHub Actions. | [coverage](https://github.com/jbkunst/highcharter/commit/9f562f08d6f4a7f6542bf71e4c1d7576a9a32833), [CI](https://github.com/jbkunst/highcharter/commit/3982b2d6f73adcef5bf61d54d658e18a70288b46) |
| Michael Yan | The example that motivated the treemap and sunburst data helper. | [attribution](https://github.com/jbkunst/highcharter/commit/93986f83602d40583345979ba02c91b89a795a46) |
| Bart Oortwijn | The optional `rjson` serializer, `hc_add_yAxis()` and support on GitHub issues. | [serialization](https://github.com/jbkunst/highcharter/commit/1b9d2946c6e00592809652378ce21fc5f9458ae9), [axis helper](https://github.com/jbkunst/highcharter/commit/b7438eb3854a1121e55b3f92402d98b408bcd300) |
| Paul Campbell | The Shiny proxies for updating series data and redrawing charts. | [proxy methods](https://github.com/jbkunst/highcharter/commit/f0838eefc4d107f2f9133f61b64b6a65ddb233e6) |
| Marc Kupietz | CRAN check fixes, including an S3 method naming correction. | [PR #843](https://github.com/jbkunst/highcharter/pull/843) |

# highcharter 0.12.6.1

Bundled Highcharts JS: 12.6.0.

## Changes

* The GitHub development version updated the R option wrappers for
  Highcharts JS 12.6.0.

## Breaking changes

* Removed `hc_labels()` in favor of `hc_annotations()`. This follows the Highcharts API change where the top-level `labels` option was removed. Users should migrate custom chart labels to annotations.

## Package requirements

* Updated `Depends` to require R 4.1.0 or later (`R (>= 4.1.0)`).

## Bugs

* This version incorporated the 0.9.5 CRAN fix for HTTP 403 errors in
  `download_map_data()`.
* Wrapped examples making network calls in `\dontrun{}` (`get_data_from_map` and `hc_mapNavigation`) to fix CRAN Package Check 403 errors.
* This version also incorporated the 0.9.5 rename from `hchart.pca` to
  `hchart_pca`, which resolved the unregistered S3 method NOTE.

# highcharter 0.9.5

Bundled Highcharts JS: 9.3.1. Published on CRAN on April 22, 2026.

## Bugs

* Fixed `download_map_data` to prevent 403 Forbidden errors when fetching data (fixes CRAN Package Checks and resolves #842).
* Renamed internal helper function `hchart.pca` to `hchart_pca` to resolve an unregistered S3 method mismatch NOTE.
* Uses `page_rank` instead of deprecated `page.rank` function.
* Converts igraph membership to vector to avoid data frame coercion errors.
* Replace `class() ==` comparisons with `inherits()` in `hc_yAxis_multiples`, `hc_xAxis_multiples`, and `hc_zAxis_multiples` to fix CRAN NOTE.
* Replace deprecated `@docType "package"` with `"_PACKAGE"` sentinel in `highcharter-package.R`.
* Fixed missing or moved URLs.

# highcharter 0.9.4

## Changes

* Highcharter now uses HighchartsJS 9.3.1.
* Support highcharts gantt extension (#287). 
* Adding missed language options in `getOption("highcharter.lang")`.
* Adding `hcpxy_add_series`, `hcpxy_remove_series`, `hcpxy_update`, `hcpxy_update_series`,
`hcpxy_add_point`, `hcpxy_remove_point` and `hcpxy_loading`.
* Adding `hcpxy_set_date` and `hcpxy_redraw` thanks to @PaulC91.
* Adding `hc_loading` for use with `hcpxy_loading`.
* Adding `hcpxy_update_point` due @zevross (https://twitter.com/zevross/status/1403394816558383105).
* Update jQuery from 3.5.0 to 3.5.1. This solve the problem in flexdashboard menu
when the size of viewport is small (like tablets o phones).
* Adding new data `mountains_panorama`.
* Update `pokemon` data.

## Bugs

* Fix url in documentations via `devtools::check_rhub()`.
* Removing `knitr.figure = FALSE` option in `sizingPolicy = htmlwidgets::sizingPolicy`
to fix #703 

## Internal

* Back to previous definition in inst/htmlwidegts/highchart.js. From 
`factory: function(el, width, height) { ... ` to 
`renderValue: function(el, x, instance) { ...` due this way the widget
resize to use the space in flexdashboards (WIP).

# highcharter 0.8.2

## Changes

* Highcharter now uses HighchartsJS 8.1.2
* Adding data helpers to make easy certain type of charts: `data_to_boxplot`,
`data_to_hierarchical` and `data_to_sankey`. Thanks to @wwwjk366.
* Adding `list` to `hchart` supported classes to work with the new data helpers.
* Adding `hc_theme_sparkline_vb`, `hc_theme_hcrt` themes.
* boost module is FALSE by default.
* Modifying `highcharts_demo()`, adding caption and credit texts.
* All vignettes were moved from the package to favor to avoid CRAN check NOTE
and warning. The content was moved to  the new website of the package.
* `htmlwdgtgrid.css` were removed from the yaml of `highcart` `hchart` widgets
to avoid problems with others css frameworks when highcarter is used with shiny.
Now `hw_grid` add `htmlwdgtgrid.css` automatically. 
Additionally `hw_grid` gain new parameters:  1) `add_htmlgrid_css` To add or 
not `htmlgrid.css` and 2) `browsable` -set as TRUE the default value- so now
there is no need to use htmltools::browsable #622 
* Adding new `hc_add_yAxis`. Thanks to `@nordicgit70`.
* Added option to switch to `rjson::toJSON` for better plotting performance.
To use execute `options(highcharter.rjon =TRUE)`. See #613.  Thanks to `@nordicgit70`.

## Bugs

* Removing deprecated messages by dplyr #633 #637 thanks to @hdrab127.

## Deprecated

* `hc_add_dependency_fa`, `fa_icon`, `fa_icon_mark`, please use fontawesome 
package https://github.com/rstudio/fontawesome. See examples in the new
website.
* `hciconarray`, please use now `type = "item"`
* `hcspark`, please use `hc_theme_sparkline`
* `hctreeemaps`, `hctreeemaps2`, please use `data_to_hierarchical`.

# highcharter 0.8.1

## Changes

* Highcharter now uses HighchartsJS 8 (8.1.0).
* Highcharter now uses jquery v3.5.0; previously used is v1.11.1
* Updates deprecated dplyr functions (@hdrab127, #637)
* Fix warnings for numeric vectors with multiple classes (@nuno-agostinho, #635)

# highcharter 0.7.2

## Changes

* Highcharter now uses HighchartsJS 7 (7.2.0) thanks to Daniel Possenriede (#552).

# highcharter 0.7.1

## Changes

* Adding `hc_theme_bloom` based on Bloomberg Graphics.
* Removed shortcut functions: `hcts`, `hcbar`, `hcpie`, `hchist`, `hcdensity`.
* Removing whisker package dependency (#415).
* Bullet chart is supported. Added `bullet.js` module to `highchart.yalm` (#482).
* Add parameter `quiet` to `download_map_data`. Thanks to @DavidBreuer (#450).

# highcharter 0.7.0 

## Changes

* `highchart` function don't load plugins as default. Now there is `hc_add_plugin` to load as required (#258). 
* Fontawesome is not loaded as default. Now there is a `hc_add_depency_fa` function helper to load as required (#257). 

## New Features

* Highcharter now uses HighchartsJS 7 (7.0.1)
* `divBackgroundImage` works with themes (#278).
* New function `hctreemap2` (#110). 
* New function `hc_responsive` to configure responsive features(#305). 
* New function `tooltip_chart` to create minicharts in tooltips (#343). 
* New function `hc_boost` function to configure boost module options `module/boost.js` (#382).
* New function `hchart_` which uses  standar evaluation (#170).
* New function `hcaes_string` (#248). 
* New function `hcparcord`. Inspired **and copy** from http://rpubs.com/hadley/97970 (#167). 
* New functions  `hc_add_series.lm` and `hc_add_series.loess` (#271). 
* New function/theme Super Heroes (#286).
* New function/theme `hc_theme_ggplot2` to honoring one of the best packages (#260). 
* Added multicolor plugin (#251). 
* Added regression plugin (#262). 

## Bug Fixes

* Adding `encoding = "UTF-8"` in `download_map_data` to read characters properly (#359).
* Fixed `Error in mutate_impl` in `hcboxplot` (#323). 
* Fixed `export_hc(..., as = "is")` does not format javascript correctly (#398). 
* Added the MIME type to show fonts correctly (#308). 
* Fixed vignettes titles #244).
* Fixed bug due conflict between highcharts v5 and draggable-points plugin (#273). 
* `maxSize` uses the default highchartsJS value (#272). 
* `hchart.data.frame` and `hc_add_series.data.frame` forces to be data frame to avoid problems
with the data.table class (#263). 
* Fixed bug in `hc_add_series_df` when the data frame comes with a column named "series" (#241). 
* `hchart` don't override/change default highchartsJS options (#302). 

## Api Changes

* Remove deprecated `list.parse` functions (#259). 
* `hc_exported` was reworked (#247). 

# highcharter 0.5.0 

## Breaking changes

 * `hchart.data.frame` now gains a new `mapping` argument  using `hcaes` function to 
 define the aesthetics. After `hchart(df, "line", x = xvar, yvar, group = othervar)` 
 now: `hchart(df, "line", hcaes(x = xvar, yvar, color = othervar), ...)` and therefore
 `...` are used like other highcharter functions for give highcharts arguments 
 to the series. See _charting data frames_ vignette.
 
## New Funcionalities

 * `hc_add_series` is a generic generic function (#213). 
 * New `hcmap` function to chart maps (#218). And use remote sources (#215).
 * New _charting data frames_ vignette (http://rpubs.com/jbkunst/230276) (#220). 
 * New _charting maps_ vignette (https://jkunst.com/highcharter/articles/maps.html) (#218).
 * `debug` as an option instead of argument. Example `options(highcharter.debug = TRUE)` (#216).
 * Upgrade to highcharts V5 (#154) (#208). 
 * Added helpers & shortcuts for tooltip: sort and table (#206).
 * Added export-csv plugin to export chart data to CSV, XLS, HTML or JS array (#178). 
 * Added Grouped Categories plugin (#172) (#193). 
 * Added Tooltip delay plugin  (#181). 
 * Added `is.highchart` according with _Best practices_ in http://adv-r.had.co.nz/S3.html (#179). 
 * New themes:  `theme_firefox` (#191), `theme_tufte` (#190). `hc_theme_elementary` (#184). 
 * `hchart.data.frame` doesn't override the color if the column var have a hexadecimal color
   format (#148).
 * Added `hc_size` function to change width and height (#146). 
 * Add more data for nice examples: vaccines, weather radials, pkmn (#145). 

## Changes

 * renaming `hcwaffle` to hciconarray. The `hcwaffle` do not make a waffle!  (#242). 
 * removing colorize_vector function (#237). 
 * `viridisLite` moved from imports to suggests (#236). 

## Bug fixes

 * Fix map using `mapbubble` (#209). 
 * `hc_add_series_map` don't remove additional data (#188) (#189).
 * `hc_annotations` accept multiple arguments (#171).
 * Adding specific version of tibble (#159).
 * `hchart.data.frame` allow change stops in `hc_colorAxis` (#147). 
 

## Others

 * Remove underscore as dependencies (#214) (#210). 

# highcharter 0.4.0

## New Funcionalities

 * Include `elementId` to createWidget. Add the `hc_elementId()` to modify
 this paramter after the creation of the highchart object (#140).
 * `hchart` support data frames a la `ggplot2::qplot` (#136).
 * `hchart` support Principal Components objects `princomp` and `prcomp` 
 charting a biplot. Thanks to @nuno-agostinho  (#128 #123).
 * `hchart`support matrix objects charting a heatmap (`hchart.matrix`) (#86).
 * `hchart` support phylo objects (#64).
 * New `hcboxplot`, `hcwaffle`, `hcbar`, `hcpie`, `hchist`, `hcdensity`, 
 `hcts` function to get quick some style of charts. Thanks to @nuno-agostinho.
 `hc_add_series_density` implementation  (#99 #70).
 * New `hc_add_series_bwp` to chart box and whisker plots (#81).
 * New  `hc_add_series_list` to add list of series (#68).
 * New `hc_add_series_df_old` (!!) shortcut of 
 `hc_add_series(data = list.parse3(df))` (#76).
 * Added `hc_theme_sparkline` (#132).
 * Added function to create `dataClasses` and `stops` arguments in
 `hc_colorAxis` (#120).
 * Validate length of data = 1 and apply the `list` function  (#119 #188 #65 #71).
 * Added `colorize` function so `colorize_vector` will be deprecate 
 in the next release (#75).
 * Adding `hc_add_series_df` similar to `hchart.data.frame` (#114 #115).
 * Annotation funcionalities `hc_annotations` (#103).
 * Added `cross` as marker symbol (#96).
 * New `hc_yAxis_multiples` to add automatically arbitraty number of y axis
 (#90 #79).
 * New `hc_grid` to create a grid of highchart objects, inspired from 
 `mjs_grid` (#67 #66).
 * Add motion plugin https://github.com/larsac07/Motion-Highcharts-Plugin
 (#62).
 

## Changes

 * Upgrading to highcharts 4.2.4 (#72).
 * Options were separated into `highcharter.global`, `highcharter.lang` and
 `highcharter.chart` instead of having all in one big list (#77 #52).
 * `list.parse2` and `list.parse3` deperacted and renaming to `list_parse2`
 and `list_parse3`.
 * `hc_add_series_scatter` is  more flexible and general (#54 #58) 

## Bug fixes

 * `.hc_get_fonts` now handle fonts names with multiple spaces (#107).
 * `hchart.character` now display empty levels (#101).
 * `datetime_to_timestamp`don't break in certain cases (#97).
 
## Others

 * At startup a message display mentioning that highchart, highstock and
 highmaps are not free for commercial and Governmental use.
 

# highcharter 0.3.1.9999

* Adding underscore dependency (previously was removed. Solves #28)
 
# highcharter 0.3.0

* Igraph support to `hchart` (#61)
* New function `export_hc`. Take a highchart object and 
write a js file with the options (#60).
* New function `tooltip_table`. Helper to create table based
in `tags` from `htmltools`package #59).
* New function `hc_colors`. Function for the `colors` option in 
highcharts api (#57).
* Adding funnel.js and gauge-solid.js to dependency for create
funnel charts and charts like apple watch (#56).
* The `hc_themes_...` functions gains a `...` parameter to
add styles to the current invoked theme (#53).
* More themes: flat, flatdark, smpl, ft (financial times) (#49).
* Don't run error (`\dontrun{}`) to avoid `quantmod` package example
in flags function

# highcharter 0.2.0

* Implemenation of highcharts with boost module `highchart2()` (#43). 
This include highcharts.js, exporting.js and boost-module.js.
* Highstock implementation/support (#10)
* Highmaps implementation/support (#25)
* Adding themes (#35): 538, economist, dotabuff, google, theme null (#19)
* Plugins: Add font awesome integration (#45), fill-pattern (#31),
draggable-points (#28)
* New `hchart` function. Generic function to chart acf, forecast,
ts, stl, xts, ohlc objects (#2) (#27)
* In highmaps prevent scrolling when cursor is over the map (#38)
* Import %>% (#15) 
* Heigth scale in the container in rstudio IDE (#14)
* Avoid duplicate css calls (#6)
* Add uscountygeojson, usgeojson, worldgeojson, unemployment data

# highcharter 0.1.0

* Data: city temp. favorite bars, favorite pies.
* Shortcuts to plot scatters, bar, pies, treemaps and time series
* Adding theme and options HC funcionalities

