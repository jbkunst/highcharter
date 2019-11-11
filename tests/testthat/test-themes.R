test_that("my_own_theme example works", {
  library(dplyr)
  
  data(diamonds, package = "ggplot2")
  
  d <- count(diamonds, cut, color)
  
  my_own_theme <- hc_theme(
    colors = c("red", "green", "blue"),
    chart = list(
      backgroundColor = NULL,
      divBackgroundImage = "http://media3.giphy.com/media/FzxkWdiYp5YFW/giphy.gif"
    ),
    title = list(
      style = list(
        color = "#333333",
        fontFamily = "Lato"
      )
    ),
    subtitle = list(
      style = list(
        color = "#666666",
        fontFamily = "Shadows Into Light"
      )
    ),
    legend = list(
      itemStyle = list(
        fontFamily = "Tangerine",
        color = "black"
      ),
      itemHoverStyle = list(
        color = "gray"
      )
    )
  )
  
  h <- hchart(d, "column", hcaes(x = color, y = n, group = cut)) %>%
    hc_yAxis(title = list(text = "Cases")) %>%
    hc_title(text = "Diamonds Are Forever") %>%
    hc_subtitle(text = "Source: Diamonds data set") %>%
    hc_credits(enabled = TRUE, text = "jkunst.com") %>%
    hc_tooltip(sort = TRUE, table = TRUE) %>% 
    hc_add_theme(my_own_theme)
  
  expect_true(all(class(h) %in% c("highchart","htmlwidget")))
})

test_that("hc_theme_merge example works", {
  library(dplyr)
  
  data(diamonds, package = "ggplot2")
  
  d <- count(diamonds, cut, color)
  
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
          fontFamily = "Open Sans"
        )
      )
    )
  )
  
  h <- hchart(d, "column", hcaes(x = color, y = n, group = cut)) %>%
    hc_yAxis(title = list(text = "Cases")) %>%
    hc_title(text = "Diamonds Are Forever") %>%
    hc_subtitle(text = "Source: Diamonds data set") %>%
    hc_credits(enabled = TRUE, text = "jkunst.com") %>%
    hc_tooltip(sort = TRUE, table = TRUE) %>% 
    hc_add_theme(thm)
  
  expect_true(all(class(h) %in% c("highchart","htmlwidget")))
})

test_that("Test all themes", {
  
  h <- highcharts_demo()
  
  expect_true(all(class(hc_add_theme(h, hc_theme_538()))         %in% c("highchart","htmlwidget")))
  expect_true(all(class(hc_add_theme(h, hc_theme_alone()))       %in% c("highchart","htmlwidget")))
  expect_true(all(class(hc_add_theme(h, hc_theme_bloom()))       %in% c("highchart","htmlwidget")))
  expect_true(all(class(hc_add_theme(h, hc_theme_chalk()))       %in% c("highchart","htmlwidget")))
  expect_true(all(class(hc_add_theme(h, hc_theme_darkunica()))   %in% c("highchart","htmlwidget")))
  expect_true(all(class(hc_add_theme(h, hc_theme_db()))          %in% c("highchart","htmlwidget")))
  expect_true(all(class(hc_add_theme(h, hc_theme_economist()))   %in% c("highchart","htmlwidget")))
  expect_true(all(class(hc_add_theme(h, hc_theme_elementary()))  %in% c("highchart","htmlwidget")))
  expect_true(all(class(hc_add_theme(h, hc_theme_ffx()))         %in% c("highchart","htmlwidget")))
  expect_true(all(class(hc_add_theme(h, hc_theme_flat()))        %in% c("highchart","htmlwidget")))
  expect_true(all(class(hc_add_theme(h, hc_theme_flatdark()))    %in% c("highchart","htmlwidget")))
  expect_true(all(class(hc_add_theme(h, hc_theme_ft()))          %in% c("highchart","htmlwidget")))
  expect_true(all(class(hc_add_theme(h, hc_theme_ggplot2()))     %in% c("highchart","htmlwidget")))
  expect_true(all(class(hc_add_theme(h, hc_theme_google()))      %in% c("highchart","htmlwidget")))
  expect_true(all(class(hc_add_theme(h, hc_theme_gridlight()))   %in% c("highchart","htmlwidget")))
  expect_true(all(class(hc_add_theme(h, hc_theme_handdrawn()))   %in% c("highchart","htmlwidget")))
  expect_true(all(class(hc_add_theme(h, hc_theme_monokai()))     %in% c("highchart","htmlwidget")))
  expect_true(all(class(hc_add_theme(h, hc_theme_null()))        %in% c("highchart","htmlwidget")))
  expect_true(all(class(hc_add_theme(h, hc_theme_sandsignika())) %in% c("highchart","htmlwidget")))
  expect_true(all(class(hc_add_theme(h, hc_theme_smpl()))        %in% c("highchart","htmlwidget")))
  expect_true(all(class(hc_add_theme(h, hc_theme_sparkline()))   %in% c("highchart","htmlwidget")))
  expect_true(all(class(hc_add_theme(h, hc_theme_superheroes())) %in% c("highchart","htmlwidget")))
  expect_true(all(class(hc_add_theme(h, hc_theme_tufte()))       %in% c("highchart","htmlwidget")))
  expect_true(all(class(hc_add_theme(h, hc_theme_tufte2()))      %in% c("highchart","htmlwidget")))

  
})
