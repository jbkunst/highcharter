# Chart example data

`districts.geojson` and `districts.topo.json` encode the same two illustrative
districts in the maps vignette. Their `code` properties are the strings
`"01"` and `"02"`.

`spy-2025.csv` is a fixed snapshot of daily SPDR S&P 500 ETF Trust (SPY)
OHLC, volume and adjusted-close values from Yahoo Finance. Downloaded on
2026-11-16 with:

```r
x <- quantmod::getSymbols("SPY", from = "2025-01-01", to = "2026-01-01",
                         auto.assign = FALSE)
write.csv(data.frame(date = as.Date(zoo::index(x)), zoo::coredata(x)),
          "inst/extdata/spy-2025.csv", row.names = FALSE)
```

It supplies 250 trading days for the closing Stock dashboard. That example
adjusts OHLC using the supplied adjusted close and retains the reported volume.
Source: https://finance.yahoo.com/quote/SPY/history/

`world-tile-grid.csv` supplies the specialized tile-map example. Official
map boundaries and their provenance are documented in `maps/README.md` in the installed package.

`catarina-wind.csv` contains modified Copernicus Climate Change Service
information. Source: Hersbach et al., [ERA5 hourly data on single levels](https://doi.org/10.24381/cds.adbb2d47)
([CC BY 4.0](https://creativecommons.org/licenses/by/4.0/)), distributed in
[Google's ARCO-ERA5 archive](https://github.com/google-research/arco-era5).
The 280 grid points sample the eastward and northward 10 m wind components
(`u` and `v` in m/s) at 2004-03-27 18:00 UTC. The following extraction
reproduces the CSV with Python, xarray, gcsfs and Zarr.

```python
import numpy as np
import xarray as xr

store = "gs://gcp-public-data-arco-era5/ar/full_37-1h-0p25deg-chunk-1.zarr-v3"
ds = xr.open_zarr(store, chunks=None, storage_options={"token": "anon"})
field = ds[["10m_u_component_of_wind", "10m_v_component_of_wind"]].sel(
    time="2004-03-27T18:00", latitude=np.arange(-23.25, -33.01, -0.75),
    longitude=np.arange(304.5, 318.76, 0.75)
)
rows = field.to_dataframe().reset_index().rename(columns={
    "longitude": "lon", "latitude": "lat",
    "10m_u_component_of_wind": "u", "10m_v_component_of_wind": "v"
})
rows["lon"] -= 360
rows[["lon", "lat", "u", "v"]].round(2).to_csv("catarina-wind.csv", index=False)
```

`manchester-airport.geojson` retains all 416 geometries from the [POSCON UK
EGCC snapshot](https://github.com/POSCON-United-Kingdom/UK-Radar-Data/blob/6a020b03fbfeffe9f7eb53e4b4559de48134e351/AirfieldGeoJson/EGCC.geojson).
The example keeps `aeroway`, `ref` and `name`. Where the source has no name,
the label uses the feature category and any available reference.

`laguna-seca.geojson` keeps the `surface`, `pit_lane` and `apex` features from
[Track Atlas](https://github.com/tobi/track-atlas/blob/8c12ac414ea74ffe4a3ef74b294a2eafab7ee60d/tracks/laguna-seca/raw/layers/gp.surface.geojson).
Each feature retains its geometry and role and has a label for the tooltip.
[Track Atlas sources and attribution](https://github.com/tobi/track-atlas/blob/8c12ac414ea74ffe4a3ef74b294a2eafab7ee60d/ATTRIBUTION.md).

Both extracts contain data © OpenStreetMap contributors and are distributed
under the [Open Database License 1.0](https://opendatacommons.org/licenses/odbl/1-0/).
