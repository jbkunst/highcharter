# Working on highcharter

Follow the [mAI principles](https://github.com/jbkunst/mai-principles).

Read the [development guide](dev/readme.md) when working on maintenance scripts,
examples or the website. It describes each `dev/` directory and the build steps.

- Start with the smallest end-to-end example. Reuse the R helpers, htmlwidgets and the bundled Highcharts modules before introducing another dependency.
- For questions and reviews, inspect the relevant code and recommend one concrete approach with its main trade-off. Implement when requested. Keep commits, pushes and releases within the scope the maintainer has authorized.
- Keep code readable. Explain changes to the maintenance workflow in the developer README and user-visible package behavior in NEWS. Keep website layouts, gallery edits and documentation build details out of NEWS.
- Format R code with Air using the root `air.toml`. Run `air format .` and `air format --check .`; preserve the exclusions for generated files and local artifacts. See the [formatting guide](dev/readme.md#format-r-code).
- Format R code in vignettes with `Rscript dev/format-vignettes.R` and verify it with `Rscript dev/format-vignettes.R --check`.
- Use the base R pipe `|>` in website examples, including the canonical scripts in `dev/examples-charts/` and `dev/examples-helpers/`.
- Prefer `hchart(data, type = ..., mapping = ...)` for data-frame examples when
  possible. Use explicit chart construction when the example teaches that API
  or needs series-specific setup.
- Treat `vignettes/from-data-to-charts.Rmd` as the source of truth for the
  homepage grid's data, R chart definitions, captions, themes and states. Start
  every change to the homepage charts in that article, then regenerate and
  review both the article and homepage. Keep its explanation in sync when
  changing playback or layout. The grid adapter extracts the article with
  `knitr::purl()`; do not introduce a second data or chart recipe in `dev/`.
- Before pushing, fetch the remote and inspect incoming commits, outgoing
  commits and local changes so the working branch stays synchronized.
- Match validation to the change. Run an R example for an R helper. For rendering, keyboard navigation or resize, also exercise the output in a browser. For an issue, try its reproducible example and report what was observed.
- Place each new public help topic in the `_pkgdown.yml` section where a user would look for it. Reuse an existing selector when it fits and run `pkgdown::check_pkgdown()` after updating the documentation.

## Licensing

Keep the licensing notice visible when changing the README, package metadata,
R help, or bundled JavaScript. In the README (the pkgdown homepage), keep
`Licensing` immediately after `Where to start`. The README, `DESCRIPTION` and
`?highcharter` must distinguish the MIT-licensed R wrapper from the Highcharts
JavaScript library used to render every chart. Keep the links to Highsoft's
commercial and personal/educational terms in the README and package help.
Preserve upstream copyright and license notices when rebuilding the bundles.

## Highcharts updates

Follow the [package versioning rule and NEWS format](dev/readme.md#package-versioning) when preparing a highcharter release.
Use the [bundle update instructions](dev/readme.md#update-highcharts) when adopting a Highcharts release.
Edit the module selection in `dev/highcharts-bundle/entry.js` and regenerate the compiled JavaScript.
The [bundle guide](dev/highcharts-bundle/README.md) covers the build and the mixed-widget grid.
