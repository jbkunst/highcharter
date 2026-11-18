test_that("point and series helpers preserve each other's event handlers", {
  click <- JS("function() { return false; }")
  hc <- highchart() |>
    hc_plotOptions(line = list(point = list(events = list(click = click)))) |>
    hc_add_event_point("line", "mouseOver") |>
    hc_add_event_point("line", "drop") |>
    hc_add_event_series("line", "mouseOver")

  expect_identical(hc_add_event_point(hc, "line", "click"), hc)
  line <- hc$x$hc_opts$plotOptions$line
  expect_identical(line$point$events$click, click)
  expect_named(line$point$events, c("click", "mouseOver", "drop"))
  expect_named(line$events, "mouseOver")
})
