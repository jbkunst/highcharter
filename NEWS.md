# highcharter 0.7.0 

## Changes

* `highchart` function don't load plugins as default. Now there is `hc_add_plugin` to load as requiered (#258). 
* Fontawesome is not loaded as default. Now there is a `hc_add_depency_fa` function helper to load as required (#257). 

## New Features

* Highcharter now uses HighchartsJS 7 (7.0.1)
* `divBackgroundImage` works with themes (#278).
* New function `hctreemap2` (#110). 
* New function `hc_responsive` to configure responsive features(#305). 
* New function `tooltip_chart` to create minicharts in tooltips (#343). 
* New function `hc_boost` function to configure boost module options `module/boost.js` (#382).
* New function `hchart_` which uses  standar evaluation (#170).
* New function `hcaes_string` (#248). 
* New function `hcparcord`. Inspired **and copy** from http://rpubs.com/hadley/97970 (#167). 
* New functions  `hc_add_series.lm` and `hc_add_series.loess` (#271). 
* New function/theme Super Heroes (#286).
* New function/theme `hc_theme_ggplot2` to honoring one of the best packages (#260). 
* Added multicolor pluging (#251). 
* Added regression pluging (#262). 

## Bug Fixes

* Adding `encoding = "UTF-8"` in `download_map_data` to read characters properly (#359).
* Fixed `Error in mutate_impl` in `hcboxplot` (#323). 
* Fixed `export_hc(..., as = "is")` does not format javascript correctly (#398). 
* Added the MIME type to show fonts correctly (#308). 
* Fixed vignettes titles #244).
* Fixed bug due conflict etween highcharts v5 and dragabble-points pluging (#273). 
* `maxSize` uses the default highchartsJS value (#272). 
* `hchart.data.frame` and `hc_add_series.data.frame` forces to be data frame to avoid problems
with the data.table class (#263). 
* Fixed bug in `hc_add_series_df` when the data frame comes with a column named "series" (#241). 
* `hchart` don't override/change default highchartsJS options (#302). 

## Api Changes

* Remove deprecated `list.parse` functions (#259). 
* `hc_exported` was reworked (#247). 

# highcharter 0.5.0 

## Breaking changes

 * `hchart.data.frame` now gains a new `mapping` argument  using `hcaes` function to 
 define the aesthetics. After `hchart(df, "line", x = xvar, yvar, group = othervar)` 
 now: `hchart(df, "line", hcaes(x = xvar, yvar, color = othervar), ...)` and therefore
 `...` are used like other highcharter functions for give highcharts arguments 
 to the series. See _charting data frames_ vignette.
 
## New Funcionalities

 * `hc_add_series` is a generic generic function (#213). 
 * New `hcmap` function to chart maps (#218). And use remote sources (#215).
 * New _charting data frames_ vignette (http://rpubs.com/jbkunst/230276) (#220). 
 * New _charting maps_ vignette (http://jkunst.com/highcharter/highmaps.html) (#218). 
 * `debug` as an option instead of argument. Example `options(highcharter.debug = TRUE)` (#216).
 * Upgrade to highcharts V5 (#154) (#208). 
 * Added helpers & shorcuts for tooltip: sort and table (#206).
 * Added export-csv plugin to export chart data to CSV, XLS, HTML or JS array (#178). 
 * Added Grouped Categories pluging (#172) (#193). 
 * Added Tooltip delay pluging  (#181). 
 * Added `is.highchart` according with _Best practices_ in http://adv-r.had.co.nz/S3.html (#179). 
 * New themes:  `theme_firefox` (#191), `theme_tufte` (#190). `hc_theme_elementary` (#184). 
 * `hchart.data.frame` doesn't override the color if the colum var have a hexadecimal color
   format (#148).
 * Added `hc_size` function to change width and height (#146). 
 * Add more data for nice examples: vaccines, weather radials, pkmn (#145). 

## Changes

 * renaming `hcwaffle` to hciconarray. The `hcwaffle` do not make a waffle!  (#242). 
 * removing colize_vector function (#237). 
 * `viridisLite` moved from imports to suggests (#236). 

## Bug fixes

 * Fix map using `mapbubble` (#209). 
 * `hc_add_series_map` don't remove additional data (#188) (#189).
 * `hc_annotations` accept multiple arguments (#171).
 * Adding specific version of tibble (#159).
 * `hchart.data.frame` allow change stops in `hc_colorAxis` (#147). 
 

## Others

 * Remove underscore as dependencies (#214) (#210). 

# highcharter 0.4.0

## New Funcionalities

 * Include `elementId` to createWidget. Add the `hc_elementId()` to modify
 this paramter after the creation of the highchart object (#140).
 * `hchart` support data frames a la `ggplot2::qplot` (#136).
 * `hchart` support Principal Components objects `princomp` and `prcomp` 
 charting a biplot. Thanks to @nuno-agostinho  (#128 #123).
 * `hchart`support matrix objects charting a heatmap (`hchart.matrix`) (#86).
 * `hchart` support phylo objects (#64).
 * New `hcboxplot`, `hcwaffle`, `hcbar`, `hcpie`, `hchist`, `hcdensity`, 
 `hcts` function to get quick some style of charts. Thanks @nuo-agostinho fo
 `hc_add_series_density` implementation  (#99 #70).
 * New `hc_add_series_bwp` to chart box and whisker plots (#81).
 * New  `hc_add_series_list` to add list of series (#68).
 * New `hc_add_series_df_old` (!!) shortcut of 
 `hc_add_series(data = list.parse3(df))` (#76).
 * Added `hc_theme_sparkline` (#132).
 * Added function to create `dataClasses` and `stops` arguments in
 `hc_colorAxis` (#120).
 * Validate length of data = 1 and apply the `list` function  (#119 #188 #65 #71).
 * Added `colorize` function so `colorize_vector` will be deprecate 
 in the next release (#75).
 * Adding `hc_add_series_df` similar to `hchart.data.frame` (#114 #115).
 * Annotation funcionalities `hc_annotations` (#103).
 * Added `cross` as marker symbol (#96).
 * New `hc_yAxis_multiples` to add automatically arbitraty number of y axis
 (#90 #79).
 * New `hc_grid` to create a grid of highchart objects, inspired from 
 `mjs_grid` (#67 #66).
 * Add motion plugin http://www.highcharts.com/plugin-registry/single/40/Motion
 (#62).
 

## Changes

 * Upgrading to highcharts 4.2.4 (#72).
 * Options were separated into `highcharter.global`, `highcharter.lang` and
 `highcharter.chart` instead of having all in one big list (#77 #52).
 * `list.parse2` and `list.parse3` deperacted and renaming to `list_parse2`
 and `list_parse3`.
 * `hc_add_series_scatter` is  more flexible and general (#54 #58) 

## Bug fixes

 * `.hc_get_fonts` now handle fonts names with multiple spaces (#107).
 * `hchart.character` now display empty levels (#101).
 * `datetime_to_timestamp`don't break in certain cases (#97).
 
## Others

 * At startup a message disply mentioning that highchart, highstock and
 highmaps are not free for commercial and Governmental use.
 

# highcharter 0.3.1.9999

* Adding underscore dependency (previously was removed. Solves #28)
 
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

