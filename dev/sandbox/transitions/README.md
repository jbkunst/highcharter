# Transiciones entre gráficos

Abre cualquiera de los dos HTML directamente en el navegador. Los archivos incluyen Highcharts, los datos y el JavaScript de la animación. Funcionan sin conexión.

- [Versión por clic](highcharter-transiciones-por-clic.html). Usa **Anterior**, **Siguiente** o las flechas del teclado para moverte entre las 16 vistas. En el gráfico de puntos y el de burbujas, el eje de esperanza de vida empieza en 50 años.
- [Versión automática](highcharter-transiciones.html). Reproduce la secuencia completa, páusala o salta a una vista con los controles.
- [Datos y script R](datos-animacion.zip). Descomprime el archivo para revisar los CSV, sus fuentes en `LEEME.md` y las consultas en `actualizar.R`.

## Secuencia definida en R

[pie-sequence.R](pie-sequence.R) reconstruye las 16 vistas con la misma muestra
de 132 países. Los datos, los gráficos, las pausas y las duraciones se definen
en R, en `scenes` y `steps`:

1. Pie de población.
2. Dona de población.
3. Dona de PIB.
4. Barras con el número de países.
5. Un punto por país.
6. Item con los países agrupados por continente.
7. Tilemap geográfico.
8. Scatter de PIB por habitante y esperanza de vida.
9. Burbujas con tamaño por población.
10. Packed bubble en tres grupos de 44 países por PIB por habitante.
11. Treemap de población.
12. Treemap de exportaciones de bienes en 2025.
13. Líneas de exportaciones por continente, 2007–2025.
14. Áreas con las mismas observaciones.
15. Áreas apiladas.
16. Streamgraph.

Usa el tema `hcrt`, la paleta de la referencia asignada por continente y un
diseño sin título ni subtítulo, con leyenda y explicación centradas.
Las fuentes IBM Plex Sans y Alegreya Sans SC se cargan mediante el mecanismo
de Google Fonts de highcharter (`google_fonts = TRUE`); necesitan conexión
la primera vez. La familia visible, al no haber títulos, es IBM Plex Sans.
[pie-sequence.js](pie-sequence.js) ejecuta la secuencia usando `onRender()` y
las actualizaciones de Highcharts, sin servidor Shiny ni librerías adicionales.

El script lee los indicadores y las exportaciones del ZIP local, y reutiliza
la grilla de `dev/examples-charts/data/world-tile-grid.csv`. Hong Kong conserva
la celda adicional de la referencia. No descarga datos al reproducir la secuencia.

Desde la raíz del repositorio:

```r
pkgload::load_all(".")
source("dev/sandbox/transitions/pie-sequence.R", encoding = "UTF-8")
utils::browseURL(normalizePath(preview_file, winslash = "/"), browser = NULL)
```

El script deja cada gráfico en `scenes`, el widget final en `hc` y una página
con dependencias locales en
`dev/highcharts-bundle/preview/pie-sequence.html`, fuera del control de versiones.
Cada pausa comienza al terminar la transición anterior. Los controles permiten
pausar el avance, repetir, ir a la vista anterior o siguiente y elegir una vista.
Al pausar, la transición actual termina y la secuencia permanece en esa vista.
Si el navegador solicita movimiento reducido, la reproducción empieza en modo
manual y los cambios son instantáneos.

Se reutiliza una sola instancia de Highcharts. Las animaciones son las nativas:
`series.animation = TRUE` activa también la entrada de las series nuevas, y
el ejecutor pasa la duración a `chart.update()`. La navegación manual y el modo
de movimiento reducido aplican las vistas sin animación.
Los cambios de datos y las geometrías compatibles se interpolan; las conversiones
entre tipos diferentes no reproducen todos los puentes SVG personalizados del
prototipo original. Este experimento de una sola instancia se conserva separado
de la portada, que ahora usa el grid sincronizado descrito abajo.

## Synchronized 2-by-2 grid

[grid-sequence.R](grid-sequence.R) builds the homepage independently of the
single-chart prototype above. All comments and visible analytical captions in
the grid are in English.

Visual review is still open. The maintainer has not approved the overall
animation or the scatter's return to its initial view. Passing geometry,
resize and synchronization checks is technical validation, not visual sign-off.

| Panel | Stage 1: Global patterns | Stage 2: People and scale | Stage 3: South America | Stage 4: Trade positions |
| --- | --- | --- | --- | --- |
| Top left | Income and longevity, equal-sized points | Bubble area represents population | South America emphasized, global axes retained | Exports and imports per person, both logarithmic |
| Top right | Regional exports, lines | Areas stacked to 100% | Stacked values, all regional colors | Global streamgraph |
| Bottom left | GDP per person, logarithmic colors | Life expectancy | Life expectancy, zoomed to South America | Global goods balance / total trade |
| Bottom right | Merchandise-export shares | The same shares as a donut | Population shares, South America emphasized | The same population shares as a 180-degree arc |

All panels use the same 179-economy cohort and common snapshot year, 2024;
exports cover 2005–2024. Russia is included. The R preparation script fetches WDI
data and determines the latest comparable year, rather than mixing current
observations from different years. Prepared CSVs are versioned and website
builds use them without API calls. See the
[data guide](data/README.md) for provenance, units, selection and refresh steps.

[grid-sequence.js](grid-sequence.js) maintains one clock and shared analytical
state. When the map focuses on South America, the scatter emphasizes South American
economies and smoothly fades other regions into the background; the export
chart keeps all regional colors and the pie highlights South America's population
share. This focus lasts only one state; all panels return to the world in
the fourth state. Income/longevity and trade positions connect scatter and map;
trade connects history and the first pie, while population connects bubble
sizes and the final pie. A shared table tooltip compares regional exports;
the second state shows percentages using native `stacking = "percent"` and
`point.percentage`. The other states retain absolute trade values. The line
view labels the uppermost series at 2008 and 2020, with a 24-pixel offset.
Light year guides locate the events in the other views.
Plain country names label
Chile and Uruguay during the regional view.

Each chart retains its Highcharts instance. Bubble series render the scatter
initially with equal sizes. Persistent streamgraph series supply lines, areas,
stacking and centered stacking by changing fill and stacking options. Pie
series retain their type; the final arc uses `startAngle = -90` and
`endAngle = 90`. The executor applies changed options with `update()` and
`setData()`, retaining point IDs and SVG paths. Native `SVGElement.animate()`
also interpolates colors, fill opacity and region emphasis.

The map reuses local TopoJSON, `hcmap()`, a continuous color axis and the Equal
Earth projection. Native MapView methods animate the camera; MapView's redraw
also marks map geometry dirty when a camera change does not change any data.
The camera fits all selected South American countries. The color axis occupies
76% of the chart width and uses explicit numeric labels. Native MapView geometry
fitting allows centering on South America without world panning constraints.
Fixed scatter margins
and captured marker rectangles prevent plot-box shifts or geometry resets
when changing variables, including the return to the first state.

From the repository root:

```r
pkgload::load_all(".")
source("dev/sandbox/transitions/grid-sequence.R", encoding = "UTF-8")
utils::browseURL(normalizePath(grid_file, winslash = "/"), browser = NULL)
```

The generated file is `dev/highcharts-bundle/preview/grid-sequence.html`.
The four sets of R chart objects are in `widget_families`; timed states,
captions and camera positions are in `families`. The R script also writes
`home-data.csv` beside the site iframe. Source and coverage details remain in
the [data guide](data/README.md); the grid has no source footer. To fetch fresh data before
building, set `options(highcharter.website.refresh_data = TRUE)`; reset that
option after the refresh.

On small screens the grid becomes one column. It uses the hcrt theme, IBM Plex
Sans, one shared regional legend, Play/Pause, Restart and a stage picker.
Initial widgets render without entrance animation. The executor reuses the R
first scene, then performs one native sizing pass after fonts and layout settle.
Playback starts only after that pass; the initial scatter must be visible without
any control interaction or viewport resize. Transitions last 1.4 seconds, with a gentler
2-second return to the initial variables, followed
by a 2.5-second hold. Manual selection also animates. Reduced-motion preferences
disable autoplay and interpolation. Both automatic looping from the fourth
state to the first and Restart use animated updates. Test intermediate
geometry at that boundary, including both scatter coordinates.

The homepage uses this same R object through `pkgdown/index-examples.R`,
which writes `home-gallery.html`, its dependencies and `home-data.csv` into
the generated site.
