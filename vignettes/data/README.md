# Data for pkgdown articles

- `measles-coverage.csv` contains first-dose measles vaccination coverage for nine countries, 2000–2025. Source: WHO/UNICEF Estimates of National Immunization Coverage, 2025 revision, [UNICEF download](https://data.unicef.org/resources/dataset/immunization/), CC BY 3.0 IGO. Regenerate from the repository root with `Rscript data-raw/measles-coverage.R` (requires readxl).
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
