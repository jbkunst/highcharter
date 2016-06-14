#' Simple Theme
#' 
#' Desing inspired by \url{https://github.com/hrbrmstr/hrbrmisc/blob/master/R/ggplot.r}
#' and color by \url{https://www.materialui.co/colors}
#' 
#' @param ... Named argument to modify the theme
#' 
#' @examples 
#' 
#' hc_demo() %>% 
#'   hc_add_theme(hc_theme_smpl())
#' 
#' @export
hc_theme_smpl <- function(...){
  
  theme <-
    hc_theme_merge(
      hc_theme_google(),
      hc_theme(
        colors =  c( "#f44336",
                     "#3F51B5",
                     "#4CAF50",
                     "#795548",
                     "#607D8B",
                     "#4CAF50" 
                     ),
        chart = list(
          style = list(
            fontFamily = "Roboto"
          )
        ),
        title = list(
          align = "left",
          style = list(
            fontFamily = "Roboto Condensed",
            fontWeight = "bold"
          )
        ),
        subtitle = list(
          align = "left",
          style = list(
            fontFamily = "Roboto Condensed"
          )
        ),
        legend = list(
          align = "right",
          verticalAlign = "bottom"
        )
      )
    )

  theme <- structure(theme, class = "hc_theme")
  
  if (length(list(...)) > 0) {
    theme <- hc_theme_merge(
      theme,
      hc_theme(...)
    )
  } 
  
  theme
  
}

