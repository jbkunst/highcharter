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

## Autogenerate `highcharts-api.R`

Run `dev/generate-highcharts-api.R`. Make sure you have an example in
the `dev/examples-api/` folder for each function.
