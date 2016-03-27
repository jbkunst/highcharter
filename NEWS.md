# highcharter 0.3.0

* Igraph support to `hchart` (#61)

* New function `export_hc`. Take a highchart object and 
write a js file with the options (#60).

* New function `tooltip_table`. Helper to create table based
in `tags` from `htmltools`package #59).

* New function `hc_colors`. Function for the `colors` option in 
highcharts api (#57).

* Adding funnel.js and gauge-solid.js to depedenci for create
funnel charts and charts like apple watch (#56).

* The `hc_themes_...` functions gains a `...` parameter to
add styles to the current invoked theme (#53).

* More themes: flat, flatdark, smpl, ft (financial times) (#49).

* Dont run error (`\dontrun{}`) to avoid `quantmod` package example
in flags function

# highcharter 0.2.0

* Implemenation of highcharts with boost module `highchart2()` (#43). 
This include highcharts.js, exporting.js and boost-module.js.

* Highstock implementation/support (#10)

* Highmaps implementation/support (#25)

* Adding themes (#35): 538, economis, dotabuff, google, theme null (#19)

* Plugins: Add font awesome integration (#45), fill-pattern (#31),
draggable-points (#28)

* New `hchart` function. Generic function to chart acf, forecast,
ts, stl, xts, ohcl objects (#2) (#27)

* In highmaps prevent scrolling when cursor is over the map (#38)

* Import rex-export %>% (#15) 

* Heigth scale in the container in rstudio IDE (#14)

* Avoid duplicate css calls (#6)

* Add uscountygeojson, usgeojson, worldgeojson, unemployment data

# highcharter 0.1.0

* Data: city temp. favorite bars, favorite pies.

* Shortcuts to plot scatters, bar, pies, treemaps and time series

* Addging theme and options HC funcionalities

