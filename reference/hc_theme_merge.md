# Merge themes

Function to combine hc_theme objects.

## Usage

``` r
hc_theme_merge(...)
```

## Arguments

- ...:

  `hc_theme` objects.

## Examples

``` r
thm <- hc_theme_merge(
  hc_theme_darkunica(),
  hc_theme(
    chart = list(
      backgroundColor = "transparent",
      divBackgroundImage = "http://cdn.wall-pix.net/albums/art-3Dview/00025095.jpg"
    ),
    title = list(
      style = list(
        color = "white",
        fontFamily = "Erica One"
      )
    )
  )
)
```
