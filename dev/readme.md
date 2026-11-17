# Development

This directory contains the scripts, canonical examples and experiments used
to develop and maintain highcharter. It is excluded from the source package.
Run its maintenance scripts from the repository root unless a guide says
otherwise. Package implementation lives in `R/` and `inst/`, automated tests
in `tests/`, and website articles in `vignettes/`.

## Directory guide

| Directory | Purpose |
| --- | --- |
| `R/` | The bundle gallery builder, `test-highcharts-bundle.R`, shared by the website build and local browser review. |
| `examples-api/` | One runnable example per Highcharts option. roxygen reads these for help pages, and the API generator validates them. |
| `examples-charts/` | Examples of individual chart types, including shared gallery examples. `data/` holds local input data; `modules/` holds specialized series examples. |
| `examples-helpers/` | Worked examples of R helpers, currently stacked panels with `create_axis()`. |
| `examples-modules-plugins/` | Additional module and interaction examples, currently draggable points. |
| `highcharts-bundle/` | The pinned npm manifests, module selection, build and update scripts. See its [bundle guide](highcharts-bundle/README.md). `preview/` and `node_modules/` are generated locally and ignored by Git. |
| `issues/` | Reproducible examples for individual GitHub issues. Some older examples require optional packages or network access. |
| `sandbox/` | Exploratory scripts, not an automated test suite. `transitions/` contains the offline animated chart prototypes and their data; see its [README](sandbox/transitions/README.md). |
| `shiny/` | Small Shiny applications exported with Shinylive for the website. |
| `stackoverflow/` | Examples associated with Stack Overflow questions, named by question ID. |

At this level, `build-site.R` builds the website,
`build-shinylive.R` exports the browser app,
`generate-highcharts-api.R` regenerates the R option API, and
`set-dev-options.R` enables interactive debugging options and a theme.
This README documents their workflows and the release conventions.

## Format R code

Use Air for R code, with the root `air.toml` as the shared configuration:

```sh
air format .
air format --check .
```

The configuration uses two spaces, an 80-column limit and persistent line
breaks. Keep an explicit line break after `|>` when laying out chart pipelines.
Air does not format the code inside roxygen comments; keep those examples
readable manually and regenerate their Rd files with `devtools::document()`.

Positron's Air extension includes the executable. If `air` is not on the
terminal PATH, enable its **Air: Add Executable To Terminal Path** setting and
open a new terminal, or install the CLI following the
[official instructions](https://posit-dev.github.io/air/cli.html).

Do not format `R/highcharts-api.R` directly: the API generator owns it.
Generated website output, npm dependencies and `preview/` artifacts are excluded.
The unfinished `dev/sandbox/highmaps6_hcmap2.R` prototype is also excluded because
its existing syntax is invalid. Revisit that exclusion if the experiment is repaired.
After formatting canonical examples in `dev/examples-api/`, regenerate the
package documentation so the help pages display the formatted examples.

## Open release follow-up

The simplification review left two release checks unresolved:

- Perform a manual screen-reader listening review. Keyboard navigation and
  automated accessibility checks were covered, but listening was not.
- Resolve the reverse-dependency migrations recorded in the
  [NEWS migration guide](../NEWS.md#migration-guide), particularly the removed
  theme constructors used by highdir, RKorAPClient and UnalR. AovBay also
  references the previously removed `hcboxplot()` helper.

## Build the website

Run `Rscript dev/build-site.R` from the repository root with the website
dependencies installed. The script builds the home example and the series
gallery locally, then renders the site with pkgdown. The README supplies the
home text. Generated gallery files belong in the site output.

In an R session at the repository root:

```r
pkgdown::check_pkgdown()
source("dev/build-site.R")
```

The script separates seven steps with cli headings. Comments in each block
explain the inputs, outputs and why the order matters:

1. Read `_pkgdown.yml` and resolve the site output directory (normally `docs/`).
2. Clean the previous generated site and initialize its template assets.
3. Load this checkout with pkgload and disable Google Fonts requests in widgets.
4. Generate `home-gallery.html`, the synchronized four-chart homepage grid.
5. Generate the bundle validation gallery and export the Shiny browser app.
6. Render the homepage, function reference, articles and NEWS through pkgdown,
   which also generates the sitemap and search index. Install the checkout into
   pkgdown's temporary library so article subprocesses use the current R code
   and theme files rather than the package in the user's library.
   Unload the gallery's package first so Windows permits installation.
7. Remove `AGENTS.html`, its LLM Markdown copy and its sitemap entry, then
   rebuild search with pkgdown.

pkgdown's documented [home-page behavior](https://pkgdown.r-lib.org/reference/build_home.html)
renders additional Markdown files in the repository root and `.github/`,
including `AGENTS.md`. Step 7 is a temporary workaround for
[pkgdown #2959](https://github.com/r-lib/pkgdown/issues/2959), which requests
configurable file exclusions. Replace it when pkgdown supports this directly.
Both local and GitHub Actions builds use this script, so the same cleanup runs
before deployment. A build that fails before cleanup must not be deployed.

The script rebuilds generated output; it does not deploy it. Review the local
site with `pkgdown::preview_site()` so search also runs through a local server.

Source links currently point to `feat/highcharts-bundle` in `_pkgdown.yml` and
the root README, because these articles and bundle files are not in the default
branch yet. Switch them to `HEAD` when that branch contains the published sources.

Extra root Markdown pages need a level-one heading for pkgdown to extract their
page title. Generate favicon assets with `pkgdown::build_favicons(overwrite = TRUE)`;
keep manifest icon paths relative so deployment under `/highcharter/` works.
The analytics initializer lives in `pkgdown/extra.js`, which pkgdown links from
every page with the correct relative path. This avoids pkgdown turning a missing
inline `src` into `/NA` on 404.

Article sidebars use Bootstrap TOC's documented `$scope` option in
`pkgdown/extra.js`. Only article section headings are selected; Highcharts'
screen-reader headings remain accessible without appearing in the sidebar.
The theme collection uses bslib tabs. The shared script reflows visible widgets
on Bootstrap's `shown.bs.tab` event so hidden charts fill their pane when opened.
Static tabbed articles set Shiny's `bootstrapTheme` option to Bootstrap 5 while
rendering and restore it afterward, matching the pkgdown page's Bootstrap version.
The JavaScript/R walkthrough is maintained in `vignettes/highchartsjs-api-basics.Rmd`;
the option-by-option guide remains in `vignettes/highcharts-api.Rmd`.

Organize website articles in the root `_pkgdown.yml`. When merging an
article, move its examples to the destination and add a pkgdown redirect
from the original HTML path to the new page or section.
The bundle validation gallery checks the types registered in the bundled
JavaScript. Its examples live in `dev/R/test-highcharts-bundle.R` and render to
`bundle-gallery.html`, separate from the public chart-types article. The public
chart-types article renders its common-data charts and specialized recipes
inline. `pkgdown/index-examples.R` builds the home iframe from
`dev/sandbox/transitions/grid-sequence.R`: four persistent charts, four shared
times, a common playback control and native Highcharts updates. The source
uses a versioned World Bank WDI snapshot prepared by
`dev/sandbox/transitions/prepare-data.R`, the hcrt theme and highcharter's Google
Fonts loader. The current common year is 2024: 179 economies, including Russia,
with complete merchandise-export histories from 2005. The panel order is
scatter, exports, map and pie. Only the third state focuses on South America across
all four panels; the fourth returns to a global view. Income/longevity and
then trade positions share indicators between scatter and map. The last
scatter uses exports and imports per person on two logarithmic axes, with an
equality line. The map shows the signed goods balance divided by total goods
trade. Export shares and population shares connect the pie
to the history and bubble sizes. Shared export tooltips use `hc_tooltip(table = TRUE)`
with two decimal places and units in aligned table cells.
The second export view uses native percent stacking, a 0–100% axis and
`point.percentage` in the table; raw data remain in nominal US dollars.
The line view labels the highest series point in 2008 and 2020, 24 pixels
above the point. Dashed year guides remain in the other views without duplicate
labels. Export event markers identify the 2008 crisis
and COVID-19; plain country names label Chile and Uruguay in the regional
scatter. Map color bars occupy 76% of their panel width, with explicit numeric
formats. The regional camera fits the bounds of South American economies instead
of relying on a fixed zoom that can crop the north or south.
Sources, units, coverage and refresh instructions live in the
[data README](sandbox/transitions/data/README.md). Builds use local prepared
data without API calls; refresh explicitly with
`options(highcharter.website.refresh_data = TRUE)` before sourcing the grid.
The build also copies the downloadable `home-data.csv` into the site output.
Sources and coverage stay in the data README; the grid has no source footer.
After serving the generated site, run
`Rscript dev/highcharts-bundle/test-home-grid.R http://127.0.0.1:8765`
to check cold initial scatter rendering, the South America focus and shared
HTML-table tooltips in both the homepage iframe and standalone gallery, at
desktop and mobile widths. This optional development check uses chromote.
The older standalone HTML prototypes
remain visual references in `dev/sandbox/transitions/`.
Grid transitions retain their series, point IDs and SVG paths. The executor
updates changed options/data rather than replacing each complete chart.
Equal-sized bubble points form the first scatter view; a persistent streamgraph
series supplies line, area and stacked views by changing fill and stacking.
Native SVG animation interpolates fill colors and opacity, and playback waits
for fonts before starting. Initial series render without entrance animation;
the first scene is not reinitialized by the executor. Once fonts and grid
layout are ready, all four charts run their native sizing pass before the
clock starts. Check initial scatter visibility without clicking a control or
resizing the viewport. Fixed scatter margins keep its plot box stable;
marker geometry is captured before redraw and animated to the target geometry
with Highcharts when either variable changes. This also applies at the loop
boundary. Bubble series explicitly set their circle symbol: Highcharts 12.6
compares user marker options with resolved defaults during updates and would
otherwise recreate markers when refreshing cached tooltip formats.
The same handling applies after interrupted manual transitions. Browser checks should inspect
intermediate geometry, not just the final series type or point count. Also check the fourth-to-first
transition through automatic playback: both scatter axes return to their
initial variables, and the pie, map and export history animate back together.
The return takes two seconds with sine easing; other transitions take 1.4 seconds.
Restart uses the same animated return (instantaneous with reduced motion).
The homepage uses the documented `home.sidebar: false` setting. The scoped
rules in `pkgdown/extra.css` reclaim the template's empty Bootstrap sidebar
column and center the prose below the full-width grid; README project links
preserve access to repository, contribution and author information.
For the separate 16-view single-chart experiment authored in R, run
`dev/sandbox/transitions/pie-sequence.R` from the repository root after loading
this checkout. Its data, chart objects and timed steps live in R;
`pie-sequence.js` executes them through `htmlwidgets::onRender()`. It uses the
`hcrt` theme and highcharter's Google Fonts loader for the actual typefaces.
See the [transition guide](sandbox/transitions/README.md).

When generating LLM text documentation, pkgdown/Pandoc warns that it cannot
fetch the relative homepage and Shinylive iframe URLs. The HTML embeds work
in the served site; their live content is omitted from the text export.

`dev/build-shinylive.R` uses the official Shinylive exporter for the example in
`dev/shiny/site-demo/`. These website-only dependencies are recorded in
`Config/Needs/website`. Initial export and first browser launch require internet.
The browser app uses the highcharter release available in webR, which can lag
behind this branch. Let webR resolve that release's dependencies at launch;
bundling dependencies from the local checkout would miss older imports.

At the end of `source("dev/build-site.R")`, an interactive R session starts
pkgdown's local server and opens the homepage, articles and indexes, NEWS,
authors, license and general documentation pages in the system's external
browser. The block temporarily overrides the IDE's URL handler and restores it
after opening the tabs. It skips individual function
reference pages and redirect aliases. Keep R running while reviewing the tabs.
Non-interactive builds through Rscript or GitHub Actions skip this preview block.
Keep the initial home assets below
650 kB gzip and use the standalone Stock Tools widget only on its own pages.
For the stock proxy browser test, install the current highcharter package, Shiny
and Python Playwright with Chromium, then run `python tests/browser/stock-proxy.py`.
The test also accepts a Chrome executable in `CHROMOTE_CHROME`.

Run `Rscript tests/browser/sizing.R` with chromote and Chrome installed to check
fluid sizing from the source tree. It covers browser and Viewer modes, mixed
widget types, container-only resizing, hidden panels and explicit widget sizes.
The shared renderer measures the widget when Highcharts requests an automatic
size, reusing Highcharts' reflow observer instead of adding another observer.

## Test R changes

Run the affected tests from the repository root, for example:

```r
testthat::test_local(filter = "hchart")
```

`.Rbuildignore` excludes `tests/` from the source tarball. Run the source-tree
tests alongside package checks. For a change to optional dependencies, repeat
the affected examples in a fresh R session with those packages absent.

## Package versioning

Starting with the next release, use `MAJOR.MINOR.REVISION` in `DESCRIPTION`.
Take `MAJOR.MINOR` from the Highcharts JS version bundled in the package.
The first highcharter release on a line uses revision zero. Increment the
revision for each subsequent highcharter release on that line. For example,
the first release under this convention on the `12.6` line is `12.6.0`.
When the bundle moves to `12.7.x` or `13.1.x`, start at `12.7.0` or `13.1.0`,
respectively.

Adopting a Highcharts JS patch is optional. If Highcharts publishes `12.6.1`,
we can keep bundling `12.6.0`. If we adopt the patch, the next highcharter
release still uses the next R revision on the `12.6` line.

For every release in `NEWS.md`, put the highcharter version in the heading
and the exact bundled Highcharts JS version in the next paragraph. Read the
JS version from `devDependencies.highcharts` in
[`package.json`](highcharts-bundle/package.json). Include both even when the
numbers match or the bundle is unchanged.

```markdown
# highcharter 12.6.1

Bundled Highcharts JS: 12.6.0.
```

## Update Highcharts

Run this from the repository root with Node.js and npm installed:

```sh
npm --prefix dev/highcharts-bundle run update -- 12.6.2
```

Pass the exact release you want. The command pins Highcharts in the npm manifests,
builds the base and Stock Tools bundles, copies Stock Tools CSS and icons, and updates
the Highcharts versions in all widget YAML files. To reproduce the committed version,
run `npm ci` and `npm run build` from `dev/highcharts-bundle`. Review the diff and run
the [widget gallery](highcharts-bundle/README.md) against the updated package.

[Motion](https://github.com/larsac07/Motion-Highcharts-Plugin),
[grouped categories](https://github.com/blacklabel/grouped_categories),
[draggable legend](https://github.com/highcharts/draggable-legend) and
[regression](https://github.com/streamlinesocial/highcharts-regression) are third-party plugins.
Their copies in `inst/htmlwidgets/lib/highcharts/plugins/` are maintained independently
of Highcharts and are loaded only when requested. The CSS and highcharter's custom scripts
are also maintained in the repository.

## Maintain theme presets

Each file in `inst/themes/` defines one preset. Its filename is the name
accepted by `hc_theme()`. Use Highcharts option names, quote hex colors and
use the top-level `symbols` array to make ordinary point markers circular.
Setting `plotOptions.series.marker.symbol` would also change heatmap cell shapes.
Keep a source URL in a comment for brand adaptations. A variant can use
`extends: flat` to inherit options from a packaged preset. The sparkline's
tooltip uses `!js` for its Highcharts callback. For a bundled texture,
`divBackgroundImage: !image filename.jpg` embeds the file from
`inst/themes/backgrounds/` in the widget. The chalk and paper images come
from the original amCharts [chalk](https://web.archive.org/web/20140523101521id_/http://www.amcharts.com/inspiration/chalk/bg.jpg)
and [hand-drawn](https://web.archive.org/web/20140523101529id_/http://www.amcharts.com/inspiration/hand-drawn/bg.jpg)
samples. The [sand tile](https://github.com/highcharts/highcharts/blob/v12.6.0/samples/graphics/sand.png)
comes from the Highcharts samples. Only packaged files are read.

When updating a brand preset, cite the upstream chart specification for the
field being changed (for example, the ordered FT line palette). Keep historical
values where the source only provides a general brand palette.

Run `testthat::test_local(filter = "themes")` and render `vignettes/themes.Rmd`
to compare charts. After installing the package, render
`Rscript tests/browser/themes.R /tmp/themes.html` and open the result to check
axis placement for a preset, an explicit override and a neighboring chart.
For the Bootstrap integration, use the Shiny example in the vignette and
toggle the color mode.

## Maintain language presets

`hc_set_language()` delegates to `options(highcharter.lang = hc_language(...))`.
Widgets capture the current setting at construction, so changing or restoring
it before rendering preserves the language of each existing widget.
The help examples share one data set and a local `create_chart()` function, then
create each widget after calling `hc_set_language()`. Titles and captions are
added afterward; an existing widget keeps the language captured at creation.
Their simulated OHLC series starts at `Sys.Date()` and spans several orders of
magnitude on a logarithmic axis, with automatic numeric-symbol labels. The
Japanese and Korean presets use `numericSymbolMagnitude = 10000`; official
language packs are kept unchanged.
The generator already excludes `lang`. Spanish and Portuguese strings live in
`inst/lang/`. The French pack is the upstream
[`fr-FR.json` for 12.6.0](https://github.com/highcharts/highcharts/blob/v12.6.0/i18n/highcharts/fr-FR.json).
Norwegian Bokmål is the unchanged upstream
[`nb-NO.json` for 12.6.0](https://github.com/highcharts/highcharts/blob/v12.6.0/i18n/highcharts/nb-NO.json),
stored as `inst/lang/nb.json`. Keep format placeholders intact when refreshing
official packs for a bundle upgrade. Implementation and the shared example
chart live in `R/language.R`; `man/hc_language.Rd` is generated by roxygen.
English text comes from the bundle. Regional dates and number separators use
`lang.locale` unless the caller provides explicit overrides.

Simplified Chinese is the unchanged upstream
[`zh-CN.json` for 12.6.0](https://github.com/highcharts/highcharts/blob/v12.6.0/i18n/highcharts/zh-CN.json).
`ja.json` and `ko.json` are AI-generated interface translations maintained here,
not official Highcharts language packs or human-reviewed translations. Keep that
provenance in the help page and example captions. Weekday and month names in the
examples come from the browser's `Intl` implementation via locale-aware formats,
not from the AI translations. Traditional Chinese currently falls back to English
controls rather than reusing Simplified Chinese labels.

Run `testthat::test_local(filter = "language")`. With the current package
installed, run `Rscript tests/browser/language.R /tmp/language.html` and open
the file. A passing page sets `document.body.dataset.languageTest` to `"passed"`.
It checks Stock language isolation after a range change, plus date formatting
and export labels in French, Norwegian, Japanese, Chinese and Korean.
On a bundle upgrade, recheck
the five global language reads and the shared Stock button defaults handled
in `highcharter-widget.js`.

## Generate the Highcharts R API

Documentation is generated with the stable CRAN release of roxygen2 (currently
8.1.1). After upgrading it, run `devtools::document()` and review `DESCRIPTION`,
`NAMESPACE` and `man/`. roxygen2 8 records the generator version in
`Config/roxygen2/version` in `DESCRIPTION`, replacing `RoxygenNote`.

From the repository root, run:

```sh
Rscript dev/generate-highcharts-api.R
```

The command uses the Highcharts version pinned in `dev/highcharts-bundle`
and runs `npm ci` there if that version is missing. It requires the package's
R imports, roxygen2 and pkgload. It reads the top-level options from
`highcharts.d.ts`, builds the candidate package documentation, and runs
every `dev/examples-api/<option>.R` against the candidate. Each example must
return a widget that sets that option. Successful runs update
`R/highcharts-api.R`, the API help pages and `NAMESPACE`.

To cover a new upstream option, add a small offline example under its exact
Highcharts name. The command reports missing and obsolete example names on a
version change. Review those names against the upstream changelog for renames.
Most wrappers call `.hc_opt()`. Colors and tooltips also preserve their R
arguments. Use `hc_set_language()` for the session language and
`options(highcharter.global = list(buttonTheme = list(...)))` for global
button defaults. `hc_time()` sets the time zone on an individual chart.
