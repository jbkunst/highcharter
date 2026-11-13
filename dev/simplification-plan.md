# Highcharter simplification plan

Last updated: 2026-11-13. Working branch: `feat/highcharts-bundle`.

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

### 2. Required R dependencies — next

| Slice | Current use | Next change to verify |
| --- | --- | --- |
| 2a. `xts` / `quantmod` | `xts` is imported via an unused `is.xts`. `quantmod` is already suggested, but `hc_add_series.xts()` calls it on every input. | Keep both S3 entry points. Propose `xts` in Suggests with an explicit namespace load for restored objects. Use `quantmod` only for financial inputs. |
| 2b. `lubridate` | Four runtime `is.Date()` calls. | Verify a base class check on Date, POSIXct and numeric input. Audit article usage separately. |
| 2c. `rjson` | Alternative widget serializer behind an opt-in setting. | Verify default and opt-in output, including missing values, before changing its dependency status. |
| 2d. `broom` | The model methods expect `.se.fit` from `augment()`. | Reproduce the problem for `lm` and `loess`, validate fitted values and bounds, then decide dependency status. |
| 2e. `rlist` | Data conversion and option merging share this dependency. | Capture row shapes and nested merge results before evaluating replacement. |

**2a acceptance cases.** Use three local dates. A one-column input produces
three date/value pairs in a Stock chart. Two ordinary columns produce two
named series of three points each, preserving timestamp order and missing
values. A single instrument with open, high, low, close and optional volume
produces three five-value points in financial order. Cover both public entry
points, a custom name, explicit `type = "ohlc"` and a restored object in a
fresh R session. Run ordinary inputs with `quantmod` absent. Verify that
highcharter can load and draw a non-xts chart with both packages absent.
Replace the live `getFX()` test with these deterministic checks.

**Decision before changing financial dispatch.** At the baseline, three dates
and two ordinary columns produce one series with six points. More importantly,
`A.Open, A.High, B.Low, B.Close` is classified as one candle named A.
Two complete OHLC instruments can yield a single nine-value point per date.
Proposed rule: recognize one unambiguous instrument, preserve OHLCV handling,
and report ambiguous OHLC layouts with a message to select one instrument.
Confirm this treatment of mixed tickers before implementation. When ordinary
columns expand into several series, a scalar series ID must remain unambiguous
for Shiny proxies.

One commit per dependency slice. Run its examples and tests from the source
tree as `.Rbuildignore` excludes `tests`. Record the behavior with each newly
optional dependency absent. Record a retained Import and its reason when the
compatibility evidence supports keeping it.

### 3. Public R API and helpers

Review one candidate at a time. Record its references in R, help/examples,
articles, tests, Shiny and knitr before proposing removal. Classify each as:

- core public API;
- useful convenience helper;
- compatibility alias to deprecate;
- internal implementation detail;
- unused or broken function to remove.

Review these concrete candidates first:

- `hc_add_yAxis()`, `hc_yAxis_multiples()`, `create_axis()` and the generated
  `hc_yAxis()` API: keep one clear way to define one or several axes.
- `get_hc_series_from_df()` is documented and internal. Audit its callers
  separately from the public export count.
- `hcaes_()` after migrating internal calls to `hcaes_string()`.
- `highchartzero()` only after checking its Shiny and knitr use cases.
- Specialized `hc_add_series.*` and `hchart.*` methods: keep methods backed by a
  real class/use case and tests; retire duplicate or broken conversions.
- Deprecated functions still exported or listed by pkgdown.
- Helpers that only wrap a single list assignment without improving validation
  or readability.

Fix correctness independently of removal decisions. In particular, correct and
test the column-wise scaling in `hchart.prcomp()` and `hchart.princomp()`.

Definition of done: before/after export counts, lifecycle annotations, migration
examples, and no silent removal of public behavior.

### 4. Highcharts API generation and compatibility

The current `dev/generate-highcharts-api.R` scrapes the live Highcharts website,
skips several option groups manually, writes R code, documents, builds and
installs the package in one run. Split those responsibilities.

- Pin the Highcharts version used to inspect the API.
- First compare one option group against the pinned version and render its
  existing R example. Expand the generator after this round trip works.
- Generate a machine-readable diff: added, removed and renamed top-level options.
- Keep hand-written helpers separate from generated wrappers.
- Do not overwrite working files until the generated result validates.
- Give each retained generated wrapper one small local example.
- Review new APIs such as `mapView`, navigation, accessibility, sonification and
  Stock Tools instead of excluding them automatically.
- Compare generated wrappers with the Highcharts 12.6 API before deciding which
  new functions deserve exports.

Definition of done: a reproducible generator, an API diff artifact and no manual
copy step from `dev/highcharts-api.R` to `R/highcharts-api.R`.

### 5. Official chart coverage and vignette structure

Start with the shipped bundle's registered series and the existing gallery,
article sources and `dev/examples-charts/`. Map one family first. Reuse its
examples across the gallery and articles. Record missing series once in a
small coverage table with:

- chart or feature name;
- family;
- official Highcharts demo/API link;
- canonical R example;
- vignette location;
- bundle requirement;
- network requirement;
- validation status.

The target is one R example for every official series type supported by the
bundle, not a copy of every cosmetic variation on the Highcharts demo site.
Feature examples should be added only when they teach a distinct behavior.

Suggested article families:

1. Fundamentals: line, area, column, bar, scatter, pie and ranges.
2. Statistical and distribution charts: histogram, bell curve, pareto,
   boxplot and error bars.
3. Hierarchies, networks and flows: treemap, sunburst, treegraph, sankey,
   dependency wheel, organization and network graph.
4. Scientific and field charts: heatmap, contour, vector, wind barb, surfaces
   and dense/boosted data.
5. Maps and geographic data.
6. Stock and financial charts.
7. Specialized visual forms: gauges, funnels, pictorial, word cloud, timeline,
   X-range and Gantt.
8. Interaction: drilldown, annotations, responsive behavior and Shiny proxies.
9. Accessibility.

Avoid repeating the same chart in several articles. Link to its canonical
example instead.

Deliver in small slices: the first family, the accessibility article, the
Maps article, the Stock/Stock Tools article, then each remaining family's
coverage gaps. The upstream [Highcharts documentation skills](https://github.com/highcharts/highcharts-skills/tree/main/skills)
provide focused references for Stock, Maps and accessibility. Their main
branch tracks upstream master. Verify options and demos against the pinned
bundle version.

#### Accessibility article

Create a dedicated accessibility vignette instead of distributing this subject
across unrelated examples.

- Explain that the accessibility module is included in the base bundle.
- Start with a minimal chart that works with keyboard navigation.
- Cover chart title, subtitle, caption, axis titles, series names and meaningful
  point descriptions.
- Show `accessibility`, `description`, `linkedDescription`, landmark verbosity
  and custom screen-reader text.
- Document keyboard order, focus indicators, sonification where appropriate and
  the exporting/data-table alternatives.
- Include contrast, color-independent encodings and readable tooltip/data-label
  guidance.
- Respect `prefers-reduced-motion` and show how to disable non-essential
  animation.
- Include examples for Chart, Maps and Stock without repeating their main
  articles.
- Test the examples with keyboard-only navigation, a browser accessibility tree,
  responsive resize and at least one screen reader before publication.

Definition of done: the vignette has a keyboard-verifiable minimal example, no
critical automated accessibility findings and explicit manual test notes.

#### Maps article

- Separate local GeoJSON, map collection downloads and tiled web maps.
- Cover `mapView`, projections, joins, map navigation and responsive layout.
- Add one example each for map, mapline, mappoint/mapbubble, flowmap,
  geoheatmap and tiled web map.
- Mark examples that need remote tiles or data and provide an offline default.
- Reproduce and test the example for issue #838 before closing it.

#### Stock article

- Explain `highchart(type = "stock")` versus `highchartstock()`.
- Cover one-column and multi-column `xts`, OHLC/candlestick, flags, navigator,
  range selector, indicators and Stock Tools.
- Include `hcpxy_set_data(id = ...)` and `hcpxy_set_extremes()` in a minimal
  Shiny example.
- Avoid live market-data downloads in the canonical examples.

Definition of done: the manifest has no duplicate canonical examples, every
registered series is covered or explicitly excluded, and every article renders
without accidental network access.

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

### 8. pkgdown and the home page

This is pkgdown, not pagedown. Consolidate the current root configuration with
the legacy `pkgdown/` scripts and generated files so there is one build path.

- Remove the badge wall from the home page.
- Restore the useful idea from commits `06155574` and `315bd8d5`: a compact grid
  of representative charts generated from `pkgdown/index-examples.R`.
- Replace the old heavy examples (including very large random samples) with
  small deterministic datasets.
- Prefer native Highcharts transitions or the existing optional Motion plugin
  over adding D3 solely for the landing-page animation.
- Consider one animated hero chart and a smaller map further down the page.
- Respect `prefers-reduced-motion`, keyboard navigation and mobile layout.
- Set a page-weight budget and avoid downloading every optional dependency on
  the home page.
- Remove obsolete duplicated pkgdown scripts/assets only after the new build is
  reproducible.

Definition of done: one documented pkgdown command, no duplicated source for the
index, a responsive home page and browser checks for animation, keyboard and
reduced-motion behavior.

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

### 10. Final validation and migration notes

- Run package checks with optional dependencies both installed and absent.
  Run the source-tree tests explicitly in addition to checking the tarball.
- Run the canonical gallery in a real browser, including keyboard navigation,
  resize and mixed widgets.
- Add a small Shiny proxy browser test.
- Run reverse-dependency checks before removals.
- Prepare a breaking-change and deprecation table in NEWS for maintainer review.
- Record final metrics: exports, Imports, installed size, bundle size, article
  count and page weight.
