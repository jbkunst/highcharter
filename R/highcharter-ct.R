#' Highcharter Crosstalk Widget
#' @param data Data frame 
#' @param hc_opts A \code{list} object containing options defined as 
#'    \url{http://api.highcharts.com/highcharts}.
#' @param theme A \code{hc_theme} class object.
#' @param width A numeric input in pixels.
#' @param height  A numeric input in pixels.
#' @param elementId	Use an explicit element ID for the widget.
#' @export
highchart_ct <- function(data = NULL,
                         hc_opts = list(),
                         theme = getOption("highcharter.theme"),
                         width = NULL,
                         height = NULL,
                         elementId = NULL) {
  
  if (crosstalk::is.SharedData(data)) {
    # Using Crosstalk
    key <- data$key()
    group <- data$groupName()
    data <- data$origData()
  } else {
    # Not using Crosstalk
    key <- NULL
    group <- NULL
  }
  
  opts <- .join_hc_opts()

  if (identical(hc_opts, list()))
    hc_opts <- opts$chart
  
  unfonts <- unique(c(.hc_get_fonts(hc_opts), .hc_get_fonts(theme))) 
  
  opts$chart <- NULL
  
  # forward options using x
  x <- list(
    data = data,
    settings = list(
      crosstalk_key = key,
      crosstalk_group = group
    ),
    hc_opts = hc_opts,
    theme = theme,
    conf_opts = opts,
    fonts = unfonts,
    debug = getOption("highcharter.debug")
  )
  
  attr(x, "TOJSON_ARGS") <- list(pretty = getOption("highcharter.debug"))
  
  # create widget
  htmlwidgets::createWidget(
    name = "highchartct",
    x,
    width = width,
    height = height,
    package = "highcharter",
    elementId = elementId,
    sizingPolicy = htmlwidgets::sizingPolicy(
      defaultWidth = "100%",
      knitr.figure = FALSE,
      knitr.defaultWidth = "100%",
      browser.fill = TRUE
      ),
    dependencies = crosstalk::crosstalkLibs()
  )
}
