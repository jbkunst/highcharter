# Package index

## Highcharts API

Functions to create charts and access the highcharts API
(<https://api.highcharts.com/highcharts/>).

- [`highchart()`](https://jkunst.com/highcharter/reference/highchart.md)
  : Create a Highcharts chart widget
- [`hchart()`](https://jkunst.com/highcharter/reference/hchart.md) :
  Create a highchart object from a particular data type
- [`hc_annotations()`](https://jkunst.com/highcharter/reference/hc_annotations.md)
  : Annotations options for highcharter objects
- [`hc_boost()`](https://jkunst.com/highcharter/reference/hc_boost.md) :
  Boost options for highcharter objects
- [`hc_caption()`](https://jkunst.com/highcharter/reference/hc_caption.md)
  : Caption options for highcharter objects
- [`hc_chart()`](https://jkunst.com/highcharter/reference/hc_chart.md) :
  Chart options for highcharter objects
- [`hc_colorAxis()`](https://jkunst.com/highcharter/reference/hc_colorAxis.md)
  : Coloraxis options for highcharter objects
- [`hc_colors()`](https://jkunst.com/highcharter/reference/hc_colors.md)
  : Colors options for highcharter objects
- [`hc_credits()`](https://jkunst.com/highcharter/reference/hc_credits.md)
  : Credits options for highcharter objects
- [`hc_drilldown()`](https://jkunst.com/highcharter/reference/hc_drilldown.md)
  : Drilldown options for highcharter objects
- [`hc_exporting()`](https://jkunst.com/highcharter/reference/hc_exporting.md)
  : Exporting options for highcharter objects
- [`hc_legend()`](https://jkunst.com/highcharter/reference/hc_legend.md)
  : Legend options for highcharter objects
- [`hc_loading()`](https://jkunst.com/highcharter/reference/hc_loading.md)
  : Loading options for highcharter objects
- [`hc_pane()`](https://jkunst.com/highcharter/reference/hc_pane.md) :
  Pane options for highcharter objects
- [`hc_plotOptions()`](https://jkunst.com/highcharter/reference/hc_plotOptions.md)
  : Plotoptions options for highcharter objects
- [`hc_responsive()`](https://jkunst.com/highcharter/reference/hc_responsive.md)
  : Responsive options for highcharter objects
- [`hc_series()`](https://jkunst.com/highcharter/reference/hc_series.md)
  : Series options for highcharter objects
- [`hc_subtitle()`](https://jkunst.com/highcharter/reference/hc_subtitle.md)
  : Subtitle options for highcharter objects
- [`hc_title()`](https://jkunst.com/highcharter/reference/hc_title.md) :
  Title options for highcharter objects
- [`hc_tooltip()`](https://jkunst.com/highcharter/reference/hc_tooltip.md)
  : Tooltip options for highcharter objects
- [`hc_xAxis()`](https://jkunst.com/highcharter/reference/hc_xAxis.md) :
  Xaxis options for highcharter objects
- [`hc_yAxis()`](https://jkunst.com/highcharter/reference/hc_yAxis.md) :
  Yaxis options for highcharter objects
- [`hc_zAxis()`](https://jkunst.com/highcharter/reference/hc_zAxis.md) :
  Zaxis options for highcharter objects
- [`hc_navigator()`](https://jkunst.com/highcharter/reference/hc_navigator.md)
  : Navigator options for highcharter objects
- [`hc_rangeSelector()`](https://jkunst.com/highcharter/reference/hc_rangeSelector.md)
  : Rangeselector options for highcharter objects
- [`hc_scrollbar()`](https://jkunst.com/highcharter/reference/hc_scrollbar.md)
  : Scrollbar options for highcharter objects
- [`hc_mapNavigation()`](https://jkunst.com/highcharter/reference/hc_mapNavigation.md)
  : Mapnavigation options for highcharter objects
- [`highchartzero()`](https://jkunst.com/highcharter/reference/highchartzero.md)
  : Create a Highcharts chart widget

## Additional function to use Highcharts API

Helpers function to add or modify elements, like plugins (as {htmltools}
dependencies), events or annotations.

- [`hc_add_annotation()`](https://jkunst.com/highcharter/reference/hc_add_annotation.md)
  [`hc_add_annotations()`](https://jkunst.com/highcharter/reference/hc_add_annotation.md)
  : Helper to add annotations from data frame or list

- [`hc_add_dependency()`](https://jkunst.com/highcharter/reference/hc_add_dependency.md)
  : Add modules or plugin dependencies to highcharts objects

- [`hc_add_event_point()`](https://jkunst.com/highcharter/reference/hc_add_event_point.md)
  [`hc_add_event_series()`](https://jkunst.com/highcharter/reference/hc_add_event_point.md)
  : Helpers to use highcharter as input in shiny apps

- [`hc_yAxis_multiples()`](https://jkunst.com/highcharter/reference/hc_add_yAxis.md)
  [`hc_xAxis_multiples()`](https://jkunst.com/highcharter/reference/hc_add_yAxis.md)
  [`hc_zAxis_multiples()`](https://jkunst.com/highcharter/reference/hc_add_yAxis.md)
  [`create_axis()`](https://jkunst.com/highcharter/reference/hc_add_yAxis.md)
  [`hc_add_yAxis()`](https://jkunst.com/highcharter/reference/hc_add_yAxis.md)
  : Creating multiples yAxis t use with highcharts

- [`hc_elementId()`](https://jkunst.com/highcharter/reference/hc_elementId.md)
  :

  Setting `elementId`

- [`hc_motion()`](https://jkunst.com/highcharter/reference/hc_motion.md)
  : Setting Motion options to highcharts objects

- [`hc_rm_series()`](https://jkunst.com/highcharter/reference/hc_rm_series.md)
  : Removing series to highchart objects

- [`hc_size()`](https://jkunst.com/highcharter/reference/hc_size.md) :

  Changing the size of a `highchart` object

## Add data

Functions to add data from R objects to a highcharts charts.

- [`hc_add_series()`](https://jkunst.com/highcharter/reference/hc_add_series.md)
  : Adding data to highchart objects

- [`hc_add_series(`*`<character>`*`)`](https://jkunst.com/highcharter/reference/hc_add_series.character.md)
  [`hc_add_series(`*`<factor>`*`)`](https://jkunst.com/highcharter/reference/hc_add_series.character.md)
  : hc_add_series for character and factor objects

- [`hc_add_series(`*`<data.frame>`*`)`](https://jkunst.com/highcharter/reference/hc_add_series.data.frame.md)
  : hc_add_series for data frames objects

- [`hc_add_series(`*`<density>`*`)`](https://jkunst.com/highcharter/reference/hc_add_series.density.md)
  : hc_add_series for density objects

- [`hc_add_series(`*`<forecast>`*`)`](https://jkunst.com/highcharter/reference/hc_add_series.forecast.md)
  : hc_add_series for forecast objects

- [`hc_add_series(`*`<geo_json>`*`)`](https://jkunst.com/highcharter/reference/hc_add_series.geo_json.md)
  [`hc_add_series(`*`<geo_list>`*`)`](https://jkunst.com/highcharter/reference/hc_add_series.geo_json.md)
  : hc_add_series for geo_json & geo_list objects

- [`hc_add_series(`*`<lm>`*`)`](https://jkunst.com/highcharter/reference/hc_add_series.lm.md)
  [`hc_add_series(`*`<loess>`*`)`](https://jkunst.com/highcharter/reference/hc_add_series.lm.md)
  : hc_add_series for lm and loess objects

- [`hc_add_series(`*`<numeric>`*`)`](https://jkunst.com/highcharter/reference/hc_add_series.numeric.md)
  :

  `hc_add_series` for numeric objects

- [`hc_add_series(`*`<ts>`*`)`](https://jkunst.com/highcharter/reference/hc_add_series.ts.md)
  : hc_add_series for time series objects

- [`hc_add_series(`*`<xts>`*`)`](https://jkunst.com/highcharter/reference/hc_add_series.xts.md)
  [`hc_add_series(`*`<ohlc>`*`)`](https://jkunst.com/highcharter/reference/hc_add_series.xts.md)
  : hc_add_series for xts objects

- [`hc_add_series_list()`](https://jkunst.com/highcharter/reference/hc_add_series_list.md)
  : Shortcut for data series from a list of data series

- [`hc_add_series_map()`](https://jkunst.com/highcharter/reference/hc_add_series_map.md)
  : Add a map series

## Data helpers

Function to help manipulate data to use in specific arguments or some
types of series. For example create valid arguments in `dataClasses`,
`stops` or `pointFormatter` parameters and create the rigth type of
format to create treemaps, sunburst or sankey charts.

- [`color_classes()`](https://jkunst.com/highcharter/reference/color_classes.md)
  :

  Function to create `dataClasses` argument in `hc_colorAxis`

- [`color_stops()`](https://jkunst.com/highcharter/reference/color_stops.md)
  :

  Function to create `stops` argument in `hc_colorAxis`

- [`colorize()`](https://jkunst.com/highcharter/reference/colorize.md) :
  Create vector of color from vector

- [`data_to_boxplot()`](https://jkunst.com/highcharter/reference/data_to_boxplot.md)
  : Helper to transform data frame for boxplot highcharts format

- [`data_to_hierarchical()`](https://jkunst.com/highcharter/reference/data_to_hierarchical.md)
  : Helper to transform data frame for treemap/sunburst highcharts
  format

- [`data_to_sankey()`](https://jkunst.com/highcharter/reference/data_to_sankey.md)
  : Helper to transform data frame for sankey highcharts format

- [`tooltip_chart()`](https://jkunst.com/highcharter/reference/tooltip_chart.md)
  : Helper to create charts in tooltips.

- [`tooltip_table()`](https://jkunst.com/highcharter/reference/tooltip_table.md)
  : Helper for make table in tooltips

- [`hex_to_rgba()`](https://jkunst.com/highcharter/reference/hex_to_rgba.md)
  : Transform colors from hexadecimal format to rgba hc notation

- [`datetime_to_timestamp()`](https://jkunst.com/highcharter/reference/datetime_to_timestamp.md)
  : Date to timestamps

- [`df_to_annotations_labels()`](https://jkunst.com/highcharter/reference/df_to_annotations_labels.md)
  : Function to create annotations arguments from a data frame

## Shiny and proxy functions

Functions to create highcharts in shinyapps or rmarkdown documents.
Proxy functions allow you maniupulate a highchart widget from server
side in a shiny app.

- [`highchartProxy()`](https://jkunst.com/highcharter/reference/highchartProxy.md)
  : Send commands to a Highcharts instance in a Shiny app
- [`hcpxy_add_point()`](https://jkunst.com/highcharter/reference/hcpxy_add_point.md)
  : Add point to a series of a higchartProxy object
- [`hcpxy_add_series()`](https://jkunst.com/highcharter/reference/hcpxy_add_series.md)
  : Add data to higchartProxy element
- [`hcpxy_loading()`](https://jkunst.com/highcharter/reference/hcpxy_loading.md)
  : Show or hide loading text for a higchartProxy object
- [`hcpxy_redraw()`](https://jkunst.com/highcharter/reference/hcpxy_redraw.md)
  : Redraw a higchartProxy object
- [`hcpxy_remove_point()`](https://jkunst.com/highcharter/reference/hcpxy_remove_point.md)
  : Remove point to a series of a higchartProxy object
- [`hcpxy_remove_series()`](https://jkunst.com/highcharter/reference/hcpxy_remove_series.md)
  : Remove series to higchartProxy element
- [`hcpxy_set_data()`](https://jkunst.com/highcharter/reference/hcpxy_set_data.md)
  : Update data for a higchartProxy object
- [`hcpxy_update()`](https://jkunst.com/highcharter/reference/hcpxy_update.md)
  : Update options for a higchartProxy object
- [`hcpxy_update_point()`](https://jkunst.com/highcharter/reference/hcpxy_update_point.md)
  : Update options series in a higchartProxy object
- [`hcpxy_update_series()`](https://jkunst.com/highcharter/reference/hcpxy_update_series.md)
  : Update options series in a higchartProxy object
- [`highchartOutput()`](https://jkunst.com/highcharter/reference/highchartOutput.md)
  [`highchartOutputZ()`](https://jkunst.com/highcharter/reference/highchartOutput.md)
  : Widget output function for use in Shiny
- [`renderHighchart()`](https://jkunst.com/highcharter/reference/renderHighchart.md)
  [`renderHighchartZ()`](https://jkunst.com/highcharter/reference/renderHighchart.md)
  : Widget render function for use in Shiny

## Themes

Functions to customize the look of your chart.

- [`hc_theme()`](https://jkunst.com/highcharter/reference/hc_theme.md) :
  Creating highcharter themes
- [`hc_add_theme()`](https://jkunst.com/highcharter/reference/hc_add_theme.md)
  : Add themes to a highchart object
- [`hc_theme_merge()`](https://jkunst.com/highcharter/reference/hc_theme_merge.md)
  : Merge themes
- [`hc_theme_538()`](https://jkunst.com/highcharter/reference/hc_theme_538.md)
  [`hc_theme_sparkline_vb()`](https://jkunst.com/highcharter/reference/hc_theme_538.md)
  [`hc_theme_tufte2()`](https://jkunst.com/highcharter/reference/hc_theme_538.md)
  : Theme collection for highcharts
- [`hc_theme_alone()`](https://jkunst.com/highcharter/reference/hc_theme_alone.md)
  : Alone theme for highcharts
- [`hc_theme_bloom()`](https://jkunst.com/highcharter/reference/hc_theme_bloom.md)
  : Bloomberg Graphics theme for highcharts
- [`hc_theme_chalk()`](https://jkunst.com/highcharter/reference/hc_theme_chalk.md)
  : Chalk theme for highcharts
- [`hc_theme_darkunica()`](https://jkunst.com/highcharter/reference/hc_theme_darkunica.md)
  : Dark Unica theme for highcharts
- [`hc_theme_db()`](https://jkunst.com/highcharter/reference/hc_theme_db.md)
  : Dotabuff theme for highcharts
- [`hc_theme_economist()`](https://jkunst.com/highcharter/reference/hc_theme_economist.md)
  : Economist theme for highcharts
- [`hc_theme_elementary()`](https://jkunst.com/highcharter/reference/hc_theme_elementary.md)
  : Elementary (OS) theme for highcharts
- [`hc_theme_ffx()`](https://jkunst.com/highcharter/reference/hc_theme_ffx.md)
  : Firefox theme for highcharts
- [`hc_theme_flat()`](https://jkunst.com/highcharter/reference/hc_theme_flat.md)
  : Flat theme for highcharts
- [`hc_theme_flatdark()`](https://jkunst.com/highcharter/reference/hc_theme_flatdark.md)
  : Flatdark theme for highcharts
- [`hc_theme_ft()`](https://jkunst.com/highcharter/reference/hc_theme_ft.md)
  : Financial Times theme for highcharts
- [`hc_theme_ggplot2()`](https://jkunst.com/highcharter/reference/hc_theme_ggplot2.md)
  : ggplot2 theme for highcharts
- [`hc_theme_google()`](https://jkunst.com/highcharter/reference/hc_theme_google.md)
  : Google theme for highcharts
- [`hc_theme_gridlight()`](https://jkunst.com/highcharter/reference/hc_theme_gridlight.md)
  : Grid Light theme for highcharts
- [`hc_theme_handdrawn()`](https://jkunst.com/highcharter/reference/hc_theme_handdrawn.md)
  : Hand Drawn theme for highcharts
- [`hc_theme_hcrt()`](https://jkunst.com/highcharter/reference/hc_theme_hcrt.md)
  : Highcharter theme for highcharts
- [`hc_theme_monokai()`](https://jkunst.com/highcharter/reference/hc_theme_monokai.md)
  : Monokai theme for highcharts
- [`hc_theme_null()`](https://jkunst.com/highcharter/reference/hc_theme_null.md)
  : Null theme for highcharts
- [`hc_theme_sandsignika()`](https://jkunst.com/highcharter/reference/hc_theme_sandsignika.md)
  : Sand Signika theme for highcharts
- [`hc_theme_smpl()`](https://jkunst.com/highcharter/reference/hc_theme_smpl.md)
  : Simple theme for highcharts
- [`hc_theme_sparkline()`](https://jkunst.com/highcharter/reference/hc_theme_sparkline.md)
  : Sparkline theme for highcharts
- [`hc_theme_superheroes()`](https://jkunst.com/highcharter/reference/hc_theme_superheroes.md)
  : Superheroes theme for highcharts
- [`hc_theme_tufte()`](https://jkunst.com/highcharter/reference/hc_theme_tufte.md)
  : Tufte theme for highcharts

## Data

Data for examples

- [`mountains_panorama`](https://jkunst.com/highcharter/reference/mountains_panorama.md)
  : Visual comparison of Mountains Panorama
- [`citytemp`](https://jkunst.com/highcharter/reference/citytemp.md) :
  City temperatures from a year in wide format
- [`citytemp_long`](https://jkunst.com/highcharter/reference/citytemp_long.md)
  : City temperatures from a year in long format
- [`favorite_bars`](https://jkunst.com/highcharter/reference/favorite_bars.md)
  : Marshall's Favorite Bars
- [`favorite_pies`](https://jkunst.com/highcharter/reference/favorite_pies.md)
  : Marshall's Favorite Pies
- [`globaltemp`](https://jkunst.com/highcharter/reference/globaltemp.md)
  : globaltemp
- [`pokemon`](https://jkunst.com/highcharter/reference/pokemon.md) :
  pokemon
- [`stars`](https://jkunst.com/highcharter/reference/stars.md) : stars
- [`unemployment`](https://jkunst.com/highcharter/reference/unemployment.md)
  : US Counties unemployment rate
- [`uscountygeojson`](https://jkunst.com/highcharter/reference/uscountygeojson.md)
  : US Counties map in Geojson format (list)
- [`usgeojson`](https://jkunst.com/highcharter/reference/usgeojson.md) :
  US States map in Geojson format (list)
- [`vaccines`](https://jkunst.com/highcharter/reference/vaccines.md) :
  Vaccines
- [`weather`](https://jkunst.com/highcharter/reference/weather.md) :
  Weather
- [`worldgeojson`](https://jkunst.com/highcharter/reference/worldgeojson.md)
  : World map in Geojson format (list)

## Extra functions

- [`download_map_data()`](https://jkunst.com/highcharter/reference/download_map_data.md)
  : Helper function to download the map data form a url

- [`export_hc()`](https://jkunst.com/highcharter/reference/export_hc.md)
  : Function to export js file the configuration options

- [`get_data_from_map()`](https://jkunst.com/highcharter/reference/get_data_from_map.md)
  :

  Helper function to get the data inside the map data The urls are
  listed in <https://code.highcharts.com/mapdata/>.

- [`get_hc_series_from_df()`](https://jkunst.com/highcharter/reference/get_hc_series_from_df.md)
  : Auxiliar function to get series and options from tidy frame for
  hchart.data.frame

- [`hcaes()`](https://jkunst.com/highcharter/reference/hcaes.md) :

  Define aesthetic mappings. Similar in spirit to
  [`ggplot2::aes`](https://ggplot2.tidyverse.org/reference/aes.html)

- [`hcaes_string()`](https://jkunst.com/highcharter/reference/hcaes_string.md)
  [`hcaes_()`](https://jkunst.com/highcharter/reference/hcaes_string.md)
  :

  Define aesthetic mappings using strings. Similar in spirit to
  [`ggplot2::aes_string`](https://ggplot2.tidyverse.org/reference/aes_.html)

- [`hchart(`*`<igraph>`*`)`](https://jkunst.com/highcharter/reference/hchart.igraph.md)
  : Plot igraph objects using Highcharts

- [`hchart(`*`<survfit>`*`)`](https://jkunst.com/highcharter/reference/hchart.survfit.md)
  : Plot survival curves using Highcharts

- [`hcmap()`](https://jkunst.com/highcharter/reference/hcmap.md) :

  Shortcut for create map from <https://code.highcharts.com/mapdata/>
  collection.

- [`highcharter-exports`](https://jkunst.com/highcharter/reference/highcharter-exports.md)
  [`JS`](https://jkunst.com/highcharter/reference/highcharter-exports.md)
  [`tags`](https://jkunst.com/highcharter/reference/highcharter-exports.md)
  : highcharter exported operators and S3 methods

- [`highcharter-package`](https://jkunst.com/highcharter/reference/highcharter.md)
  [`highcharter`](https://jkunst.com/highcharter/reference/highcharter.md)
  :

  An `htmlwidget` interface to the Highcharts javascript chart library

- [`highcharts_demo()`](https://jkunst.com/highcharter/reference/highcharts_demo.md)
  : Chart a demo for testing themes

- [`is.hexcolor()`](https://jkunst.com/highcharter/reference/is.hexcolor.md)
  : Check if a string vector is in hexadecimal color format

- [`is.highchart()`](https://jkunst.com/highcharter/reference/is.highchart.md)
  : Reports whether x is a highchart object

- [`list_parse()`](https://jkunst.com/highcharter/reference/list_parse.md)
  [`list_parse2()`](https://jkunst.com/highcharter/reference/list_parse.md)
  : Convert an object to list with identical structure

- [`mutate_mapping()`](https://jkunst.com/highcharter/reference/mutate_mapping.md)
  : Modify data frame according to mapping

- [`random_id()`](https://jkunst.com/highcharter/reference/random_id.md)
  : Function to generate iids

- [`str_to_id()`](https://jkunst.com/highcharter/reference/str_to_id.md)
  [`str_to_id_vec()`](https://jkunst.com/highcharter/reference/str_to_id.md)
  : String to 'id' format

## Deprecated functions

Functions that will be removed in the next version of the package.

- [`hcparcords()`](https://jkunst.com/highcharter/reference/hcparcords.md)
  : Shortcut to create parallel coordinates
- [`hc_yAxis_multiples()`](https://jkunst.com/highcharter/reference/hc_add_yAxis.md)
  [`hc_xAxis_multiples()`](https://jkunst.com/highcharter/reference/hc_add_yAxis.md)
  [`hc_zAxis_multiples()`](https://jkunst.com/highcharter/reference/hc_add_yAxis.md)
  [`create_axis()`](https://jkunst.com/highcharter/reference/hc_add_yAxis.md)
  [`hc_add_yAxis()`](https://jkunst.com/highcharter/reference/hc_add_yAxis.md)
  : Creating multiples yAxis t use with highcharts
