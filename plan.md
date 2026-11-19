# Highcharter simplification plan

The next review on `feat/highcharts-bundle` is **8, parallel coordinates and optional dependencies**.

## Remaining work

### 8. Public API and optional dependencies

- [ ] Decide whether to retire `hcparcords()`. The GitHub code search found package copies and documentation. A browser check with `iris` confirmed that `list_parse2()`, `hc_add_series_list()` and `parallelCoordinates = TRUE` retain row colors and constant measurements.
- [ ] Compare the optional `rjson` path with the default serializer. Measure serialization time and compare the handling of missing rows and list columns before deciding whether to retain that path and its direct use of `vctrs`.

## Completed

| Item | Result on the branch |
| --- | --- |
| 1. Shiny proxies and events | The 12 proxy sends share `send_proxy_message()`. Four loops use `seq_along()`, so empty selections send zero messages. Shiny reports point clicks automatically and distinguishes explicit point and series events. The [Shiny gallery](vignettes/shiny-gallery.Rmd) has five examples built against the branch's webR package, including the draggable equalizer. |
| 2. Time series and forecasts | `hchart.mts()` handles both panel layouts. Multivariate forecasts reuse the single-series predictions and intervals, share a legend entry per confidence level and use the same time index for each prediction and its band. |
| 3. Annotations, heatmaps and options | X-13 outliers and PCA loadings share `data_to_annotation_labels()`. Single annotations go through `hc_add_annotations()`. Mapped heatmaps use the same coordinate rules on both axes. Highcharts options in `...` require names, and collection setters still accept whole objects by position. |
| 4. Data transformations | Hierarchy nodes have unique IDs and use their original group columns to find their parent. Boxplots compute statistics once per group and align outliers with their box. Sankey counts valid adjacent links, with unique IDs and distinct quantile cuts. |
| 5. Survival curves | Curves, confidence bands and censoring times come from the same survival summary for each stratum and prediction profile. |
| 6.1. Fonts | The 15 theme families ship with their Latin WOFF2 subsets. Each widget includes its selected families. Supply other fonts explicitly with `sass::font_google()`. [Font maintenance](dev/readme.md#maintain-theme-presets) |
| 6.2. Charts in tooltips | `tooltip_chart()` shares JavaScript serialization with `export_hc()`. Each tooltip renders its own chart when a formatter is reused across widgets. [Examples](vignettes/showcase.Rmd#charts-inside-tooltips) |
| 7.1. Imports | Removed six redundant imports and moved the declarations for `left_join()` and `select()` to `hchart.igraph()`, which uses both. |
| 7.2. Default palette | The default theme defines the ten series colors once. Its colors also initialize the independent `highcharter.color_palette` option used by `data_to_hierarchical()`. |
| 7.3. Legacy defaults and map joins | Removed the unused VML and canvas URLs from widget defaults and the unused `joindf` assignment from `hc_add_series_map()`. |
| 7.4. Language and global options | New sessions use `hc_set_language("en")` and the bundle's UTC default. The widget reads language and optional global settings directly, preserving user choices. Removed `.join_hc_opts()`. |
| 7.5. Single numeric points | The common series-list path wraps a single numeric value for both serializers. Removed `fix_1_length_data()`. |
| 7.6. GeoJSON methods | `hchart()` and `hc_add_series()` share one method for `geo_list` and `geo_json`. Mixed collections draw one layer per geometry family. Supply `type` to select a single family. |
| 7.7. Export filenames and reference index | `export_hc()` recognizes literal JavaScript extensions using base R. The pkgdown index omits the internal `random_id()` helper. |
| 9. Function review | Histograms use real bin limits and widths. Matrix heatmaps use a visible color axis and the bundle's border default. Tibbles use the data-frame method. Simplified timestamps, RGBA colors, density series and map-name normalization. `is.highchart()` recognizes the two widget classes. |

The package also dropped `assertthat`, the global-variable declarations and `hc_rm_series()`. Both list parsing formats remain available, and `list_parse2()` delegates validation to `list_parse()`. See the [breaking changes](NEWS.md#breaking-changes) for the series migration.

## Decisions to retain

- Keep the `lm` and `loess` series methods for adding fits and bands to an existing chart.
- Keep `hc_elementId()`, `export_hc()`, `create_axis()`, `hc_size()`, `hc_maps()`, `get_data_from_map()`, `hcaes_string()`, `as_hcaes()`, `.merge_options()`, `.hc_axis_options()`, `hchart_pca()`, the generated setters and the Stock Tools constructors.
- Retain the deprecated `hc_yAxis_multiples()` alias for this release. The demo, color helpers and `tooltip_table()` also have distinct uses.

## Release checks

- [ ] Listen to the charts with a screen reader to complement the completed keyboard navigation and automated accessibility checks.

## After the merge to `main`

- [ ] Recheck the latest CRAN and development versions of the affected packages. Where a migration is still needed, consider offering the maintainer a focused pull request. [Migration guide](NEWS.md#migration-guide)

| Package reviewed | What to revisit |
| --- | --- |
| RKorAPClient 1.5.1 | Its plotting helpers passed all 241 expectations we ran, including theme compatibility. The `frequency_curves` Shiny app still calls `hc_theme_hcrt()` when `idsThemeR` is unavailable. |
| highdir 0.6.0 and UnalR 1.0.2 | Migrate calls to removed theme constructors, including `hc_theme_smpl()` in highdir and `hc_theme_flat()` in UnalR. |
| AovBay 0.1.0 and xplorerr 0.2.0 | Migrate the boxplots in their Shiny apps from `hcboxplot()`. |
| vistime 1.3.0 | The widget works. Update the vignette example that relies on highcharter exporting `%>%`. |
