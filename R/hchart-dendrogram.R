#' Draw a cluster dendrogram or a phylogeny
#'
#' Cluster trees preserve the leaf order and merge heights in the object.
#' Phylogenies use distance along the edges from the displayed root. The fan
#' layout maps that distance to radius. If branch lengths are absent each
#' edge counts as one step. The optional stem above the root is excluded.
#' @param object An `hclust`, `dendrogram`, or `ape::phylo` object.
#' @param layout For a phylogeny, `"fan"` (radial) or `"rectangular"`.
#' @param ... Highcharts line series options for the branches.
#' @return A highchart htmlwidget.
#' @examples
#' fit <- stats::hclust(stats::dist(scale(USArrests[1:10, ])))
#' hchart(fit)
#' if (requireNamespace("ape", quietly = TRUE)) {
#'   tree <- ape::read.tree(text = "((A:1,B:2):1,(C:2,D:1):2);")
#'   hchart(tree)
#' }
#' @export
hchart.hclust <- function(object, ...) {
  hchart(stats::as.dendrogram(object), ...)
}

#' @rdname hchart.hclust
#' @export
hchart.dendrogram <- function(object, ...) {
  nodes <- list()
  tip <- -1L
  # Postorder puts every child in the table before its parent.
  visit <- function(d) {
    leaf <- stats::is.leaf(d)
    kids <- if (!leaf) vapply(d, visit, integer(1))
    label <- ""
    if (leaf) {
      tip <<- tip + 1L
      label <- attr(d, "label")
      if (is.null(label)) label <- tip + 1L
    }
    x <- if (leaf) {
      tip
    } else {
      mean(vapply(nodes[kids[c(1, length(kids))]], "[[", numeric(1), "x"))
    }
    id <- length(nodes) + 1L
    nodes[[id]] <<- list(
      x = as.numeric(x),
      y = attr(d, "height"),
      kids = kids,
      label = as.character(label),
      members = attr(d, "members")
    )
    id
  }
  visit(object)
  x <- vapply(nodes, "[[", numeric(1), "x")
  y <- vapply(nodes, "[[", numeric(1), "y")
  children <- lapply(nodes, "[[", "kids")
  edges <- cbind(
    rep(seq_along(nodes), lengths(children)),
    as.integer(unlist(children))
  )
  leaf <- !lengths(children)
  labels <- vapply(nodes, "[[", character(1), "label")
  members <- vapply(nodes, "[[", numeric(1), "members")
  detail <- paste0("Height: ", signif(y, 5), "<br/>Members: ", members)
  hc <- branch_chart(edges, x, y, labels, detail, polar = FALSE, ...)
  hc |>
    hc_xAxis(
      categories = as.list(labels[leaf]),
      min = 0,
      max = sum(leaf) - 1L,
      title = list(text = NULL),
      tickLength = 0
    ) |>
    hc_yAxis(title = list(text = "Merge height"))
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
