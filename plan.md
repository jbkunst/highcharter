# Highcharter simplification plan

The next review on `feat/highcharts-bundle` is **7, legacy chart defaults and map cleanup**.

## Remaining work

### 7. Imports, defaults and internal helpers

- [ ] Review legacy VML/canvas settings, language defaults and the unused `joindf` assignment in maps.
- [ ] Review the callers of `fix_1_length_data()` and `.join_hc_opts()` for inlining. Check whether the GeoJSON methods can share an implementation.
- [ ] Match a literal `.js` suffix in `export_hc()` and remove the internal `random_id()` from the pkgdown index.

### 8. Public API and optional dependencies

- [ ] Check external uses of `hcparcords()` before deciding whether to deprecate it. Verify a replacement recipe for parallel coordinates with colors and constant columns.
- [ ] Compare the optional `rjson` path with the default serializer. Measure serialization time and compare the handling of missing rows and list columns before deciding whether to retain that path and its direct use of `vctrs`.

### 9. Findings from the function review

- [ ] Check histogram labels with unequal bin widths, the borders and placeholder options in matrix heatmaps, and the S3 registration for the literal class `tibble`.
- [ ] Compare outputs before simplifying `datetime_to_timestamp()`, `hex_to_rgba()`, `is.highchart()`, density series and map-name normalization.

## Completed

| Item | Result on the branch |
| --- | --- |
| 1. Shiny proxies and events | The 12 proxy sends share `send_proxy_message()`. Four loops use `seq_along()`, so empty selections send zero messages. Shiny reports point clicks automatically and distinguishes explicit point and series events. The [Shiny gallery](vignettes/shiny-gallery.Rmd) has five examples built against the branch's webR package, including the draggable equalizer. |
| 2. Time series and forecasts | `hchart.mts()` handles both panel layouts. Multivariate forecasts reuse the single-series predictions and intervals, share a legend entry per confidence level and use the same time index for each prediction and its band. |
| 3. Annotations, heatmaps and options | X-13 outliers and PCA loadings share `data_to_annotation_labels()`. Single annotations go through `hc_add_annotations()`. Mapped heatmaps use the same coordinate rules on both axes. Highcharts options in `...` require names, and collection setters still accept whole objects by position. |
| 4. Data transformations | Hierarchy nodes have unique IDs and use their original group columns to find their parent. Boxplots compute statistics once per group and align outliers with their box. Sankey counts valid adjacent links, with unique IDs and distinct quantile cuts. |
| 5. Survival curves | Curves, confidence bands and censoring times come from the same survival summary for each stratum and prediction profile. |
| 6.1. Fonts | The 15 theme families ship with their Latin WOFF2 subsets. The widget checks the final options once for additional families and respects `google_fonts = FALSE`. [Font maintenance](dev/readme.md#maintain-theme-presets) |
| 6.2. Charts in tooltips | `tooltip_chart()` shares JavaScript serialization with `export_hc()`. Each tooltip renders its own chart when a formatter is reused across widgets. [Examples](vignettes/showcase.Rmd#charts-inside-tooltips) |
| 7.1. Imports | Removed six redundant imports and moved the declarations for `left_join()` and `select()` to `hchart.igraph()`, which uses both. |
| 7.2. Default palette | The default theme defines the ten series colors once. Its colors also initialize the independent `highcharter.color_palette` option used by `data_to_hierarchical()`. |

The package also dropped `assertthat`, the global-variable declarations and `hc_rm_series()`. Both list parsing formats remain available, and `list_parse2()` delegates validation to `list_parse()`. See the [breaking changes](NEWS.md#breaking-changes) for the series migration.

## Decisions to retain

- Keep the `lm` and `loess` series methods for adding fits and bands to an existing chart.
- Keep `hc_elementId()`, `export_hc()`, `create_axis()`, `hc_size()`, `hc_maps()`, `get_data_from_map()`, `hcaes_string()`, `as_hcaes()`, `.merge_options()`, `.hc_axis_options()`, `hchart_pca()`, the generated setters and the Stock Tools constructors.
- Retain the deprecated `hc_yAxis_multiples()` alias for this release. The demo, color helpers and `tooltip_table()` also have distinct uses.

## Release checks

- [ ] Listen to the charts with a screen reader to complement the completed keyboard navigation and automated accessibility checks.
- [ ] Resolve the reverse-dependency migrations. Removed theme constructors affect highdir, RKorAPClient and UnalR. AovBay references the previously removed `hcboxplot()`. [Migration guide](NEWS.md#migration-guide)
