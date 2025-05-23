#' Creating highcharter themes
#'
#' Highcharts is very flexible so you can modify every element of the chart.
#' There are some exiting themes so you can apply style to charts with few
#' lines of code.
#'
#' More examples and details in \url{https://www.highcharts.com/docs/chart-design-and-style/themes}.
#'
#' @param ... A list of named parameters.
#'
#' @examples
#'
#' hc <- highcharts_demo()
#'
#' hc
#'
#' thm <- hc_theme(
#'   colors = c("red", "green", "blue"),
#'   chart = list(
#'     backgroundColor = "#15C0DE"
#'   ),
#'   title = list(
#'     style = list(
#'       color = "#333333",
#'       fontFamily = "Erica One"
#'     )
#'   ),
#'   subtitle = list(
#'     style = list(
#'       color = "#666666",
#'       fontFamily = "Shadows Into Light"
#'     )
#'   ),
#'   legend = list(
#'     itemStyle = list(
#'       fontFamily = "Tangerine",
#'       color = "black"
#'     ),
#'     itemHoverStyle = list(
#'       color = "gray"
#'     )
#'   )
#' )
#'
#' hc_add_theme(hc, thm)
#' @export
hc_theme <- function(...) {
  structure(list(...), class = "hc_theme")
}

#' Add themes to a highchart object
#'
#' Add highcharts themes to a highchart object.
#'
#' @param hc A highchart object
#' @param hc_thm A highchart theme object (\code{"hc_theme"} class)
#'
#' @examples
#'
#' highchart() |>
#'   hc_add_series(
#'     data = c(
#'       7.0, 6.9, 9.5, 14.5, 18.2, 21.5, 25.2,
#'       26.5, 23.3, 18.3, 13.9, 9.6
#'     ),
#'     type = "column"
#'   ) |>
#'   hc_add_theme(hc_theme_sandsignika())
#' @export
hc_add_theme <- function(hc, hc_thm) {
  assert_that(is.highchart(hc), .is_hc_theme(hc_thm))

  hc$x$fonts <- unique(c(hc$x$fonts, .hc_get_fonts(hc_thm)))

  hc$x$theme <- hc_thm

  hc
}

#' Merge themes
#'
#' Function to combine hc_theme objects.
#'
#' @param ... \code{hc_theme} objects.
#'
#' @examples
#'
#' thm <- hc_theme_merge(
#'   hc_theme_darkunica(),
#'   hc_theme(
#'     chart = list(
#'       backgroundColor = "transparent",
#'       divBackgroundImage = "http://cdn.wall-pix.net/albums/art-3Dview/00025095.jpg"
#'     ),
#'     title = list(
#'       style = list(
#'         color = "white",
#'         fontFamily = "Erica One"
#'       )
#'     )
#'   )
#' )
#' @export
hc_theme_merge <- function(...) {
  themes <- list(...)

  assert_that(unique(unlist(purrr::map(themes, class))) == "hc_theme")

  theme <- structure(list.merge(...), class = "hc_theme")

  theme
}

.hc_get_fonts <- function(lst) {
  unls <- unlist(lst)
  unls <- unls[grepl("fontFamily", names(unls))]

  fonts <- unls |>
    str_replace_all(",\\s+sans-serif|,\\s+serif", "") |>
    str_replace_all("\\s+", "+") |>
    str_trim() |>
    unlist()

  fonts
}
