context("list_parse")

test_that("list.parse returns nested list", {
  l <- rlist::list.parse(head(cars)) %>% setNames(NULL)
  on.exit(options("highcharter.boost" = FALSE))
  
  options("highcharter.boost" = FALSE)
  expect_equal(list_parse(head(cars)), l)
  
  options("highcharter.boost" = TRUE)
  expect_equal(list_parse(head(cars)), l)
})

test_that("list.parse2 returns nested list", {
  l <- rlist::list.parse(head(cars)) %>% setNames(NULL) %>% map(setNames, NULL)
  on.exit(options("highcharter.boost" = FALSE))
  
  options("highcharter.boost" = FALSE)
  expect_equal(list_parse2(head(cars)), l)
  
  options("highcharter.boost" = TRUE)
  expect_equal(list_parse2(head(cars)), l)
  
})

test_that("data frame parsing in boost-mode", {
  on.exit(options("highcharter.boost" = FALSE))
  data(mpg, package = "ggplot2")

  # Generate list without boost.
  options("highcharter.boost" = FALSE)
  org_char <- list_parse(mpg)  
  
  # Generate list with boost.
  options("highcharter.boost" = TRUE)
  boost_char <- list_parse(mpg)  
  expect_true(identical(org_char, boost_char))
  
  # Reconstruct dataframe with factor.
  l <- apply(mpg, MARGIN = 2, function(x) return(x))
  mpg_factor <- cbind.data.frame(l, stringsAsFactors = TRUE)  
  expect_true(any(sapply(mpg_factor, is.factor)))
  
  # Parse data frame to list without boost.
  options("highcharter.boost" = FALSE)
  org_factor <- list_parse(mpg_factor)  

  # Parse data frame to list with boost.
  options("highcharter.boost" = TRUE)
  boost_factor <- list_parse(mpg_factor)  
  expect_true(identical(org_factor, boost_factor))
})

test_that("tibble parsing compatible check", {
  on.exit(options("highcharter.boost" = FALSE))
  
  t <- tibble::tibble(head(cars))
  
  # Generate list without boost.
  options("highcharter.boost" = FALSE)
  t_org <- list_parse(t)
  
  options("highcharter.boost" = TRUE)
  expect_equal(list_parse(t), t_org)
  
})
