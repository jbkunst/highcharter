# Helper for make table in tooltips

Helper to make table in tooltips for the `pointFormat` parameter in
`hc_tooltip`

## Usage

``` r
tooltip_table(x, y, title = NULL, img = NULL, ...)
```

## Arguments

- x:

  A string vector with description text

- y:

  A string with accessors example: `point.series.name`, `point.x`

- title:

  A title tag with accessors or string

- img:

  Image tag

- ...:

  html attributes for the table element

## Examples

``` r
x <- c("Income:", "Genre", "Runtime")
y <- c(
  "$ {point.y}", "{point.series.options.extra.genre}",
  "{point.series.options.extra.runtime}"
)

tooltip_table(x, y)
#> [1] "<table>\n  <tr>\n    <th>Income:</th>\n    <td>$ {point.y}</td>\n  </tr>\n  <tr>\n    <th>Genre</th>\n    <td>{point.series.options.extra.genre}</td>\n  </tr>\n  <tr>\n    <th>Runtime</th>\n    <td>{point.series.options.extra.runtime}</td>\n  </tr>\n</table>"
```
