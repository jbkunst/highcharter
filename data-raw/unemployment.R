url <- "https://www.highcharts.com/samples/data/jsonp.php?filename=us-counties-unemployment.json"
tmpfile <- tempfile(fileext = ".json")
download.file(url, tmpfile)
unemployment <- readLines(tmpfile)
unemployment <- gsub("callback\\(|\\);$", "", unemployment)
unemployment <- jsonlite::fromJSON(unemployment, simplifyVector = FALSE)
unemployment <- map_df(unemployment, function(x) as.data.frame(x, stringsAsFactors = FALSE))
unemployment$name <- iconv(unemployment$name)
unemployment <- tibble::as_tibble(unemployment)

devtools::use_data(unemployment, overwrite = TRUE)
