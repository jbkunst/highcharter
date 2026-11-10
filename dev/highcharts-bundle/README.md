# Build the Highcharts bundle

From this directory, run:

```sh
npm ci
npm run build
```

Commit the generated `inst/htmlwidgets/lib/highcharter-bundle.js` with the build sources.
Installing or using the R package does not require Node.js.

`entry.js` selects the official Highcharts modules. Stock, Maps and Gantt extend the same
Highcharts instance as the standard charts. Keep Boost last among the module imports.
The htmlwidgets dependency lists load highcharter's theme reset and third-party plugins
separately.

For a Highcharts release upgrade, use the [maintainer command](../readme.md#update-highcharts)
from the repository root to update the bundle and standalone modules together.

To exercise the installed R package, run `Rscript grid.R` from this directory and open
`preview/index.html`. The grid combines Chart, Stock, Maps, 3D, derived series and an
optional pattern-fill module. Use Tab and the arrow keys on the first chart to check
keyboard navigation.
