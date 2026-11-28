# Development

This directory contains the scripts, canonical examples and experiments used
to develop and maintain highcharter. It is excluded from the source package.
Run its maintenance scripts from the repository root unless a guide says
otherwise. Package implementation lives in `R/` and `inst/`, automated tests
in `tests/`, and website articles in `vignettes/`.

## Directory guide

| Directory | Purpose |
| --- | --- |
| `R/` | The bundle gallery builder, `build-bundle-gallery.R`, shared by the website build and local browser review. |
| `examples-api/` | One runnable example per Highcharts option. roxygen reads these for help pages, and the API generator validates them. |
| `highcharts-bundle/` | The pinned npm manifests, module selection, build and update scripts. See its [bundle guide](highcharts-bundle/README.md). `preview/` and `node_modules/` are generated locally and ignored by Git. |
| `sandbox/` | The serializer benchmark and the [offline chart transitions](sandbox/transitions/README.md), including their source and data. |

Article scripts are installed from `inst/examples/`. The site-only Shiny apps live in `pkgdown/shiny/`. Installed example inputs live in `inst/extdata/`. Article-only datasets and their sources live in `vignettes/data/`.
`data-raw/maps.R` refreshes the country and custom RDS files in `inst/maps/`.
The refresh uses pinned upstream sources and mapshaper for the Chilean regions.
`data-raw/world_income.R` and `data-raw/city_weather.R` refresh the offline data from the World Bank and Open-Meteo.

At this level, `build-site.R` builds the website,
`build-shinylive.R` exports the browser app,
`format-vignettes.R` formats R chunks in the vignettes with Air,
`generate-highcharts-api.R` regenerates the R option API, and
`set-dev-options.R` sets the theme for interactive development.
Inspect a widget with `str(hc$x)` in R or `Highcharts.charts.filter(Boolean)` in the browser console.
This README documents their workflows and the release conventions.

## Format R code

Use Air for R code, with the root `air.toml` as the shared configuration:

```sh
air format .
air format --check .
Rscript dev/format-vignettes.R
Rscript dev/format-vignettes.R --check
```

The configuration uses two spaces, an 80-column limit and persistent line
breaks. Keep an explicit line break after `|>` when laying out chart pipelines.
Use the base R pipe `|>` throughout website examples, including the articles in
`vignettes/` and the help examples in `dev/examples-api/`.
Across Get started, articles and reference examples, use `package::dataset`
when the package exports the data. Use `data(..., package = "...")` for
non-exported datasets. Omit unused package attachments and one-use aliases.
Prefer `hchart()` for data-frame examples. The Gantt recipe uses
`hchart(df, type = "gantt")`, which selects the native Gantt constructor and
retains its task rows and date axes.
Air does not format the code inside roxygen comments; keep those examples
readable manually and regenerate their Rd files with `devtools::document()`.
The vignette formatter sends each R chunk to Air through its documented
`--stdin-file-path` interface, using the root configuration. It preserves prose,
YAML, chunk headers and non-R code. If Air is outside PATH, set `AIR` to its
executable path before running the script.

Positron's Air extension includes the executable. If `air` is not on the
terminal PATH, enable its **Air: Add Executable To Terminal Path** setting and
open a new terminal, or install the CLI following the
[official instructions](https://posit-dev.github.io/air/cli.html).

Do not format `R/highcharts-api.R` directly: the API generator owns it.
Generated website output, npm dependencies and `preview/` artifacts are excluded.
After formatting canonical examples in `dev/examples-api/`, regenerate the
package documentation so the help pages display the formatted examples.

## Open release follow-up

Track the [release checks in the simplification plan](../plan.md#release-checks).

## Simplification review

The [simplification plan](../plan.md) lists the remaining work in review order,
completed changes and API decisions. Run
`Rscript dev/sandbox/benchmark-serializers.R` from the package root to repeat
the JSON timings and compare the decoded widgets against the htmlwidgets default.

## Build the website

Run `Rscript dev/build-site.R` from the repository root with the website
dependencies installed. The script builds the home example and the series
gallery locally, then renders the site with pkgdown. The README supplies the
home text. Generated gallery files belong in the site output.

Article and homepage prose uses the Latin variable IBM Plex Sans (upright and
italic) in `pkgdown/assets/fonts/`. These are the weight-axis WOFF2 files from
[Fontsource 5.3.0](https://www.npmjs.com/package/@fontsource-variable/ibm-plex-sans/v/5.3.0).
Keep the IBM license beside them. The template names the family and
`pkgdown/extra.css` loads the files directly.

The public homepage focuses on installation, bundle features and getting started.
Keep maintenance instructions in this guide. The navbar brand and homepage title
use Datalegreya fonts served locally from `pkgdown/assets/fonts/`. The homepage
uses Gradient, restored from the repository history; the navbar uses Thin for
a line without area shading, from the upstream `lib/fonts/` directory. The source is
[figs-lab/datalegreya](https://github.com/figs-lab/datalegreya); retain `OFL.txt`
beside the fonts. Other headings keep Alegreya Sans SC. Run `pkgdown::init_site()`
when previewing changes to these assets without rebuilding the entire website.
The shared initializer restores the original Datalegreya graph-encoded lettering
after each font loads. The navbar uses the same graph sequence without the
`{rpackage}` suffix. Accessible labels and the plain-text fallback remain the
package name. On the homepage, `pkgdown/assets/home-hex.svg` places the paper
plane from `man/figures/hexicon.svg` beside the title.

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
5. Generate the bundle validation gallery and export the Shiny gallery.
6. Render the homepage, function reference, articles and NEWS through pkgdown,
   which also generates the sitemap and search index. Install the checkout into
   pkgdown's temporary library so article subprocesses use the current R code
   and theme files rather than the package in the user's library. In CI,
   `setup-r-dependencies` already installs this checkout with `local::.`,
   so the workflow sets `highcharter.pkgdown.install = FALSE` to reuse it.
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

pkgdown reads the GitHub repository from `DESCRIPTION`. Source links use the
current branch in GitHub Actions and `HEAD` for local builds.

Extra root Markdown pages need a level-one heading for pkgdown to extract their
page title. Generate favicon assets with `pkgdown::build_favicons(overwrite = TRUE)`;
keep manifest icon paths relative so deployment under `/highcharter/` works.
The analytics initializer lives in `pkgdown/extra.js`, which pkgdown links from
every page with the correct relative path. This avoids pkgdown turning a missing
inline `src` into `/NA` on 404.

Article sidebars use Bootstrap TOC's documented `$scope` option in
`pkgdown/extra.js`. Only article section headings are selected; Highcharts'
screen-reader headings remain accessible without appearing in the sidebar.
Rebuild only the generated navigation list so pkgdown's "On this page" heading
and its spacing below the navbar remain intact.
The theme collection uses bslib tabs. The shared script reflows visible widgets
on Bootstrap's `shown.bs.tab` event so hidden charts fill their pane when opened.
Static tabbed articles set Shiny's `bootstrapTheme` option to Bootstrap 5 while
rendering and restore it afterward, matching the pkgdown page's Bootstrap version.
The JavaScript/R walkthrough is maintained in `vignettes/highchartsjs-api-basics.Rmd`;
the option-by-option guide remains in `vignettes/highcharts-api.Rmd`.

Organize website articles in the root `_pkgdown.yml`. When merging an
article, move its examples to the destination and add a pkgdown redirect
from the original HTML path to the new page or section.
The Explore charts section uses the titles Chart types, Maps, Stock charts and
Stock Tools, and Showcase. The chart-types article lives in
`vignettes/chart-types.Rmd`; the former `series-gallery.html` URLs redirect to it.
Keep Showcase's established examples first and append new examples at the end.
The hchart and Maps articles share the airport example in
`vignettes/_manchester.Rmd`. Its local background uses the MapLibre GL assets
from the website dependency mapgl. The foreground GeoJSON files and their
sources are in `inst/extdata/`; the background extract is in `vignettes/data/`.
The Extensions and examples section includes `vignettes/multiple-axes.Rmd`,
which plots a sample of diamonds across nine panels with paired axes.
Showcase includes the Font Awesome marker and pictogram examples with folded R code.
Both former article URLs point to that section. Omit build dates and maintainer
bylines from articles; retain the author credit on guest contributions.

pkgdown redirects use the canonical website URL. To review old URLs on a local
server, regenerate redirects with `pkgdown::build_redirects(override =
list(url = "http://127.0.0.1:8765"))`, substituting the active server address.
The next normal website build restores the canonical destination for deployment.
The bundle validation gallery checks the types registered in the bundled
JavaScript. Its examples live in `dev/R/build-bundle-gallery.R` and render to
`bundle-gallery.html`, separate from the public chart-types article. The public
chart-types article renders its common-data charts and specialized recipes
inline. Bars, columns and cylinders share the quantities-by-category data;
keep `low`/`high` fields in the range examples so ordinary columns start at zero.
All four shopping categories have an illustrative session duration for `z`.
Variable pie and packed bubble use a zero size baseline so the smallest
observation remains visible. Network nodes set `marker.radius` explicitly from
team headcounts. The compact three-set Venn recipe lives in
`inst/examples/venn.R` and is reused by the article.
[From data to charts](../vignettes/from-data-to-charts.Rmd) is the
canonical source for the homepage's data preparation, R chart definitions,
theme, captions and four states. Start every homepage chart change there, then
regenerate and review both the article and homepage. Keep its explanation in
sync with changes to playback or layout. The article's folded sections contain
the complete runnable R code, starting from the packaged WDI extract in `inst/extdata/wdi-home.csv.gz`.

`pkgdown/home-gallery.R` defines `build_home_gallery(output_dir)`. It uses
`knitr::purl()` to extract the article's R code. The article renders each sequence with its own
controls. Article players start paused and pressing Play pauses the previous player.
The homepage enables autoplay for its shared four-chart player, subject to the
reader’s reduced-motion preference. Both
use `inst/examples/grid-sequence.js` for playback. Do not add an independent data or chart recipe to the
adapter. Four persistent charts share four times, a common playback control
and native Highcharts updates. They use the hcrt theme and its bundled fonts. The current common year is 2024: 179 economies, including Russia,
with complete merchandise-export histories from 2005. The panel order is
scatter, exports, map and pie. Only the third state focuses on South America in
the scatter, map and pie; exports keep every region's color in all states.
The third export view identifies South America with a native series label.
Each panel's description is a native `hc_caption()`, included in the R chart
and updated through `chart.update()` as the shared state changes. Captions use
small italic text aligned to the bottom right; there is no separate explanatory
text shared by the grid.
The homepage iframe observes the shared `.transition-grid-page` player to match
its full height, including captions and playback controls, at every width.
The scatter's native legend identifies regions at the top left. The scatter and
export chart share fixed margins to align their plotting areas; the export time
axis is labeled Years. No separate HTML legend is generated.
The fourth returns to a global view. Income/longevity and
then trade positions share indicators between scatter and map. The last
scatter uses exports and imports per person on two logarithmic axes, with an
equality line. The map shows the signed goods balance divided by total goods
trade. Export shares and population shares connect the pie
to the history and bubble sizes. Shared export tooltips use `hc_tooltip(table = TRUE)`
with two decimal places and units in aligned table cells.
The second export view uses native percent stacking, a 0–100% axis and
`point.percentage` in the table; raw data remain in nominal US dollars.
The line view labels the highest series point in 2008 and 2020, 24 pixels
above the point, without vertical year guides in any view.
Export event labels identify the 2008 crisis
and COVID-19. The scatter shows country names in its tooltips. Map color bars occupy 76% of their panel width, with explicit numeric
formats. The regional camera fits the bounds of South American economies instead
of relying on a fixed zoom that can crop the north or south.
Sources, units and coverage are documented in the
[data README](sandbox/transitions/data/README.md) and public article. Both
builds use the same versioned WDI extract. The scatter legend toggles the
corresponding continent in the export history and pie through `hc_connect()`.
The adapter writes `home-gallery.html` and `home-data.csv` directly to the chosen directory.
Sources and coverage stay in the data README; the grid has no source footer.
After serving the generated site, run
`Rscript dev/highcharts-bundle/test-home-grid.R http://127.0.0.1:8765`
to check cold initial scatter rendering, the South America focus and shared
HTML-table tooltips in both the homepage iframe and standalone gallery, at
desktop and mobile widths. It also compares the article's initial chart data
with the homepage and exercises the native data-code folding with the keyboard.
This optional development check uses chromote.
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
`hcrt` theme and its bundled fonts.
See the [transition guide](sandbox/transitions/README.md).

When generating LLM text documentation, pkgdown/Pandoc warns that it cannot
fetch the relative homepage and Shinylive iframe URLs. The HTML embeds work
in the served site; their live content is omitted from the text export.

The site-only Shiny apps live in `pkgdown/shiny/`. The Solar cycles app lives in
`inst/examples/theme/app.R` so the installed themes vignette and the gallery
share its source. Each directory holds one ordinary `app.R`. Run an example from the checkout with
`shiny::runApp("pkgdown/shiny/events")` after loading the local package.
Edit that same file to update both the app and the source shown in the article.
The Stock walkthrough also uses the gallery's Stock app.

`dev/build-shinylive.R` exports the apps to `live/<name>/` and shares one
Shinylive runtime and one highcharter archive across them. In GitHub Actions,
`dev-wasm` builds the checkout with the R installation in the webR image.
It disables the image's rig APT repository before installing build dependencies.
The pkgdown job receives its
`highcharter-webR` artifact and passes the path in `HIGHCHARTER_WASM_PACKAGE`.
Pin the webR image in the workflow to the version bundled with the Shinylive
assets in the export script when upgrading either. Pull requests targeting
`main` build the site for verification. Pushes to `main`, published releases
and manual runs on `main` deploy the site to `gh-pages`.

For local previews without a supplied binary, the script installs this checkout
without byte compilation and checks that it contains only portable R code and
browser assets. Both paths load the same archive URL and fetch imports as webR
binaries. The runtime and apps are website build outputs.
Both the first export and the first browser launch require internet access.

At the end of `source("dev/build-site.R")`, an interactive R session starts
pkgdown's local server and opens only the homepage, articles, reference index
and NEWS in the system's external browser. The block temporarily overrides the
IDE's URL handler and restores it after opening the tabs. It skips repository
administration pages (conduct, contribution guidelines and issue/PR templates),
authors, license, individual function reference pages and redirect aliases.
Keep R running while reviewing the tabs.
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

`R CMD check` runs the packaged testthat suite. Run the browser checks from
`tests/browser/` in the checkout. For a change to optional dependencies, repeat
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

Group development and new-release entries under `Breaking changes`,
`New features`, `Changes` and `Bug fixes`, omitting empty groups. Keep migration
instructions in a separate `Migration guide` when needed. Preserve the content
and headings of historical releases.

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

The grouped-categories example sets `xAxis.labels.distance = 0` so Highcharts'
default label distance does not shift manufacturer labels into the group row.
Its numeric position column is only used to place points; the axis has no title.

## Maintain theme presets

Decide whether a new preset's typefaces should work offline. For an offline
family, add its Fontsource slug to [data-raw/fonts.R](../data-raw/fonts.R).
Run `Rscript data-raw/fonts.R` from the repository root to rebuild `inst/fonts/`.
The script downloads the regular (400, upright) Latin WOFF2 face and license
for each selected family from a pinned release and writes a CSS file for each family with
the upstream Unicode range. When the generated assets change, bump the font
dependency version in `R/theme.R`. Keep monospace companions for themes that
use them.

The widget resolves each `fontFamily` when a theme or chart option changes.
A matching packaged family attaches its own directory in `inst/fonts/`.
An explicit `sass::font_google()` provides its CSS family name and HTML
dependency. Other CSS family names and variables use the surrounding page.

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
The help example shows how to set and restore a session default. The
[Modules & plugins article](../vignettes/modules.Rmd#chart-language) compares
localized export controls on the same chart. The Japanese and Korean presets use `numericSymbolMagnitude = 10000`; official
language packs are kept unchanged.
The generator already excludes `lang`. Spanish and Portuguese strings live in
`inst/lang/`. The French pack is the upstream
[`fr-FR.json` for 12.6.0](https://github.com/highcharts/highcharts/blob/v12.6.0/i18n/highcharts/fr-FR.json).
Norwegian Bokmål is the unchanged upstream
[`nb-NO.json` for 12.6.0](https://github.com/highcharts/highcharts/blob/v12.6.0/i18n/highcharts/nb-NO.json),
stored as `inst/lang/nb.json`. Keep format placeholders intact when refreshing
official packs for a bundle upgrade. The implementation and short help
example live in `R/language.R`; `man/hc_language.Rd` is generated by roxygen.
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

Use `highcharts_demo()` for general chart options and override defaults to make
the chart easier to read, compare or explore. Keep each example focused on one
useful improvement, with a short comment explaining its purpose. For specialized
options, use appropriate offline data instead: bundled SPY prices for Stock,
packaged maps for map controls, and explicit tasks for Gantt dependencies.

Most wrappers call `.hc_opt()`. Colors and tooltips also preserve their R
arguments. Use `hc_set_language()` for the session language and
`options(highcharter.global = list(buttonTheme = list(...)))` for global
button defaults. `hc_time()` sets the time zone on an individual chart.
