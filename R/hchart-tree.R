#' Chart a fitted decision tree
#'
#' Use a Highcharts treegraph for a `partykit::ctree()` fit, an `rpart`
#' classification or ANOVA tree, or a single C5.0 tree. The adapters use
#' `partykit` when charting a tree. For `rpart`, fit with `model = TRUE`
#' to retain the model frame when the training data may be unavailable.
#'
#' Node area represents the number of training rows. Classification nodes
#' show observed class proportions in factor level order. Regression nodes
#' show the observed mean on a shared color axis. Counts and summaries are
#' unweighted. Hover over a node for its summary and, when stored by the
#' fit, the split variable's association p-value. Click a split to fold it.
#'
#' @param object A fitted `constparty`, `rpart`, or `C5.0` model.
#' @param ... Additional Highcharts treegraph series options.
#' @param node_shape Classification marker, either `"donut"` or `"bar"`.
#' @param node_size Root diameter in pixels, or the equivalent area for a bar.
#' @return A highchart htmlwidget.
#' @examplesIf requireNamespace("partykit", quietly = TRUE)
#' fit <- partykit::ctree(Species ~ Petal.Length + Petal.Width, data = iris)
#' hchart(fit, node_shape = "bar") |>
#'   hc_colors(c("#087B71", "#AD591D", "#7655A0"))
#' @export
hchart.constparty <- function(
  object,
  ...,
  node_shape = c("donut", "bar"),
  node_size = 64
) {
  node_shape <- match.arg(node_shape)
  stopifnot(
    is.numeric(node_size),
    length(node_size) == 1L,
    is.finite(node_size),
    node_size > 0
  )
  dots <- list(...)
  if (!is.null(dots$type) && !identical(dots$type, "treegraph")) {
    stop("Decision trees use type = 'treegraph'.", call. = FALSE)
  }
  response <- object$fitted[["(response)"]]
  classification <- is.factor(response)
  if (
    !length(response) ||
      !(classification || (is.numeric(response) && is.null(dim(response))))
  ) {
    stop(
      "A decision tree needs a stored factor or numeric response.",
      call. = FALSE
    )
  }
  points <- decision_tree_points(object, response, node_shape, node_size)
  hc <- highchart() |>
    hc_chart(
      inverted = TRUE,
      animation = FALSE,
      events = list(render = decision_tree_render())
    ) |>
    hc_tooltip(useHTML = TRUE) |>
    hc_legend(enabled = !classification) |>
    hc_responsive(
      rules = list(list(
        condition = list(maxWidth = 485),
        chartOptions = list(
          plotOptions = list(
            treegraph = list(
              dataLabels = list(
                linkFormat = "{point.fromNode.name}<br/>{point.toNode.custom.rule}",
                style = list(fontSize = "11px")
              )
            )
          )
        )
      ))
    ) |>
    hc_plotOptions(
      treegraph = list(
        dataLabels = list(linkFormat = "{point.toNode.custom.condition}")
      )
    )
  series <- list(
    type = "treegraph",
    data = points,
    custom = list(categories = as.list(levels(response))),
    animation = FALSE,
    zIndex = 3,
    clip = FALSE,
    fillSpace = FALSE,
    collapseButton = list(enabled = FALSE),
    link = list(type = "straight", color = "#8C8C8C", lineWidth = 1.5),
    dataLabels = list(
      enabled = TRUE,
      pointFormat = "",
      linkTextPath = list(enabled = FALSE),
      allowOverlap = TRUE,
      padding = 3,
      verticalAlign = "middle",
      style = list(
        color = "#333333",
        fontWeight = "normal",
        textOutline = "3px #FFFFFF",
        whiteSpace = "nowrap"
      )
    ),
    tooltip = list(
      headerFormat = "",
      pointFormat = "{point.custom.tooltip}",
      linkFormat = "{point.toNode.custom.tooltip}"
    )
  )
  if (!classification) {
    limits <- range(response, finite = TRUE)
    if (diff(limits) == 0) {
      limits <- limits + c(-0.5, 0.5)
    }
    hc <- hc |>
      hc_colorAxis(
        min = limits[1],
        max = limits[2],
        startOnTick = FALSE,
        endOnTick = FALSE,
        minColor = "#D3F0EA",
        maxColor = "#095766"
      ) |>
      hc_legend(title = list(text = "Mean response"))
    series$colorKey <- "custom.mean"
  }
  donuts <- classification && node_shape == "donut"
  if (donuts) {
    # The treegraph finishes changing point visibility after toggleCollapse fires.
    series$events <- list(
      toggleCollapse = htmlwidgets::JS(
        "function () {
      const chart = this.chart;
      queueMicrotask(() => { if (chart.renderer) chart.redraw(false); });
    }"
      )
    )
  }
  hc <- do.call(
    hc_add_series,
    c(list(hc = hc), utils::modifyList(series, dots))
  )
  if (donuts) {
    for (p in points) {
      parts <- p$custom$composition
      if (!length(parts)) {
        next
      }
      radius <- 0.91 * p$marker$radius
      smallest <- min(vapply(parts, "[[", integer(1), "y")) / p$custom$n
      border <- if (length(parts) > 1L) {
        min(0.08 * radius, pi * radius * smallest)
      } else {
        0
      }
      hc <- hc |>
        hc_add_series(
          type = "pie",
          data = parts,
          custom = list(anchor = p$id),
          center = c(-500, -500),
          size = 2 * radius,
          innerSize = "60%",
          slicedOffset = 0,
          borderColor = "#FFFFFF",
          borderWidth = border,
          borderRadius = 0,
          animation = FALSE,
          enableMouseTracking = FALSE,
          showInLegend = FALSE,
          states = list(inactive = list(opacity = 1)),
          dataLabels = list(enabled = FALSE),
          accessibility = list(enabled = FALSE)
        )
    }
  }
  hc
}

#' @rdname hchart.constparty
#' @export
hchart.rpart <- function(object, ...) {
  rlang::check_installed("partykit", reason = "to chart an rpart tree.")
  if (!object$method %in% c("class", "anova")) {
    stop("Supported rpart methods are 'class' and 'anova'.", call. = FALSE)
  }
  hchart(partykit::as.party(object), ...)
}

#' @rdname hchart.constparty
#' @export
hchart.C5.0 <- function(object, ...) {
  # C50 registers its own as.party() method, including for fits read from RDS.
  loadNamespace("C50")
  if (isTRUE(nzchar(object$rules)) || !isTRUE(object$trials["Actual"] == 1L)) {
    stop("Chart a single C5.0 tree fitted with rules = FALSE.", call. = FALSE)
  }
  hchart(partykit::as.party(object), ...)
}

decision_tree_points <- function(object, response, shape, size) {
  fitted <- object$fitted[["(fitted)"]]
  colors <- stats::setNames(
    sprintf("var(--hc-tree-class-%d)", seq_along(levels(response)) - 1L),
    levels(response)
  )
  root <- partykit::node_party(object)
  total <- sum(fitted %in% partykit::nodeids(root, terminal = TRUE))
  if (!total) {
    stop("No training rows are assigned to this tree.", call. = FALSE)
  }
  format_value <- function(x) {
    ifelse(is.finite(x), formatC(x, digits = 2L, format = "f"), "\u2014")
  }
  visit <- function(node, parent = NULL, variable = "", rule = "") {
    id <- as.character(partykit::id_node(node))
    kids <- partykit::kids_node(node)
    leaf <- !length(kids)
    values <- response[fitted %in% partykit::nodeids(node, terminal = TRUE)]
    n <- length(values)
    radius <- size / 2 * sqrt(n / total)
    custom <- list(
      n = n,
      leaf = leaf,
      rule = rule,
      condition = trimws(paste(variable, rule))
    )
    marker <- list(
      symbol = "circle",
      radius = radius,
      fillColor = "transparent",
      lineWidth = 0
    )
    if (is.factor(response)) {
      counts <- table(values, useNA = "ifany")
      labels <- names(counts)
      palette <- unname(colors[labels])
      palette[is.na(palette)] <- "#81909A"
      labels[is.na(labels)] <- "Missing"
      parts <- lapply(unname(which(counts > 0L)), function(i) {
        list(name = labels[i], y = as.integer(counts[i]), color = palette[i])
      })
      custom$composition <- parts
      if (shape == "bar" && n > 0) {
        marker <- decision_tree_bar(parts, n, radius)
      }
      swatches <- paste0(
        "<span style='color:",
        palette,
        "'>\u25cf</span> ",
        htmltools::htmlEscape(labels)
      )
      summary <- decision_tree_table(
        c("Category", "N", "%"),
        list(
          swatches,
          as.integer(counts),
          sprintf("%.1f", 100 * counts / max(1, n))
        )
      )
      name <- if (n) labels[which.max(counts)] else ""
    } else {
      custom$mean <- mean(values, na.rm = TRUE)
      custom$sd <- stats::sd(values, na.rm = TRUE)
      q <- stats::quantile(values, c(.25, .5, .75), na.rm = TRUE, names = FALSE)
      name <- format_value(custom$mean)
      marker$fillColor <- paste0("var(--hc-tree-mean-", id, ")")
      summary <- decision_tree_table(
        c("Response", "Value"),
        list(
          c("Mean", "Std. deviation", "Median", "P25 \u2013 P75"),
          c(
            name,
            format_value(custom$sd),
            format_value(q[2]),
            paste(format_value(q[c(1, 3)]), collapse = " \u2013 ")
          )
        )
      )
    }
    test <- NULL
    if (!leaf) {
      split <- partykit::character_split(
        partykit::split_node(node),
        object$data,
        digits = 12
      )
      name <- split$name
      pv <- partykit::info_node(node)$p.value
      if (length(pv) == 1L && is.finite(pv) && pv >= 0 && pv <= 1) {
        custom$p <- unname(pv)
        test <- paste0(
          "<br/>Association with ",
          htmltools::htmlEscape(name),
          " &middot; p ",
          if (pv < .001) {
            "&lt; 0.001"
          } else {
            paste("=", formatC(pv, digits = 3L, format = "f"))
          }
        )
      }
    }
    custom$tooltip <- paste0(
      "<b>",
      if (leaf) "Leaf " else "Node ",
      id,
      " &middot; N = ",
      n,
      "</b>",
      test,
      summary
    )
    result <- list(list(
      id = id,
      parent = parent,
      name = htmltools::htmlEscape(name),
      custom = custom,
      marker = marker
    ))
    for (i in seq_along(kids)) {
      rule <- sub("^<=", "\u2264", sub("^>=", "\u2265", split$levels[i]))
      result <- c(
        result,
        visit(
          kids[[i]],
          id,
          htmltools::htmlEscape(name),
          htmltools::htmlEscape(rule)
        )
      )
    }
    result
  }
  visit(root)
}

decision_tree_table <- function(headers, columns) {
  cells <- function(x, tag, align) {
    paste0(
      "<",
      tag,
      " style='padding:2px 6px;text-align:",
      align,
      "'>",
      x,
      "</",
      tag,
      ">"
    )
  }
  align <- c("left", rep("right", length(headers) - 1L))
  head <- paste(mapply(cells, headers, "th", align), collapse = "")
  rows <- do.call(paste0, Map(function(x, a) cells(x, "td", a), columns, align))
  paste0(
    "<table><thead><tr>",
    head,
    "</tr></thead><tbody>",
    paste0("<tr>", rows, "</tr>", collapse = ""),
    "</tbody></table>"
  )
}

decision_tree_bar <- function(parts, n, radius) {
  shares <- vapply(parts, "[[", integer(1), "y") / n
  width <- pi * radius
  border <- 0.13 * radius
  margin <- border / (2 * width)
  gap <- min(0.023, min(shares) / 3)
  available <- 1 - 2 * margin - (length(parts) - 1L) * gap
  start <- margin
  stops <- list()
  for (i in seq_along(parts)) {
    end <- start + available * shares[i]
    stops <- c(
      stops,
      list(list(start, parts[[i]]$color), list(end, parts[[i]]$color))
    )
    if (i < length(parts)) {
      start <- end + gap
      stops <- c(stops, list(list(end, "#FFFFFF"), list(start, "#FFFFFF")))
    }
  }
  # In an inverted treegraph the marker's local y-axis runs across the screen.
  list(
    symbol = "rect",
    radius = radius,
    width = radius,
    height = width,
    fillColor = list(
      linearGradient = list(x1 = 0, y1 = 1, x2 = 0, y2 = 0),
      stops = stops
    ),
    lineColor = "#FFFFFF",
    lineWidth = border
  )
}

decision_tree_render <- function() {
  htmlwidgets::JS(
    "function () {
    if (this.aligningPies) return;
    var tree = this.series[0], categories = tree.options.custom.categories;
    var container = this.container.style, svg = this.renderer.box.style;
    function color(name, value) {
      container.setProperty(name, value);
      svg.setProperty(name, value);
    }
    if (categories.length) {
      var palette = tree.options.colors || this.options.colors;
      categories.forEach(function (_, i) {
        color('--hc-tree-class-' + i, palette[i % palette.length]);
      });
    } else {
      var axis = this.colorAxis[0];
      tree.points.forEach(function (p) {
        color('--hc-tree-mean-' + p.id, axis.toColor(p.custom.mean));
      });
    }

    var changed = false;
    this.series.forEach(function (pie) {
      var id = pie.options.custom && pie.options.custom.anchor;
      if (!id) return;
      var node = this.get(id);
      if (!node || !node.tooltipPos) return;
      var center = node.tooltipPos.slice(0, 2);
      var old = pie.options.center;
      if (node.visible && (!old || Math.abs(center[0] - old[0]) > 0.1 ||
                           Math.abs(center[1] - old[1]) > 0.1)) {
        pie.update({center: center}, false);
        changed = true;
      }
      if (pie.visible !== node.visible) {
        pie.setVisible(node.visible, false);
        changed = true;
      }
    }, this);
    if (changed) {
      this.aligningPies = true;
      try { this.redraw(false); } finally { this.aligningPies = false; }
    }
  }"
  )
}

#' Explore one boosted tree
#'
#' Select one tree by its one-based index. Marker area represents cover,
#' with a minimum radius for interaction. Internal nodes report split gain
#' and the branch for missing values. Leaves report their contribution to
#' the prediction margin. Supports tree boosters with numeric splits.
#' @param object An `xgb.Booster` fit.
#' @param tree A positive tree index, starting at one.
#' @param ... Highcharts treegraph series options.
#' @return A highchart htmlwidget.
#' @examplesIf rlang::is_installed("xgboost", version = "3.1.0")
#' d <- xgboost::xgb.DMatrix(as.matrix(iris[1:4]), label = iris$Petal.Width)
#' fit <- xgboost::xgb.train(
#'   list(objective = "reg:squarederror", max_depth = 2L, nthread = 1L),
#'   d, nrounds = 3L, verbose = 0
#' )
#' hchart(fit, tree = 2)
#' @export
hchart.xgb.Booster <- function(object, ..., tree = 1L) {
  rlang::check_installed(
    "xgboost",
    version = "3.1.0",
    reason = "to extract a tree."
  )
  if (
    !is.numeric(tree) ||
      length(tree) != 1L ||
      !is.finite(tree) ||
      tree < 1 ||
      tree != trunc(tree)
  ) {
    stop("Choose one positive integer tree index.", call. = FALSE)
  }
  nodes <- xgboost::xgb.model.dt.tree(model = object, trees = tree)
  if (!nrow(nodes)) {
    stop("Tree index exceeds the number of fitted trees.", call. = FALSE)
  }
  yes <- match(nodes$ID, nodes$Yes)
  no <- match(nodes$ID, nodes$No)
  parent <- ifelse(is.na(yes), no, yes)
  leaf <- is.na(nodes$Yes)
  feature <- htmltools::htmlEscape(nodes$Feature)
  threshold <- as.character(signif(nodes$Split[parent], 6))
  rule <- ifelse(
    is.na(parent),
    "",
    paste(ifelse(is.na(yes), "\u2265", "&lt;"), threshold)
  )
  score <- as.character(signif(nodes$Gain, 5))
  info <- ifelse(
    leaf,
    paste("Leaf contribution:", score),
    paste0(
      feature,
      " &lt; ",
      signif(nodes$Split, 6),
      "<br/>Gain: ",
      score,
      "<br/>Missing follows: ",
      ifelse(nodes$Missing == nodes$Yes, "Yes", "No")
    )
  )
  radius <- pmax(
    4,
    16 * sqrt(nodes$Cover / max(nodes$Cover, .Machine$double.eps))
  )
  data <- lapply(seq_len(nrow(nodes)), function(i) {
    point <- list(
      id = nodes$ID[i],
      name = if (leaf[i]) score[i] else feature[i],
      marker = list(radius = radius[i]),
      custom = list(
        label = if (leaf[i]) score[i] else "",
        rule = rule[i],
        cover = nodes$Cover[i],
        detail = info[i]
      )
    )
    if (!is.na(parent[i])) {
      point$parent <- nodes$ID[parent[i]]
    }
    point
  })
  highchart() |>
    hc_chart(inverted = TRUE, spacingLeft = 26, spacingRight = 26) |>
    hc_plotOptions(
      treegraph = utils::modifyList(
        list(
          link = list(type = "straight", color = "#8C8C8C"),
          marker = list(
            fillColor = "#D4E7E5",
            lineColor = "#4E7778",
            lineWidth = 1
          ),
          dataLabels = list(
            enabled = TRUE,
            allowOverlap = TRUE,
            crop = FALSE,
            overflow = "allow",
            pointFormat = "{point.custom.label}",
            linkFormat = "{point.fromNode.name}<br/>{point.toNode.custom.rule}",
            linkTextPath = list(enabled = FALSE),
            style = list(
              color = "#333333",
              fontWeight = "normal",
              textOutline = "2px #FFFFFF"
            )
          ),
          tooltip = list(
            headerFormat = "",
            pointFormat = "{point.custom.detail}<br/>Cover: {point.custom.cover:.2f}",
            linkFormat = "{point.toNode.custom.detail}<br/>Cover: {point.toNode.custom.cover:.2f}"
          )
        ),
        list(...)
      )
    ) |>
    hc_add_series(type = "treegraph", name = paste("Tree", tree), data = data)
}
