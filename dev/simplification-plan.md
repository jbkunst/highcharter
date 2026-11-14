# Highcharter simplification plan

Last updated: 2026-11-14. Working branch: `feat/highcharts-bundle`.

## Goal

Make highcharter smaller and easier to maintain without losing the behavior that
people actually use. Prefer one clear public path for each task, one canonical
example for each concept, and evidence before making a breaking change.

Baseline at `d003b990` (five commits after `pre-highcharts-bundle`):

- 121 `export()` entries in NAMESPACE.
- 26 theme presets. The 27 names starting with `hc_theme_` include the
  composition helper `hc_theme_merge()`.
- 18 packages in `Imports` and 30 in `Suggests`.
- 16 tracked `vignettes/*.Rmd` articles. They are excluded from the R package
  build and rendered by pkgdown.
- Two overlapping pkgdown workflows: the root `README.md`/`_pkgdown.yml` and the
  older sources and scripts under `pkgdown/`.

Update the affected counts when a stage changes them.

## Working principles

- Complete one stage at a time, with its own reviewable commits.
- Preserve behavior first; deprecate before removing public functions.
- Do not add a package dependency when base R or an existing helper is enough.
- Keep user examples offline and deterministic unless the network is the subject
  of the example.
- Maintain one source of truth for documentation and generated code.
- Validate R transformations in R and rendered behavior in a browser.
- Keep historical attribution separate from current maintainer/governance roles.

## Roadmap

### 1. Highcharts runtime foundation — done

- [x] Generate one reproducible bundle for Chart, Stock, Maps and Gantt.
- [x] Include accessibility and the official series used by highcharter.
- [x] Keep third-party plugins optional.
- [x] Add the separate `highchartstock()` widget with Stock Tools.
- [x] Replace the manual Highcharts download workflow.
- [x] Synchronize widget YAML versions during the build.
- [x] Simplify and share the htmlwidgets renderer.
- [x] Review proxies, add `hcpxy_set_extremes()` and make
  `hcpxy_set_data()` safe by series ID.

### 2. Required R dependencies — done

Direct Imports fell from 18 to 12. The final axis cleanup removed the last use of methods. The row filter uses vctrs directly, which
already ships as a dependency of dplyr. With the package versions in the R 4.5.0
validation library, the recursive required set fell from 54 to 43 external
packages (Depends, Imports and LinkingTo, excluding base and recommended
packages). Neither the R package `curl` nor `RCurl` is required for the base
installation. The optional `quantmod` imports `curl`. Map downloads use R's
configured download method.

| Slice | Current status |
| --- | --- |
| 2a. `xts` / `quantmod` | Both optional. A saved ordinary xts series loads in a fresh session with only xts installed. OHLC inputs request quantmod. Each ordinary column produces one series. |
| 2b. `lubridate` | Removed. The four class checks and the Stock, Gantt and X-range examples use base R. Historical data-preparation scripts can still use lubridate. |
| 2c. `rjson` | Optional. Default JSON preserves missing values. The opt-in path keeps the original serializer and row filtering. |
| 2d. `broom` | Removed. The lm and loess methods use model predictions and standard errors, sorted together with the first predictor. |
| 2e. `rlist` | Removed. Base R handles row lists and option merging, including nested and NULL overrides. This also removes XML and data.table from the required set. |
| 2f. `tidyr` | Removed. Matrix heatmaps use their positions directly. Boxplots, hierarchies, parallel coordinates and optional JSON filtering run without tidyr or cpp11. |

**2a acceptance cases.** Use three local dates. A one-column input produces
three date/value pairs in a Stock chart. Two ordinary columns produce two
named series of three points each, preserving timestamp order and missing
values. A single instrument with open, high, low, close and optional volume
produces three five-value points in financial order. Cover both public entry
points, a custom name, explicit `type = "ohlc"` and a restored object in a
fresh R session. Run ordinary inputs with `quantmod` absent. Verify that
highcharter can load and draw a non-xts chart with both packages absent.
Replace the live `getFX()` test with these deterministic checks.

**Financial dispatch.** A single instrument with all four OHLC fields produces
candles. Mixed or repeated instruments report an error asking the caller to
select one. Multiple ordinary columns use their column names and accept one
distinct series ID per column for Shiny proxies.

One commit per dependency slice. Run its examples and tests from the source
tree as `.Rbuildignore` excludes `tests`. Record the behavior with each newly
optional dependency absent. Record a retained Import and its reason when the
compatibility evidence supports keeping it.

### 3. Public R API and helpers — implemented

The baseline had 121 exports, the branch tip before this working-tree pass
had 109, and the candidate has 102. See the [migration table](../NEWS.md#migration-guide).

- `hc_xAxis()`, `hc_yAxis()` and `hc_zAxis()` accept an ordered collection.
  Named options update the first axis and preserve the others. `create_axis()`
  builds stacked panels from relative heights. The API article demonstrates
  independent X and Y axes in a four-panel scatter plot.
- Removed the additive Y helper and the X/Z multiple-axis wrappers. The
  remaining Y alias warns and delegates to `hc_yAxis()` because AovBay uses it.
  Parallel coordinates remain a public convenience function.
- Removed `hcaes_()`, the zero widget and its Shiny bindings. Data-frame
  charts, added series and proxies share the same point conversion.
- PCA scales each component separately, with optional loading arrows.
  Decomposed time series use the existing panel layout. The igraph method
  keeps its fixed layout and separate edge, node and label series.

### 4. Highcharts API generation and compatibility — done

The title pilot and the [full R generator](readme.md#generate-the-highcharts-r-api)
use the pinned Highcharts 12.6.0 declarations. The 37 top-level options map to
35 chart wrappers and two session settings, `lang` and `global`. The generator
reports missing or obsolete example names as JSON when the upstream interface
changes. Check the upstream changelog before treating a removed/added pair as
a rename. The 35 examples run against the candidate package before publication
of its R source, exports and help. The browser review covered Core, Maps, Gantt
and Stock, including the optional Stock Tools toolbar.

### 5. Official chart coverage and articles — implemented

The [family index](../vignettes/series-gallery.Rmd) covers all 71 series types
registered by the shared 12.6.0 bundle. Each card links to the Highcharts API.
The gallery checks the browser registry and the series actually constructed.
Examples use local data. Contour requires WebGPU. The tiled map includes a
local sample tile. Stock Tools adds indicators outside the shared registry.

- [Maps](../vignettes/maps.Rmd) covers local boundaries and joins, categorized
  values, projected points, zoom and navigation. Remote tiles and map collection
  downloads are explicitly identified. For #838, the official CDN returned HTTP
  403 in this environment. The browser-side `hcmap()` example with the map
  supplied locally and the local map series both rendered 212 features, zoom
  10 and two navigation buttons.
- [Stock](../vignettes/stock.Rmd) uses the xts sample OHLC data for lines,
  candles, OHLC, flags, a moving average, the navigator and Stock Tools. The
  standalone Shiny example updates the data by ID, then adjusts the time range.
- [Accessibility](../vignettes/accessibility.Rmd) covers keyboard navigation,
  descriptions, the table and animation. Chromium exposed the point names and
  values in its accessibility tree. Arrow keys moved between points. axe-core
  found no WCAG A/AA violations in the example widget. A manual screen-reader
  listening review remains a release check.

### 6. Languages and locale options — done

- `hc_set_language()` sets the default for new widgets in the current R process
  and invisibly returns the previous option for restoration with `options()`.
  `hc_language()` returns the preset as a plain list.
  Current public export count: 123 (121 at the baseline).
- The public examples use one code per language: `en`, `es`, `pt`, `fr`.
  Regional tags share the same dictionary.
- Spanish and Portuguese cover the common Shiny controls, exporting, basic
  accessibility and Stock ranges. French uses the upstream 12.6.0 pack.
  Untranslated labels use Highcharts' English defaults. Regional variants
  retain their own date and number formatting through the browser.
- Source-tree tests cover presets, fallback, nested overrides and scope.
  Browser checks cover mixed languages, export menus, dates, numbers and Stock.
  The [maintenance guide](readme.md#maintain-language-presets) records the
  upstream pack and the global language reads to recheck on a bundle upgrade.

### 7. Themes — done

The approved collection uses one YAML file per preset, a common constructor
and a session setter. The 28 presets include 25 historical names plus
Carbon, Cloudscape and bslib. The gallery documents the former `tufte2` style as a
customization of `tufte`. FT and Economist were refreshed. The historical constructors
were replaced by `hc_theme(preset)`. The [themes vignette](../vignettes/themes.Rmd) documents
the migration and compares the presets using the same data.

The visual review covered all 28 presets with the bundled Highcharts 12.6.0.

| Presets | Review outcome |
| --- | --- |
| `ft`, `economist`, `carbon`, `cloudscape`, `bslib`, `tufte` | Editorial palettes, design systems, Bootstrap inheritance and the single Tufte preset were covered in the first pass. |
| `darkunica`, `gridlight`, `sandsignika` | Checked the versioned Highcharts settings, including the full color sequences and legend backgrounds. |
| `538`, `bloom`, `db`, `elementary`, `ffx`, `google` | Kept the historical brand palettes. Checked contrast and actual axis placement in the rendered charts. |
| `alone`, `flat`, `flatdark`, `ggplot2`, `hcrt`, `monokai`, `smpl`, `superheroes` | Checked text, grids and series colors against each plotting surface. |
| `chalk`, `handdrawn` | Checked series and labels over their embedded board and paper textures. |
| `null`, `sparkline`, `sparkline_vb` | Checked hidden axes, compact layouts and the white value-box sparkline on a colored surface. |

### 8. pkgdown and the home page — implemented

Run `Rscript dev/build-site.R` to build the home grid, series gallery and site.
The homepage uses four deterministic charts and one shared engine. They display
in one or two columns and have animation disabled. The embedded gallery HTML
and its JavaScript dependencies total about 491 kB gzip; its budget is 650 kB.
Widths of 320, 390, 768 and 1180 px were checked in Chromium. The old generated
asset copies, home page and separate build scripts were removed. The maintenance
guide at the repository root is excluded from the published site and its indexes.

### 9. Contributors and project attribution — done

The November 2026 review matched all 15 contributor entries to work in the
repository, including ideas and examples originally contributed through issues.
[Contributor acknowledgements](../NEWS.md#contributor-acknowledgements) records
each person's name, contribution and supporting project history.

Joshua Kunst is the sole author and maintainer in `Authors@R`. The four
contributors listed there are Nuno Agostinho, Mauricio Vargas, Charlie Joey
Hadley and Marc Kupietz. The release notes preserve the credits for all 15
contributors in the review, including Kamil Slowikowski's ORCID and a
personal thank you to the early highcharter community.

### 10. Final validation and migration notes — checked, release follow-up recorded

Validation on Linux with R 4.5.0 and Highcharts 12.6.0 on 2026-11-14.

| Check | Result |
| --- | --- |
| Source-tree tests | 350 passing expectations, no failures, warnings or skips. |
| Generated API | All 35 examples ran against the candidate. |
| Source tarball | `R CMD check --no-manual` completed with status OK and all 33 Suggests installed. |
| Optional dependencies | A second `R CMD check --no-manual --ignore-vignettes` in the minimal library completed with status OK. Two fresh sessions also checked base charts, axes and the xts path with quantmod absent. |
| Website | All 18 articles and reference pages built through `dev/build-site.R`. |
| Browser | Chromium checked 71 registered types, rendered contour through WebGPU, local tiles, Maps, Stock and the home grid. The four mtcars panels show all eight numbered axes at 320, 390 and 1100 px. |
| Shiny proxy | `tests/browser/stock-proxy.py` checks changed values, exact time extremes and unchanged chart identity. The example redraws the series before setting the Stock range. |
| Accessibility | Keyboard, accessibility tree, reduced motion and axe-core WCAG A/AA checks passed for the dedicated example. Orca could not start because the environment disallowed its D-Bus socket. A manual listening review remains pending. |

The packaged and documented example for each covered series is indexed by
[vignettes/series-gallery.Rmd](../vignettes/series-gallery.Rmd). The
[mtcars API example](../vignettes/highcharts-api.Rmd) sets a width for the small
axis labels so Highcharts does not truncate them inside the pkgdown layout.

#### Reverse dependencies

Inspected the seven CRAN packages with a direct dependency on highcharter and
ran their package checks. Keep the upstream packages' existing failures distinct
from migration issues. The theme constructor removals were explicitly approved
during the theme review.

| Package | Result |
| --- | --- |
| AovBay 0.1.0 | No errors or warnings, three notes. The Y-axis call works through the retained deprecated alias. Its separate call to the previously removed `hcboxplot()` is reported as an unresolved symbol. |
| T2Qv 0.2.0 | Check status OK. |
| ggfootball 0.3.0 | Check status OK. |
| highdir 0.6.0 | Calls removed theme constructors, including `hc_theme_smpl()`. Migrate to `hc_theme("smpl")`. Its accessibility vignette also fails with CRAN highcharter 0.9.5. |
| RKorAPClient 1.5.0 | Calls `hc_theme_google()`. The candidate produced 28 test failures versus one with CRAN highcharter 0.9.5 in the comparison environment. The extra failures include the removed constructor. |
| UnalR 1.0.2 | Examples and tests call removed theme constructors, including `hc_theme_flat()`. Migration is required. |
| shinymrp 0.10.0 | Its example/workflow vignette checks fail on both the candidate and CRAN highcharter 0.9.5. |

#### Candidate metrics

| Measure | Value |
| --- | --- |
| Public exports | 102, compared with 109 before this pass and 121 at the plan baseline |
| Required Imports | 12 |
| Suggested packages | 33 |
| Articles | 18 on the website; the theme vignette ships in the source package |
| Installed package from the built tarball | 5.78 MB, including the rendered theme vignette |
| Shared JavaScript engine | 1,235,368 bytes; 419,649 bytes gzip |
| Optional Stock Tools JavaScript | 228,053 bytes |
| Four-chart home gallery with its initial dependencies | About 491 kB gzip |
| Official series in the gallery | 71 |

The [NEWS migration table](../NEWS.md#migration-guide) lists replacements for
the old axes, themes, zero widget, string mappings and `fast` argument. Complete
the screen-reader review and resolve the recorded reverse-dependency migration
cases before describing the release as fully validated.
