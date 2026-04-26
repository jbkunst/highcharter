# Function to export js file the configuration options

Function to export js file the configuration options

## Usage

``` r
export_hc(hc, filename = NULL, as = "is", name = NULL)
```

## Arguments

- hc:

  A `Highcharts object`.

- filename:

  String of the exported file.

- as:

  String to define how to save the configuration options. One of 'is',
  'container', 'variable'.

- name:

  A variable used to put as name of the generated object if `as` is
  `'variable'` and the css/js selector if is `as` is container.

## Examples

``` r
fn <- "function(){
  console.log('Category: ' + this.category);
  alert('Category: ' + this.category);
}"

hc <- highcharts_demo() |>
  hc_plotOptions(
    series = list(
      cursor = "pointer",
      point = list(
        events = list(
          click = JS(fn)
        )
      )
    )
  )
if (FALSE) { # \dontrun{
export_hc(hc, filename = "~/hc_is.js", as = "is")
export_hc(hc, filename = "~/hc_vr.js", as = "variable", name = "objectname")
export_hc(hc, filename = "~/hc_ct.js", as = "container", name = "#selectorid")
} # }
```
