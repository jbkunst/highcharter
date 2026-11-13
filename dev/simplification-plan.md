# Highcharter simplification plan

Last updated: 2026-11-13. Working branch: `feat/highcharts-bundle`.

## Goal

Make highcharter smaller and easier to maintain without losing the behavior that
people actually use. Prefer one clear public path for each task, one canonical
example for each concept, and evidence before making a breaking change.

Current baseline on this branch:

- 121 exported functions.
- 27 exported theme functions.
- 18 packages in `Imports` and 30 in `Suggests`.
- 19 vignettes.
- Two overlapping pkgdown workflows: the root `README.md`/`_pkgdown.yml` and the
  older sources and scripts under `pkgdown/`.

Record these counts again after each simplification stage. A change is not a
simplification if it only moves complexity somewhere less visible.

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

Start with `xts` and `quantmod`, using three minimal examples:

1. One-column `xts`: one time series, no `quantmod` requirement.
2. Multi-column `xts`: one Highcharts series per column, without repeated dates.
3. OHLC: retain the financial behavior and require `quantmod` only here if it is
   genuinely needed.

Then review the other candidates:

- Replace `lubridate` when it is only used for base date-class checks.
- Move `rjson` to `Suggests` or remove the disabled alternative serializer.
- Move `broom` to `Suggests` after repairing or retiring the `lm` and `loess`
  methods.
- Review `rlist` last because it participates in data and option conversion.
- Identify packages used only in examples or vignettes and keep them out of
  `Imports`.

Definition of done: a dependency-use table, passing examples for retained
behavior, package checks with optional packages absent, and a lower `Imports`
count.

### 3. Public R API and helpers

Build an inventory of every export and classify it as:

- core public API;
- useful convenience helper;
- compatibility alias to deprecate;
- internal implementation detail;
- unused or broken function to remove.

Review these concrete candidates first:

- `hc_add_yAxis()`, `hc_yAxis_multiples()`, `create_axis()` and the generated
  `hc_yAxis()` API: keep one clear way to define one or several axes.
- `get_hc_series_from_df()`.
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

Create a small manifest, for example `dev/highcharts-examples.yml`, with:

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

### 6. Languages and locale options

Propose one public entry point rather than one exported function per language.
The preferred direction to evaluate is a language registry such as:

```r
hc_language("es")
hc_language("pt-BR", thousandsSep = ".")
```

Decide whether it returns a `lang` list for
`options(highcharter.lang = ...)`, modifies one chart, or supports both without
hidden global side effects. English remains the default. Start with Spanish,
Portuguese and French; add another language only with a maintainer or reliable
translation source.

Audit the existing English defaults at the same time, including month/day order,
export strings, accessibility strings, numeric separators and locale-aware date
formatting.

Definition of done: one small API, tested fallback to English, chart-local
overrides, and no additional package dependency.

### 7. Themes — proposal required before implementation

There are currently 27 exported theme functions. Do not add more until they are
reviewed as a set.

- Render the same representative charts with every theme.
- Check contrast, accessibility, font/network requirements and compatibility
  with current Highcharts.
- Identify duplicate, obsolete and brand-specific themes.
- Define a small canonical collection: default, light, dark, minimal,
  presentation and sparkline are possible roles, not final names.
- Evaluate a registry/getter so theme discovery does not require dozens of
  exports. Keep old wrappers through a deprecation cycle if the public surface
  changes.
- Add a new theme only when it is visually distinct, accessible and maintained.

Definition of done: an approved proposal with screenshots, a keep/deprecate
table and a migration path. Breaking changes require an explicit maintainer
decision and release note.

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

### 9. Contributors and project attribution

Do not remove a historical contributor from `Authors@R` merely because their
GitHub account is inactive. `ctb` records attribution for shipped work; it is
not a list of current maintainers.

- Verify that every `Authors@R` entry corresponds to an identifiable
  contribution and merge duplicate identities.
- Keep current maintainer roles (`cre`, active maintainers) distinct from `ctb`.
- Move longer acknowledgements and inactive-community thanks to a CONTRIBUTORS
  or acknowledgements section if that makes DESCRIPTION easier to maintain.
- Check current GitHub status only when executing this stage; do not infer it
  from commit age alone.
- Preserve attribution in git history and release notes even if an invalid or
  duplicate DESCRIPTION entry is corrected.

Definition of done: documented criteria, a reviewed mapping from names to
contributions and no loss of legitimate attribution.

### 10. Release and migration pass

- Run package checks with optional dependencies both installed and absent.
- Run the canonical gallery in a real browser, including keyboard navigation,
  resize and mixed widgets.
- Add a small Shiny proxy browser test.
- Run reverse-dependency checks before removals.
- Publish a breaking-change and deprecation table in NEWS.
- Record final metrics: exports, Imports, installed size, bundle size, article
  count and page weight.

## Recommended order

1. Dependencies (`xts`/`quantmod` first).
2. R helpers and public API.
3. API generator and Highcharts compatibility.
4. Official-example manifest and article taxonomy.
5. Maps and Stock article rewrites.
6. Languages.
7. Themes proposal and decision.
8. pkgdown/home page.
9. Contributors and attribution.
10. Final migration and release pass.

The next concrete task is stage 2: implement and test the three `xts`/OHLC
examples, then decide exactly which dependency moves out of `Imports`.
