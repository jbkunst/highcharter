# Highcharter simplification plan

The function review on `feat/highcharts-bundle` is complete. The
[screen-reader check](#release-checks) remains on the release checklist.

## Completed

| Item | Result on the branch |
|----|----|
| 1\. Shiny proxies and events | The 12 proxy sends share `send_proxy_message()`. Four loops use [`seq_along()`](https://rdrr.io/r/base/seq.html), so empty selections send zero messages. Shiny reports point clicks automatically and distinguishes explicit point and series events. The [Shiny gallery](https://jkunst.com/highcharter/vignettes/shiny-gallery.Rmd) has five examples built against the branch’s webR package, including the draggable equalizer. |
| 2\. Time series and forecasts | `hchart.mts()` handles both panel layouts. Multivariate forecasts reuse the single-series predictions and intervals, share a legend entry per confidence level and use the same time index for each prediction and its band. |
| 3\. Annotations, heatmaps and options | X-13 outliers and PCA loadings share [`data_to_annotation_labels()`](https://jkunst.com/highcharter/reference/data_to_annotation_labels.md). Single annotations go through [`hc_add_annotations()`](https://jkunst.com/highcharter/reference/hc_add_annotation.md). Mapped heatmaps use the same coordinate rules on both axes. Highcharts options in `...` require names, and collection setters still accept whole objects by position. |
| 4\. Data transformations | Hierarchy nodes have unique IDs and use their original group columns to find their parent. Boxplots compute statistics once per group and align outliers with their box. Sankey counts valid adjacent links, with unique IDs and distinct quantile cuts. |
| 5\. Survival curves | Curves, confidence bands and censoring times come from the same survival summary for each stratum and prediction profile. |
| 6.1. Fonts | The 15 theme families ship with their Latin WOFF2 subsets. Each widget includes its selected families. Supply other fonts explicitly with [`sass::font_google()`](https://rstudio.github.io/sass/reference/font_face.html). [Font maintenance](https://jkunst.com/highcharter/dev/readme.html#maintain-theme-presets) |
| 6.2. Charts in tooltips | [`tooltip_chart()`](https://jkunst.com/highcharter/reference/tooltip_chart.md) shares JavaScript serialization with [`export_hc()`](https://jkunst.com/highcharter/reference/export_hc.md). Each tooltip renders its own chart when a formatter is reused across widgets. [Examples](https://jkunst.com/highcharter/vignettes/showcase.Rmd#charts-inside-tooltips) |
| 7.1. Imports | Removed six redundant imports and moved the declarations for `left_join()` and `select()` to [`hchart.igraph()`](https://jkunst.com/highcharter/reference/hchart.igraph.md), which uses both. |
| 7.2. Default palette | The default theme defines the ten series colors once. Treemaps and sunbursts use the active chart palette for first-level groups. Use `data_to_hierarchical(..., colors = ...)` for fixed colors. |
| 7.3. Legacy defaults and map joins | Removed the unused VML and canvas URLs from widget defaults and the unused `joindf` assignment from [`hc_add_series_map()`](https://jkunst.com/highcharter/reference/hc_add_series_map.md). |
| 7.4. Language and global options | New sessions use `hc_set_language("en")` and the bundle’s UTC default. The widget reads language and optional global settings directly, preserving user choices. Removed `.join_hc_opts()`. |
| 7.5. Single numeric points | The common series-list path wraps a single numeric value in a point array. Removed `fix_1_length_data()`. |
| 7.6. GeoJSON methods | [`hchart()`](https://jkunst.com/highcharter/reference/hchart.md) and [`hc_add_series()`](https://jkunst.com/highcharter/reference/hc_add_series.md) share one method for `geo_list` and `geo_json`. Mixed collections draw one layer per geometry family. Supply `type` to select a single family. |
| 7.7. Export filenames and reference index | [`export_hc()`](https://jkunst.com/highcharter/reference/export_hc.md) recognizes literal JavaScript extensions using base R. The pkgdown index lists public color and data helpers. |
| 8.1. Parallel coordinates | Removed `hcparcords()`. Use [`data_to_parallel_coordinates()`](https://jkunst.com/highcharter/reference/data_to_parallel_coordinates.md) with native parallel axes. The [data helpers article](https://jkunst.com/highcharter/vignettes/data-helpers.Rmd) shows the migration and all five public helpers. |
| 8.2. Widget serialization | All chart constructors use `yyjsonr`. Removed the `highcharter.rjson` switch, its dependency and the missing-row filter. See the [benchmark](#widget-serialization-benchmark). |
| 9\. Function review | Histograms use real bin limits and widths. Matrix heatmaps use a visible color axis and the bundle’s border default. Tibbles use the data-frame method. Simplified timestamps, RGBA colors, density series and map-name normalization. [`is.highchart()`](https://jkunst.com/highcharter/reference/is.highchart.md) recognizes the two widget classes. |
| 10\. Final helper review | Models and forecasts use base R to generate linked series IDs without consuming random numbers. Color stops are built directly as position/color pairs. Data-frame series validate and add options in one place. GeoJSON and TopoJSON share a property extraction step using base R and `bind_rows()`. Kept `zoo` for calendar time series. |
| 11\. Example data | The map articles use the installed Robinson map and a World Bank income and population snapshot. The same daily ERA5 table powers the monthly demo and the Santiago radial. The showcase contains the HIMYM inputs, stars and WHO/UNICEF coverage, and the data helpers article annotates the Tour de France route. |
| 12\. Package options | Removed the verbose and debug switches and their R and browser traces. External map loading is selected per call with `hcmap(download_map_data = ...)`. |

The package also dropped `assertthat`, the global-variable declarations
and `hc_rm_series()`. Both list parsing formats remain available, and
[`list_parse2()`](https://jkunst.com/highcharter/reference/list_parse.md)
delegates validation to
[`list_parse()`](https://jkunst.com/highcharter/reference/list_parse.md).
See the [breaking
changes](https://jkunst.com/highcharter/NEWS.html#breaking-changes) for
the series migration.

## Widget serialization benchmark

Median milliseconds from constructing the widget through writing its
JSON, across ten paired runs after warm-up. Both columns use the same
inputs and their decoded payloads agree, including the missing
observations. The current writer includes the conversions for named
options and UTC timestamps. Browser rendering and HTML file output are
outside these timings.

| Widget | Previous htmlwidgets default (jsonlite) | Current highcharter (yyjsonr) |
|----|---:|---:|
| 100 x/y points | 22.5 | 8.1 |
| 10,000 values in a numeric vector | 3.6 | 1.6 |
| 10,000 x/y points | 1,635 | 312 |
| 10,000 x/y points with a missing y | 1,559 | 348 |
| 1,000 points with nested metadata | 367 | 67 |
| Three points with missing metadata | 6.8 | 5.8 |
| Packaged Chile map | 1,013 | 152 |

The [reproducible
benchmark](https://jkunst.com/highcharter/dev/sandbox/benchmark-serializers.R)
also reports the preparation and encoding times separately. This run
used R 4.5.0, htmlwidgets 1.6.4, jsonlite 2.0.0 and yyjsonr 0.1.22 on
Linux.

## Decisions to retain

- Keep the `lm` and `loess` series methods for adding fits and bands to
  an existing chart.
- Keep
  [`hc_elementId()`](https://jkunst.com/highcharter/reference/hc_elementId.md),
  [`export_hc()`](https://jkunst.com/highcharter/reference/export_hc.md),
  [`create_axis()`](https://jkunst.com/highcharter/reference/create_axis.md),
  [`hc_size()`](https://jkunst.com/highcharter/reference/hc_size.md),
  [`hc_maps()`](https://jkunst.com/highcharter/reference/hc_maps.md),
  [`get_data_from_map()`](https://jkunst.com/highcharter/reference/get_data_from_map.md),
  [`hcaes_string()`](https://jkunst.com/highcharter/reference/hcaes_string.md),
  `as_hcaes()`, `.merge_options()`, `.hc_axis_options()`,
  `hchart_pca()`, the generated setters and the Stock Tools
  constructors.
- Retain the deprecated
  [`hc_yAxis_multiples()`](https://jkunst.com/highcharter/reference/hc_yAxis_multiples.md)
  alias for this release. The demo, color helpers and
  [`tooltip_table()`](https://jkunst.com/highcharter/reference/tooltip_table.md)
  also have distinct uses.

## Release checks

Listen to the charts with a screen reader to complement the completed
keyboard navigation and automated accessibility checks.

## After the merge to `main`

Recheck the latest CRAN and development versions of the affected
packages. Where a migration is still needed, consider offering the
maintainer a focused pull request. [Migration
guide](https://jkunst.com/highcharter/NEWS.html#migration-guide)

| Package reviewed | What to revisit |
|----|----|
| RKorAPClient 1.5.1 | Its plotting helpers passed all 241 expectations we ran, including theme compatibility. The `frequency_curves` Shiny app still calls `hc_theme_hcrt()` when `idsThemeR` is unavailable. |
| highdir 0.6.0 and UnalR 1.0.2 | Migrate calls to removed theme constructors, including `hc_theme_smpl()` in highdir and `hc_theme_flat()` in UnalR. |
| AovBay 0.1.0 and xplorerr 0.2.0 | Migrate the boxplots in their Shiny apps from `hcboxplot()`. |
| vistime 1.3.0 | The widget works. Update the vignette example that relies on highcharter exporting `%>%`. |
| cTRAP 1.30.0 and psichomics 1.38.1 | Both import `%>%` from highcharter and already depend on dplyr. psichomics also declares an unused `fa_icon_mark` import. Their maintainer was notified on November 20, 2026. Recheck both namespaces before submission. |
