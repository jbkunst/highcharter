# Date to timestamps

Turn a date time vector to `timestamp` format

## Usage

``` r
datetime_to_timestamp(dt)
```

## Arguments

- dt:

  Date or datetime vector

## Examples

``` r
datetime_to_timestamp(
  as.Date(c("2015-05-08", "2015-09-12"),
    format = "%Y-%m-%d"
  )
)
#> [1] 1.431043e+12 1.442016e+12
```
