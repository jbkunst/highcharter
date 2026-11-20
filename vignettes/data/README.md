# Data for pkgdown articles

- `nyc-midwest-flights.csv.gz` contains one row per January 2013 flight in [nycflights13](https://nycflights13.tidyverse.org/) 1.0.2 with recorded arrival time at ORD, MDW, DTW, MSP, STL or MKE. It preserves origin and destination and looks up the carrier name in `airlines`. Source: US Bureau of Transportation Statistics.
- `holocene-volcanoes.csv.gz` contains the 1,215 Holocene entries in the [May 2026 Smithsonian GVP snapshot distributed by moderndive](https://github.com/moderndive/volcanoes/tree/7afe3f61fbce18173f41cd009a4c53b7468ea407). It retains the volcano ID, name, country, primary volcano type, coordinates and elevation in metres. [Smithsonian Global Volcanism Program terms and attribution](https://volcano.si.edu/gvp_terms.cfm).
- `plate-boundaries.geojson.gz` retains the named lines of [PB2002](https://github.com/fraxen/tectonicplates/blob/339b0c56563c118307b1f4542703047f5f698fae/GeoJSON/PB2002_boundaries.json), simplified at 0.2 degrees and rounded to two decimals for the world map. Peter Bird, converted by Hugo Ahlenius, Nordpil and contributors, [ODC Attribution 1.0](https://opendatacommons.org/licenses/by/1-0/).
- `stars.csv` preserves the 404-star sample used in [Nadieh Bremer's Hertzsprung–Russell diagram](https://bl.ocks.org/nbremer/eb0d1fd4118b731d069e2ff98dfadc47), formerly distributed as `highcharter::stars`.
- `tour-2017-stage-8.csv` is the distance (km) and elevation (m) profile from the [Tour de France annotations article](https://jkunst.com/blog/posts/2020-06-02-30diasdegraficos-parte-3/), adapted there from the Highcharts annotations demo. [Original CSV](https://raw.githubusercontent.com/jbkunst/blog/master/posts/2020-06-02-30diasdegraficos-parte-3/data/tour_france_state_8.txt).
- `southern-andes.geojson` contains eight selected volcano coordinates from the Smithsonian Global Volcanism Program, *Volcanoes of the World*, via the [May 2026 volcanoes snapshot](https://github.com/moderndive/volcanoes/tree/7afe3f61fbce18173f41cd009a4c53b7468ea407). The line retains the vertices of the Nazca–South America subduction boundary between 35°S and 43°S from [PB2002_boundaries.json](https://github.com/fraxen/tectonicplates/blob/339b0c56563c118307b1f4542703047f5f698fae/GeoJSON/PB2002_boundaries.json). Boundary data by Peter Bird, converted by Hugo Ahlenius, Nordpil and contributors, under [ODC Attribution 1.0](https://opendatacommons.org/licenses/by/1-0/). [Smithsonian data terms](https://volcano.si.edu/gvp_terms.cfm).

`manchester-basemap.geojson.gz` contains context for the airport example from
[OpenFreeMap](https://openfreemap.org/) using the OpenMapTiles schema. The
2026-11-15 snapshot (`20261115_080022_pt`) uses zoom 12 tiles, columns
2021–2023 and rows 1326–1328. The extract keeps water, vegetation, residential
areas, selected roads and railways within the bounding box
`[-2.365, 53.319, -2.186, 53.395]`, simplifies the shapes at 6 projected
metres and stores WGS84 coordinates. © OpenStreetMap contributors,
[ODbL 1.0](https://www.openstreetmap.org/copyright).

`drilldown-south-america.json.gz` holds geographic TopoJSON maps for the
continents, South America and 11 national subdivisions from the same
[Highcharts Map Collection snapshot](https://github.com/highcharts/map-collection-dist/tree/9a96e58cc818b66d246cc58e31448c3167b9a3b1)
as the installed maps. The named entries are the unmodified
`custom/world-continents.topo.json`, `custom/south-america.topo.json`, and
`countries/{code}/{code}-all.topo.json` for AR, BO, BR, CO, EC, GY, PE, PY,
SR, UY and VE, stored in a single gzip-compressed JSON object. Each entry
retains its credits. The article uses the package's 16-region map for Chile.
