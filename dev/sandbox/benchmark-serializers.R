# Run from the package root with Rscript dev/sandbox/benchmark-serializers.R.
# Uses the same payload builder and serializer dispatcher as htmlwidgets 1.6.4.
pkgload::load_all(quiet = TRUE)
stopifnot(requireNamespace("rjson", quietly = TRUE))

benchmark_serializers <- function(repetitions = 10L) {
  old <- options(highcharter.debug = FALSE, highcharter.verbose = FALSE)
  old <- c(old, options("highcharter.rjson"))
  on.exit(options(old))

  points <- data.frame(x = seq_len(10000L))
  points$y <- (points$x %% 601L) / 8
  small <- head(points, 100L)
  nested <- head(points, 1000L)
  nested$custom <- lapply(nested$x, function(i) {
    list(id = i, range = c(i, i + 5L))
  })
  gaps <- head(points, 3L)
  gaps$y[2L] <- NA_real_
  meta <- head(points, 3L)
  meta$custom <- list(list(id = 1L), NULL, list(id = NA_integer_))

  cases <- list(
    xy_100 = function() hchart(small, "line", hcaes(x, y)),
    vector_10000 = function() highchart() |> hc_add_series(data = points$y),
    xy_10000 = function() hchart(points, "line", hcaes(x, y)),
    nested_1000 = function() hchart(nested, "scatter", hcaes(x, y)),
    map_chile = function() hcmap("cl")
  )
  # Keep incomplete examples out of timings: the optional path drops rows.
  probes <- list(
    missing_y = function() hchart(gaps, "line", hcaes(x, y)),
    list_column = function() hchart(meta, "line", hcaes(x, y)),
    numeric_na = function() highchart() |> hc_add_series(data = gaps$y)
  )
  make_payload <- getFromNamespace("createPayload", "htmlwidgets")
  encode <- getFromNamespace("toJSON", "htmlwidgets")
  decode <- function(json) jsonlite::fromJSON(json, simplifyVector = FALSE)
  now <- function() as.numeric(Sys.time())
  routes <- c(jsonlite = FALSE, rjson = TRUE)
  results <- list()

  for (case in names(cases)) {
    build <- cases[[case]]
    reference <- NULL
    for (round in 0:repetitions) {
      # Warm up both routes, then alternate their order for each paired run.
      order <- if (round %% 2L == 0L) names(routes) else rev(names(routes))
      for (route in order) {
        options(highcharter.rjson = routes[[route]])
        start <- now()
        payload <- make_payload(build())
        ready <- now()
        json <- encode(payload)
        end <- now()
        if (round == 0L) {
          decoded <- decode(json)
          if (route == "jsonlite") {
            reference <- decoded
          } else {
            stopifnot(isTRUE(all.equal(reference, decoded, tolerance = 1e-12)))
          }
        } else {
          results[[length(results) + 1L]] <- data.frame(
            case,
            route,
            round,
            prepare_ms = (ready - start) * 1000,
            json_ms = (end - ready) * 1000,
            total_ms = (end - start) * 1000,
            bytes = nchar(json, type = "bytes")
          )
        }
      }
    }
  }
  times <- do.call(rbind, results)
  print(
    aggregate(
      cbind(prepare_ms, json_ms, total_ms, bytes) ~ case + route,
      data = times,
      FUN = median
    ),
    digits = 6,
    row.names = FALSE
  )
  print(
    aggregate(total_ms ~ case + route, data = times, FUN = function(x) {
      quantile(x, c(0.25, 0.75))
    }),
    digits = 6,
    row.names = FALSE
  )

  for (case in names(probes)) {
    for (route in names(routes)) {
      options(highcharter.rjson = routes[[route]])
      points <- decode(encode(make_payload(probes[[
        case
      ]]())))$x$hc_opts$series[[1]]$data
      cat(
        case,
        route,
        as.character(jsonlite::toJSON(
          points,
          auto_unbox = TRUE,
          null = "null"
        )),
        "\n"
      )
    }
  }
  cat(R.version.string, "\n")
  print(vapply(
    c("htmlwidgets", "jsonlite", "rjson"),
    function(pkg) as.character(packageVersion(pkg)),
    character(1)
  ))
  invisible(times)
}

benchmark_serializers()
