# Working on highcharter

Follow the [mAI principles](https://github.com/jbkunst/mai-principles).

Read the [development guide](dev/readme.md) when working on maintenance scripts,
examples or the website. It describes each `dev/` directory and the build steps.

- Start with the smallest end-to-end example. Reuse the R helpers, htmlwidgets and the bundled Highcharts modules before introducing another dependency.
- For questions and reviews, inspect the relevant code and recommend one concrete approach with its main trade-off. Implement when requested. Keep commits, pushes and releases within the scope the maintainer has authorized.
- Keep code readable. Explain changes to the maintenance workflow in the developer README and user-visible behavior in NEWS.
- Format R code with Air using the root `air.toml`. Run `air format .` and `air format --check .`; preserve the exclusions for generated files and local artifacts. See the [formatting guide](dev/readme.md#format-r-code).
- Format R code in vignettes with `Rscript dev/format-vignettes.R` and verify it with `Rscript dev/format-vignettes.R --check`.
- Use the base R pipe `|>` in website examples, including the canonical scripts in `dev/examples-charts/` and `dev/examples-helpers/`.
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
