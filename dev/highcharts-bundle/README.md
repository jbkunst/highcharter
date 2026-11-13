# Build the Highcharts bundle

From this directory, run:

```sh
npm ci
npm run build
```

Commit the generated base bundle and `inst/htmlwidgets/lib/stock-tools/`
with the build sources.
Installing or using the R package does not require Node.js.

`entry.js` selects the official chart and feature modules. Stock, Maps and Gantt extend
the same Highcharts instance as standard charts. Keep Boost last among the module imports.
`build.mjs` also creates the optional Stock Tools addon from the official indicators,
advanced annotations and toolbar assets. Third-party plugins remain separate.

For a Highcharts release upgrade, use the [maintainer command](../readme.md#update-highcharts)
from the repository root. The build updates all widget YAML versions automatically.

To exercise the installed R package, run `Rscript ../R/test-highcharts-bundle.R` from
this directory and open `preview/index.html`. The gallery covers the shared data shapes,
specialized series, Stock Tools and mixed widgets. Use Tab and the arrow keys on the first
chart to check keyboard navigation.

The Stock Tools bundle captures its own Highcharts defaults after its modules
load. The Stock Tools widget restores those defaults before applying the theme
and chart options. The base widgets continue to use the base bundle defaults
when both widget types appear on the same page.
Run `Rscript tests/browser/stock-tools.R /tmp/stock-tools.html` with the
package installed to check the toolbar alongside an ordinary Stock chart.
