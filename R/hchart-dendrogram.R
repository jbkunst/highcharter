#' Draw a cluster dendrogram or a phylogeny
#'
#' Cluster trees preserve the leaf order and merge heights in the object.
#' Phylogenies use distance along the edges from the displayed root. The fan
#' layout maps that distance to radius. If branch lengths are absent each
#' edge counts as one step. The optional stem above the root is excluded.
#' @details Cluster dendrograms use rectangular branches with square corners
#' to show each join at its merge height. The treegraph defaults for these
#' methods are `link = list(type = "orthogonal", bendAt = 0, radius = 0)`.
#' Use `hchart(fit, link = list(type = "straight"))` for triangular branches
#' or `type = "curved"` inside `link` to restore the native curved treegraph style.
#' @param object An `hclust`, `dendrogram`, or `ape::phylo` object.
#' @param layout For a phylogeny, `"fan"` (radial) or `"rectangular"`.
#' @param ... Highcharts treegraph series options for cluster trees, or line options for phylogeny branches.
#' @return A highchart htmlwidget.
#' @examplesIf requireNamespace("ape", quietly = TRUE)
#' data("bird.families", package = "ape")
#' families <- c(
#'   "Rheidae", "Casuariidae", "Struthionidae", "Phasianidae", "Numididae",
#'   "Odontophoridae", "Anhimidae", "Dendrocygnidae", "Anatidae"
#' )
#' birds <- ape::keep.tip(bird.families, families)
#' hchart(stats::as.hclust(birds))
#' hchart(birds)
#' @export
hchart.hclust <- function(object, ...) {
  hchart(stats::as.dendrogram(object), ...)
}

#' @rdname hchart.hclust
#' @export
hchart.dendrogram <- function(object, ...) {
  nodes <- list()
  leaves <- integer()
  max_depth <- 1L
  visit <- function(d, parent = "", depth = 1L) {
    i <- length(nodes) + 1L
    leaf <- stats::is.leaf(d)
    label <- attr(d, "label")
    if (leaf && is.null(label)) {
      label <- length(leaves) + 1L
    }
    nodes[[i]] <<- list(
      id = as.character(i),
      parent = parent,
      name = if (leaf) as.character(label) else "",
      x = attr(d, "height"),
      custom = list(members = attr(d, "members"))
    )
    if (leaf) {
      leaves <<- c(leaves, i)
      max_depth <<- max(depth, max_depth)
    } else {
      for (child in d) {
        visit(child, as.character(i), depth + 1L)
      }
    }
  }
  visit(object)
  # Align tips in traversal order while the numeric axis sets merge heights.
  for (i in leaves) {
    nodes[[i]]$level <- max_depth
  }
  nodes[[leaves[1L]]]$dataLabels <- list(align = "left")
  nodes[[leaves[length(leaves)]]]$dataLabels <- list(align = "right")
  heights <- vapply(nodes, "[[", numeric(1), "x")
  options <- list(...)
  link <- utils::modifyList(
    list(
      type = "orthogonal",
      bendAt = 0,
      radius = 0,
      color = "#555555",
      lineWidth = 1.5
    ),
    Filter(
      Negate(is.null),
      list(color = options$color, lineWidth = options$lineWidth)
    )
  )
  series <- utils::modifyList(
    list(
      type = "treegraph",
      data = nodes,
      reversed = FALSE,
      link = link,
      marker = list(
        radius = 0.1,
        lineWidth = 6,
        lineColor = "transparent",
        fillColor = "transparent"
      ),
      collapseButton = list(enabled = FALSE),
      dataLabels = list(
        enabled = TRUE,
        format = "{point.name}",
        linkFormat = "",
        y = 20,
        align = "center",
        crop = FALSE,
        overflow = "allow",
        style = list(fontWeight = "normal", textOutline = "none")
      ),
      tooltip = list(
        headerFormat = "",
        pointFormat = "{point.name}<br/>Height: {point.x}<br/>Members: {point.custom.members}",
        linkFormat = "{point.toNode.name}<br/>Height: {point.toNode.x}<br/>Members: {point.toNode.custom.members}"
      )
    ),
    options
  )
  highchart() |>
    hc_chart(inverted = TRUE, marginBottom = 35) |>
    hc_xAxis(
      visible = TRUE,
      reversed = FALSE,
      min = min(heights),
      max = max(heights),
      offset = 20,
      gridLineWidth = 0,
      title = list(text = "Merge height")
    ) |>
    hc_yAxis(visible = FALSE) |>
    hc_legend(enabled = FALSE) |>
    hc_add_series_list(list(series))
}

#' @rdname hchart.hclust
#' @export
hchart.phylo <- function(object, ..., layout = c("fan", "rectangular")) {
  rlang::check_installed("ape", reason = "to lay out a phylogeny.")
  layout <- match.arg(layout)
  unit_edges <- is.null(object$edge.length)
  if (unit_edges) {
    object$edge.length <- rep(1, nrow(object$edge))
  }
  if (any(!is.finite(object$edge.length))) {
    stop("Branch lengths must be finite.", call. = FALSE)
  }
  n <- length(object$tip.label)
  y <- ape::node.depth.edgelength(object)
  polar <- layout == "fan"
  if (polar && any(y < 0)) {
    stop(
      "Negative root distances require layout = 'rectangular'.",
      call. = FALSE
    )
  }
  x <- ape::node.height(object)
  labels <- c(object$tip.label, rep_len("", object$Nnode))
  if (!is.null(object$node.label)) {
    labels[n + seq_len(object$Nnode)] <- object$node.label
  }
  labels[is.na(labels)] <- ""
  distance <- if (unit_edges) "Steps from root" else "Distance from root"
  detail <- paste0(distance, ": ", signif(y, 5))
  child <- object$edge[, 2]
  detail[child] <- paste0(
    detail[child],
    "<br/>Branch length: ",
    signif(object$edge.length, 5)
  )
  hc <- branch_chart(object$edge, x, y, labels, detail, polar = polar, ...) |>
    hc_chart(polar = polar, inverted = !polar) |>
    hc_xAxis(visible = FALSE, min = 0.5, max = n + 0.5) |>
    hc_yAxis(
      visible = !polar,
      title = list(text = distance),
      min = min(0, y),
      endOnTick = FALSE,
      gridLineWidth = 1
    ) |>
    hc_plotOptions(
      scatter = list(
        dataLabels = list(
          enabled = TRUE,
          format = "{point.name}",
          crop = FALSE,
          overflow = "allow",
          style = list(fontWeight = "normal", textOutline = "2px contrast")
        )
      )
    )
  if (polar) {
    hc <- hc_pane(hc, size = "78%", background = list())
  }
  hc
}

# Draw all branches in one disconnected line series. Nodes supply the hit
# targets and tooltips, including for multifurcating trees.
branch_chart <- function(edges, x, y, labels, detail, polar, ...) {
  # In polar coordinates a constant-radius join follows a circular arc.
  max_position <- max(x)
  branches <- lapply(seq_len(nrow(edges)), function(i) {
    parent <- edges[i, 1]
    child <- edges[i, 2]
    start <- x[parent]
    end <- x[child]
    steps <- if (polar) {
      max(1, ceiling(abs(end - start) * 120 / max_position))
    } else {
      1L
    }
    pos <- seq(start, end, length.out = steps + 1L)
    c(Map(list, pos, y[parent]), list(list(end, y[child]), list(end, NA_real_)))
  })
  points <- list_parse(data.frame(
    x = x,
    y = y,
    name = htmltools::htmlEscape(labels),
    detail = detail
  ))
  highchart() |>
    hc_legend(enabled = FALSE) |>
    hc_add_series_list(list(utils::modifyList(
      list(
        type = "scatter",
        name = "Branches",
        data = unlist(branches, recursive = FALSE),
        color = "#8C8C8C",
        lineWidth = 1.5,
        marker = list(enabled = FALSE),
        enableMouseTracking = FALSE,
        accessibility = list(enabled = FALSE),
        dataLabels = list(enabled = FALSE),
        connectEnds = FALSE,
        connectNulls = FALSE
      ),
      list(...)
    ))) |>
    hc_add_series(
      type = "scatter",
      name = "Nodes",
      data = points,
      marker = list(radius = 3),
      tooltip = list(
        headerFormat = "",
        pointFormat = "<b>{point.name}</b><br/>{point.detail}"
      )
    )
}
