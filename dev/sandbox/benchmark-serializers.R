# Run from the package root with Rscript dev/sandbox/benchmark-serializers.R.
# Uses the same payload builder and serializer dispatcher as htmlwidgets 1.6.4.
pkgload::load_all(quiet = TRUE)

benchmark_serializers <- function(repetitions = 10L) {
  points <- data.frame(x = seq_len(10000L))
  points$y <- (points$x %% 601L) / 8
  small <- head(points, 100L)
  nested <- head(points, 1000L)
  nested$custom <- lapply(nested$x, function(i) {
    list(id = i, range = c(i, i + 5L))
  })
  gaps <- points
  gaps$y[5000L] <- NA_real_
  meta <- head(nested, 3L)
  meta$custom <- list(list(id = "NA"), NULL, list(id = NA_integer_))
  cases <- list(
    xy_100 = function() hchart(small, "line", hcaes(x, y)),
    vector_10000 = function() highchart() |> hc_add_series(data = points$y),
    xy_10000 = function() hchart(points, "line", hcaes(x, y)),
    xy_10000_gap = function() hchart(gaps, "line", hcaes(x, y)),
    nested_1000 = function() hchart(nested, "scatter", hcaes(x, y)),
    missing_metadata = function() hchart(meta, "line", hcaes(x, y)),
    map_chile = function() hcmap("cl")
  )
  make_payload <- getFromNamespace("createPayload", "htmlwidgets")
  encode <- getFromNamespace("toJSON", "htmlwidgets")
  decode <- function(json) jsonlite::fromJSON(json, simplifyVector = FALSE)
  now <- function() as.numeric(Sys.time())
  routes <- c("jsonlite", "yyjsonr")
  results <- list()

  for (case in names(cases)) {
    build <- cases[[case]]
    reference <- NULL
    for (round in 0:repetitions) {
      # Warm up both routes, then alternate their order for each paired run.
      order <- if (round %% 2L == 0L) routes else rev(routes)
      for (route in order) {
        start <- now()
        payload <- make_payload(build())
        if (route == "jsonlite") {
          attr(payload$x, "TOJSON_FUNC") <- NULL
        }
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

  cat(R.version.string, "\n")
  print(vapply(
    c("htmlwidgets", "jsonlite", "yyjsonr"),
    function(pkg) as.character(packageVersion(pkg)),
    character(1)
  ))
  invisible(times)
}

benchmark_serializers()
