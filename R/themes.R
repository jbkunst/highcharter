#' @export
hc_add_theme <- function(hc, hc_theme){
  
  assert_that(.is_highchart(hc),
              .is_hc_theme(hc_theme))
  
  hc$x$theme <- hc_theme
  
  hc
  
}

#' @export
hc_theme_simple <- function() {
  
  theme <- structure(list(
    colors = c("#058DC7", "#50B432", "#ED561B", "#DDDF00", "#24CBE5", "#64E572", "#FF9655", "#FFF263", "#6AF9C4"),
    chart = structure(list(
      backgroundColor = structure(list(
        linearGradient = c(0L, 0L, 500L, 500L),
        stops = structure(c("0", "1", "rgb(255, 255, 255)", "rgb(240, 240, 255)"), .Dim = c(2L, 2L))),
        .Names = c("linearGradient", "stops"))),
      .Names = "backgroundColor"),
    title = structure(list(
      style = structure(list(
        color = "#000", font = "bold 16px 'Trebuchet MS', Verdana, sans-serif"),
        .Names = c("color", "font"))),
      .Names = "style"),
    subtitle = structure(list(
      style = structure(list(
        color = "#666666",
        font = "bold 12px 'Trebuchet MS', Verdana, sans-serif"),
        .Names = c("color", "font"))),
      .Names = "style"),
    legend = structure(list(
      itemStyle = structure(list(
        font = "9pt 'Trebuchet MS', Verdana, sans-serif",
        color = "black"),
        .Names = c("font","color")),
      itemHoverStyle = structure(list(color = "gray"),
                                 .Names = "color")),
      .Names = c("itemStyle", "itemHoverStyle"))),
    .Names = c("colors", "chart", "title", "subtitle",  "legend"))
  
  theme <- structure(theme, class = "hc_theme")
  
  theme
  
}
