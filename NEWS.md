# highcharter (development version)

* Icons and pictograms restores the original R/Python scatter and food counts,
  colors and symbols, using embedded SVGs instead of PNG conversion. The original
  Datalegreya graph lettering returns to the homepage and navbar. The navbar
  omits the rpackage suffix and keeps the accessible package-name label.
* Explore charts uses the titles Chart types, Maps, Stock charts and Stock Tools,
  and Showcase. The chart-types vignette replaces series-gallery, with redirects
  preserving the previous URLs.
  The Extensions and examples section includes a new Multiple axes vignette,
  moving the four-panel example out of the Highcharts API guide.
  Vignette R chunks follow the shared Air formatting. The navbar links to the
  package repository on GitHub and removes the Twitter icon.
  Website examples consistently use the base R pipe.
  Icons and pictograms has its own article alongside Drilldown, with image
  markers, tooltip icons and item symbols; the old Fontawesome URL redirects to it.
* Histograms created by `hchart()` use square corners by default. A series-level
  `borderRadius` can still customize them. The hchart article removes the point-list
  and companion fitted-model examples to focus on its supported R objects.
* The `hchart()` examples list supported methods with `methods(hchart)`.
  The `hcmap()` help uses a concise title and a descriptive map-collection link.
* The homepage introduces the shared Highcharts bundle and installation,
  with standard CRAN/GitHub installation commands and direct links to
  examples and reference pages through relative links. Datalegreya returns
  to the navbar brand and homepage title; the homepage header rule is removed.
* The homepage uses a full-width 2-by-2 chart grid with four synchronized states,
  ordered as scatter, exports, map and pie. Its South America focus connects the same
  countries and indicators across panels, with quantitative income, longevity
  and trade-balance maps, shared export tooltips and crisis markers. South America
  is emphasized for one state before returning to the world. The final scatter
  compares exports and imports per person on logarithmic axes, changing both
  variables. A versioned World Bank snapshot covers 179 economies in 2024,
  including Russia; R can refresh the data. Pies compare export and population shares
  before opening into a semicircular donut. The R source uses the hcrt theme
  and native Highcharts updates; project links and single-column prose follow
  the grid.
  Transitions retain points and paths for continuous changes of size, position,
  fill and stacking, and wait for fonts before starting playback. The loop
  and Restart animate back to the first state.
  Longer map color bars display explicit numeric labels. The scatter uses
  plain regional country labels and a stable plot box with continuous marker
  geometry when returning to its initial variables.
  Island economies classified as open ocean in the map are assigned to their
  continents so all four panels include the same cohort.
  The initial scene renders without entrance animation or reinitialization,
  and settles its native chart sizing before playback. Source and coverage
  details remain in the developer documentation instead of the grid footer.
  Shared export tooltips use the package's HTML table helper.
  The second export view stacks areas to 100% with percentage labels and
  tooltips. The line view labels the highest series at the 2008 crisis and
  COVID-19 points, separated from the curves by a 24-pixel offset, without
  vertical reference lines in any export view.
  Export series retain every region's color in all four states.
  A series label identifies South America in the third export view.
  Panel descriptions use native Highcharts captions and update with each state.
  Captions use smaller italic text aligned to the bottom right, and the grid omits
  the shared narrative below the charts.
  The scatter supplies a native regional legend at the top left; the external
  legend is removed. Scatter and export plots keep matching margins, and the
  export time axis is labeled Years.
  Playback controls leave space below the charts and map credits.
  The homepage omits the introductory chart recipe beneath Where to start.
* The hcrt theme uses the built-in three-dot export menu icon.
* Language examples compare dates and export-data menus across eight locales.
  They use a shared chart factory, compact layouts and horizontal date labels.
  Simulated Stock candles start at the current date and compare translated OHLC
  tooltips and compact numeric labels on a logarithmic axis.
  French, Norwegian Bokmål and Simplified Chinese use official Highcharts packs;
  Japanese and Korean controls use explicitly identified AI-generated translations.
* Circle-only presets preserve rectangular heatmap cells. The website restores
  the colorful shared-data gallery, the JavaScript-to-R walkthrough and Pokémon
  treemap drilldown, adds constructor examples and a tabbed theme collection,
  and gives the article menu more vertical space.
  Credits in the hcrt theme use the same IBM Plex Sans font as the chart body.
* Website pages have descriptive titles, working source and documentation links,
  and complete favicon assets, including when hosted under `/highcharter/`.
* Forecast charts distinguish observed values, forecasts and their prediction
  intervals in legends and tooltips, including when a custom series name is supplied.
* The hcrt and smpl presets use circular markers consistently across series.
* The website restores an inline chart-types gallery and international map
  examples, adds a Shinylive app, and aligns chart and article typography.
* `hcmap()` accepts an already loaded GeoJSON list without downloading map data.
  Network charts preserve the current theme while hiding their coordinate axes.

* The series gallery article builds correctly when knitr extracts its shared
  examples for the website.

* Charts fill the available widget width and height in the Viewer and standalone
  browser, including after resizing. Percentage-height containers no longer leave
  the chart at Highcharts' 400-pixel fallback height.

* The website groups articles by task. The chart-types gallery includes
  polar charts and pictograms. The Highcharts API guide includes Tom Bishop's
  legend walkthrough; marker and tooltip recipes live in the chart-types article.
  The Motion example now
  runs with local data in the modules and plugins guide. The five former
  article URLs redirect to their new locations.
* The Motion plugin uses native array iteration with the bundled Highcharts.

* `hc_xAxis()`, `hc_yAxis()` and `hc_zAxis()` now accept one or several
  axis definitions. Replace `hc_xAxis_multiples()` and `hc_zAxis_multiples()`
  with the corresponding axis function. `hc_yAxis_multiples()` remains a
  deprecated alias. Replace successive `hc_add_yAxis()` calls with a single
  `hc_yAxis()` call. Use `create_axis()` to calculate relative panel heights.


* PCA charts now scale each component separately and label axes with the
  percentage of variance explained. Points are shown by default. Use
  `loadings = TRUE` for variable arrows and `label = TRUE` for observation names.
* `hchart(stats::decompose(x))` displays the observed series, seasonality, trend
  and remainder in four panels. Series with frequencies outside the annual,
  quarterly and monthly calendars use their numeric time index.

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

* X-range series accept `Date` and `POSIXt` columns for both interval ends
  (`x` and `x2`).

* `hcaes()` and `hcaes_string()` evaluate expressions in the environment
  where the mapping was created. Computed axes show the expression as their
  title. Date and date-time mappings use millisecond timestamps. Grouped
  data-frame charts build point lists using row indices.
* Data-frame charts can inherit the chart type or receive empty data.
  Point colors retain supplied hex values alongside missing values, and
  factor colors handle unused levels.

* The `fast` argument for data-frame series has been removed. Omit it in
  `hchart()` and `hc_add_series()`. Their point data stay editable as R lists
  until the widget is serialized.

* Heatmaps of `dist` objects now respect the matrix display options
  `label` and `showInLegend`.

* Matrix heatmaps now use matrix positions directly, including when labels
  repeat or cells contain missing values. highcharter no longer requires tidyr.

* highcharter uses base R for date checks, model predictions, row conversion
  and option merging. Charts of `lm` and `loess` fits now include the fitted
  curve and its two-standard-error band.
* `xts` and `rjson` are optional. Charting a regular `xts` series only needs
  `xts`; OHLC prices also use `quantmod`. The optional JSON serializer is
  requested only when `options(highcharter.rjson = TRUE)` is set.
* `download_map_data()` uses R's configured download method by default.

* Ten new option wrappers cover accessibility, map views, time zones, data
  imports, empty charts, SVG definitions, sonification, navigation, Stock Tools
  and Gantt connectors. Each has a runnable example in its help page.

* The classic Highcharts themes use the 12.6.0 palettes and legend backgrounds.
  Dark presets have more legible axis labels. Monokai now uses four distinct
  series colors. The Bloom preset places its value axis on the right, and
  sparkline presets hide their legends by default.

* The chalk, handdrawn and sandsignika presets embed their original backgrounds
  for offline use. The Carbon preset draws horizontal and vertical gridlines
  and uses circular point markers across series.
* Theme presets now use `hc_theme("ft")` and live in individual YAML files.
  `hc_themes()` lists the collection. `hc_set_theme()` selects a preset or
  a custom theme for subsequent charts. See `vignette("themes", package = "highcharter")`.
* This release replaces the per-preset constructors with one public constructor.
  The collection keeps `tufte` as its single Tufte preset. The theme vignette
  shows how to recreate the former `tufte2` bar style. This release refreshes
  `ft` and `economist` and adds `carbon`, `cloudscape` and `bslib`.
  Cloudscape uses the AWS chart palette and Open Sans, with circular markers
  and gridlines on both axes. The bslib preset inherits Bootstrap colors and the base font.
* `hc_set_language("es")` sets the language for new charts in the current R
  process. Use `hc_set_language("en")` to switch to English.
  `hc_language()` returns the corresponding options list.
  Spanish, Portuguese and French include translated controls. Regional tags select
  the browser's date and number formats. The default English short weekdays now
  start on Sunday, matching Highcharts' weekday index.
* Charts, Stock, Maps and Gantt share one JavaScript bundle. Accessibility is included
  by default, including keyboard navigation (#755).
* The bundle now includes the official chart types and common feature modules. A new
  `highchartstock()` widget adds Stock Tools, advanced annotations and technical indicators.
  Third-party Motion, Regression, Grouped Categories and Draggable Legend plugins remain optional.
* Highcharts updates now run entirely from `dev/highcharts-bundle`; the build generates
  both bundles and synchronizes widget YAML versions.
* `hcpxy_set_extremes()` controls an x-axis range from Shiny. `hcpxy_set_data()`
  can now target a series by ID, which is safer when Stock indicators change series order.
* Widgets with reflow enabled now follow changes in their container dimensions.
* The chart gallery includes a weighted arc diagram example (#829).

## Migration guide

| Previous call | Current call |
| --- | --- |
| `hc_xAxis_multiples()`, `hc_yAxis_multiples()`, `hc_zAxis_multiples()` | Pass the same list of axes to `hc_xAxis()`, `hc_yAxis()` or `hc_zAxis()`. The Y alias emits a deprecation warning. |
| Repeated `hc_add_yAxis()` | Collect the axes in order, then call `hc_yAxis(axes)`. |
| `hc_theme_google()` and other preset constructors | Use `hc_theme("google")`, or `hc_set_theme("google")` for a session default. |
| `hcaes_()` | Use `hcaes_string()`. |
| `highchartzero()` and its Shiny bindings | Use `highchart()`, `highchartOutput()` and `renderHighchart()`. |
| `fast = TRUE` in a data-frame chart | Omit the argument. Point data are R lists. |

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

## Changes

* Highcharter now uses HighchartsJS 12.6.0.

## Breaking changes

* Removed `hc_labels()` in favor of `hc_annotations()`. This follows the Highcharts API change where the top-level `labels` option was removed. Users should migrate custom chart labels to annotations.

## Package requirements

* Updated `Depends` to require R 4.1.0 or later (`R (>= 4.1.0)`).

## Bugs

* Fix `download_map_data` to prevent 403 Forbidden errors when fetching data.
* Wrapped examples making network calls in `\dontrun{}` (`get_data_from_map` and `hc_mapNavigation`) to fix CRAN Package Check 403 errors.
* Renamed internal helper function `hchart.pca` to `hchart_pca` to resolve an unregistered S3 method mismatch NOTE.

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

