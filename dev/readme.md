# Development

The staged cleanup of dependencies, the R API, articles, themes and pkgdown is
tracked in the [simplification plan](simplification-plan.md).

## Test R changes

Run the affected tests from the repository root, for example:

```r
testthat::test_local(filter = "hchart")
```

`.Rbuildignore` excludes `tests/` from the source tarball. Run the source-tree
tests alongside package checks. For a change to optional dependencies, repeat
the affected examples in a fresh R session with those packages absent.

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
keep a source URL in a comment for brand adaptations. A variant can use
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
to compare charts. For the Bootstrap integration, use the Shiny example
in the vignette and toggle the color mode.

## Maintain language presets

`hc_set_language()` delegates to `options(highcharter.lang = hc_language(...))`.
Widgets capture the current setting at construction, so changing or restoring
it before rendering preserves the language of each existing widget.
The generator already excludes `lang`. Spanish and Portuguese strings live in
`inst/lang/`. The French pack is the upstream
[`fr-FR.json` for 12.6.0](https://github.com/highcharts/highcharts/blob/v12.6.0/i18n/highcharts/fr-FR.json).
Keep its format placeholders intact when refreshing it for a bundle upgrade.
English text comes from the bundle. Regional dates and number separators use
`lang.locale` unless the caller provides explicit overrides.

Run `testthat::test_local(filter = "language")`. With the current package
installed, run `Rscript tests/browser/language.R /tmp/language.html` and open
the file. A passing page sets `document.body.dataset.languageTest` to `"passed"`.
It checks two Stock charts after a range change. On a bundle upgrade, recheck
the five global language reads and the shared Stock button defaults handled
in `highcharter-widget.js`.

## Autogenerate `highcharts-api.R`

Run `dev/generate-highcharts-api.R`. Make sure you have an example in
the `dev/examples-api/` folder for each function.
