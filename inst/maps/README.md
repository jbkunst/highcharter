# Packaged maps

The 202 two-letter RDS files contain national maps. The custom directory contains
the world and regional geometries used by the articles. Refresh them from the
package root with `Rscript data-raw/maps.R`.

Map source: [Highcharts Map Collection, pinned snapshot](https://github.com/highcharts/map-collection-dist/tree/9a96e58cc818b66d246cc58e31448c3167b9a3b1).
Each file keeps its map-specific copyright, credit and source metadata.

Chile uses the 16 regional geometries from [BCN Chile and OCHA ROLAC via geoBoundaries](https://github.com/wmgeolab/geoBoundaries/tree/9469f09/releaseData/gbOpen/CHL/ADM1),
boundary ID CHL-ADM1-47653553, representing 2020. These boundaries are licensed
under [CC BY 3.0 IGO](https://creativecommons.org/licenses/by/3.0/igo/).
For this package they were simplified, rounded and joined to two-digit CUT codes
and existing Highcharts feature properties. The map retains the old `hc-key`
values for the original 15 regions and adds `cl-nb` for Ñuble.
