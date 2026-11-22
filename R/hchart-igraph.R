#' Plot igraph objects using Highcharts
#'
#' @param object An igraph object.
#' @param layout A layout from igraph package.
#' @param ... Additional arguments for the data series
#'    (\url{https://api.highcharts.com/highcharts/series}).
#' @importFrom dplyr left_join select
#' @importFrom stats setNames
#' @importFrom rlang .data
#' @examplesIf requireNamespace("igraph", quietly = TRUE)
#' library(igraph)
#' N <- 40
#' net <- sample_gnp(N, p = 2 / N)
#' wc <- cluster_walktrap(net)
#' V(net)$label <- seq(N)
#' V(net)$name <- paste("I'm #", seq(N))
#' V(net)$page_rank <- round(page_rank(net)$vector, 2)
#' V(net)$betweenness <- round(betweenness(net), 2)
#' V(net)$degree <- degree(net)
#' V(net)$size <- V(net)$degree
#' V(net)$comm <- as.vector(membership(wc))
#' V(net)$color <- colorize(membership(wc))
#' hchart(net, layout = layout_with_fr)
#' @export
hchart.igraph <- function(object, ..., layout = NULL) {
  rlang::check_installed("igraph", reason = "to chart an igraph object.")
  # data
  if (is.null(layout)) {
    layout <- igraph::layout_nicely
  }
  dfv <- layout(object) |>
    round(5) |>
    data.frame() |>
    tibble::as_tibble() |>
    setNames(c("x", "y"))

  dfvex <- object |>
    igraph::vertex_attr() |>
    data.frame(stringsAsFactors = FALSE) |>
    tibble::as_tibble()

  if (nrow(dfvex) > 0) {
    dfv <- tibble::as_tibble(cbind(dfv, dfvex))
  }

  if (is.null(dfv[["name"]])) {
    dfv <- dfv |> mutate(name = seq(nrow(dfv)))
  }

  names(dfv) <- str_replace_all(names(dfv), "\\.", "_")

  dfe <- object |>
    igraph::as_edgelist() |>
    data.frame(stringsAsFactors = FALSE) |>
    tibble::as_tibble() |>
    setNames(c("from", "to")) |>
    left_join(
      dfv |>
        select("name", "x", "y") |>
        setNames(c("from", "xf", "yf")),
      by = "from"
    ) |>
    left_join(
      dfv |>
        select("name", "x", "y") |>
        setNames(c("to", "xt", "yt")),
      by = "to"
    ) |>
    mutate(linkedTo = "e")

  dfex <- object |>
    igraph::edge_attr() |>
    data.frame(stringsAsFactors = FALSE) |>
    tibble::as_tibble()

  if (nrow(dfex) > 0) {
    dfe <- tibble::as_tibble(cbind(dfe, dfex))
  }

  # Checking opts
  type <- "scatter"

  if ("size" %in% names(dfv)) {
    dfv <- dfv |> rename(z = "size")
    type <- "bubble"
  }

  if ("group" %in% names(dfv)) {
    dfv <- dfv |> rename(groupvar = "group")
  }

  if ("width" %in% names(dfe)) {
    dfe <- dfe |> rename(lineWidth = "width")
  }

  if (!"color" %in% names(dfe)) {
    dfe <- dfe |> mutate("color" = hex_to_rgba("#d3d3d3", 0.5))
  }

  dse <- list_parse(dfe) |>
    map(function(x) {
      x$data <- list(
        list(x = x$xf, y = x$yf),
        list(x = x$xt, y = x$yt)
      )
      x[c("xf", "yf", "xt", "yt")] <- NULL
      x
    })

  vattrs <- setdiff(names(dfv), c("x", "y", "z", "color", "label", "name"))

  tltip_fmt <- tooltip_table(
    str_to_title(str_replace_all(vattrs, "_", " ")),
    sprintf("{point.%s}", vattrs)
  )

  hc <- highchart() |>
    hc_chart(zoomType = "xy", type = "line") |>
    hc_tooltip(
      useHTML = TRUE
    ) |>
    hc_plotOptions(
      line = list(enableMouseTracking = FALSE),
      bubble = list(
        marker = list(fillOpacity = 0.65),
        minSize = 5,
        maxSize = 20
      )
    ) |>
    hc_add_theme(
      hc_theme_merge(
        getOption("highcharter.theme"),
        hc_theme("null", legend = list(enabled = TRUE))
      )
    )

  hc <- hc |>
    hc_add_series(
      data = list_parse(dfv),
      type = type,
      name = "nodes",
      zIndex = 3,
      tooltip = list(
        headerFormat = as.character(tags$small("{point.key}")),
        pointFormat = tltip_fmt
      ),
      ...
    )

  if ("label" %in% names(dfv)) {
    hc <- hc |>
      hc_add_series(
        data = list_parse(dfv |> select("x", "y", "label")),
        type = "scatter",
        name = "labels",
        zIndex = 4,
        marker = list(radius = 0),
        enableMouseTracking = FALSE,
        dataLabels = list(enabled = TRUE, format = "{point.label}")
      )
  }

  hc <- hc |>
    hc_add_series(data = NULL, name = "edges", id = "e") |>
    hc_add_series_list(dse)

  hc
}
