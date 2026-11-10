# Development

## Update Highcharts

Run this from the repository root, with Node.js, npm and the R packages
`fs` and `jsonlite` installed:

```sh
Rscript dev/download-highcharts-code.R 12.6.2
```

Pass the exact release you want, or omit the version to rebuild from the committed lockfile.
The command installs Highcharts in a temporary directory, builds the bundle, and updates
the npm manifests, standalone official scripts and both widget YAML files. Review the diff
and run the [widget grid](highcharts-bundle/README.md) against the updated package.

[Motion](https://github.com/larsac07/Motion-Highcharts-Plugin),
[grouped categories](https://github.com/blacklabel/grouped_categories),
[draggable legend](https://github.com/highcharts/draggable-legend) and
[regression](https://github.com/streamlinesocial/highcharts-regression) are third-party plugins.
Their copies in `inst/htmlwidgets/lib/highcharts/plugins/` are maintained independently
of Highcharts. The CSS and highcharter's custom scripts are also maintained in the repository.

## Autogenerate `highcharts-api.R`

Run `dev/generate-highcharts-api.R`. Make sure you have an example in
the `dev/examples-api/` folder for each function.
