# Working on highcharter

Follow the [mAI principles](https://github.com/jbkunst/mai-principles).

- Start with the smallest end-to-end example. Reuse the R helpers, htmlwidgets and the bundled Highcharts modules before introducing another dependency.
- For questions and reviews, inspect the relevant code and recommend one concrete approach with its main trade-off. Implement when requested. Keep commits, pushes and releases within the scope the maintainer has authorized.
- Keep code readable. Explain changes to the maintenance workflow in the developer README and user-visible behavior in NEWS.
- Match validation to the change. Run an R example for an R helper. For rendering, keyboard navigation or resize, also exercise the output in a browser. For an issue, try its reproducible example and report what was observed.

## Highcharts updates

Use the [maintainer command](dev/readme.md#update-highcharts) from the repository root.
Edit the module selection in `dev/highcharts-bundle/entry.js` and regenerate the compiled JavaScript.
The [bundle guide](dev/highcharts-bundle/README.md) covers the build and the mixed-widget grid.
