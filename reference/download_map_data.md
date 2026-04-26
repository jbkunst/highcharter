# Helper function to download the map data form a url

The urls are listed in <https://code.highcharts.com/mapdata/>.

## Usage

``` r
download_map_data(
  url = "custom/world.js",
  showinfo = FALSE,
  quiet = FALSE,
  method = "curl"
)
```

## Arguments

- url:

  The map's url.

- showinfo:

  Show the properties of the downloaded map to know how are the keys to
  add data in `hcmap`.

- quiet:

  Boolean parameter to turn off download messages (on by default).

- method:

  A string value for the download method used by
  [`download.file`](https://rdrr.io/r/utils/download.file.html).

## See also

[`hcmap`](https://jkunst.com/highcharter/reference/hcmap.md)

## Examples

``` r
if (FALSE) { # \dontrun{
mpdta <- download_map_data("https://code.highcharts.com/mapdata/countries/us/us-ca-all.js")
mpdta <- download_map_data("https://code.highcharts.com/mapdata/countries/us/us-ca-all.js",
  quiet = TRUE
)
str(mpdta, 1)
} # }
```
