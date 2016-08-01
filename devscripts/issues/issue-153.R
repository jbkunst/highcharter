#' --- 
#' output: html_document
#' title: Issue 153
#' --- 
#'
#' From https://github.com/jbkunst/highcharter/issues/153

library(highcharter)

txt <- "Month | Impressions | Clicks |  CTR | CPC | Position | Cost | Conversions | Conv.rate | Cost_conv
2016-07-01 | 1385 | 161 | 11.6 | 0.2 | 1.7  | 36.3 | 3.33 | 2.1 | 10.9"

con <- textConnection(txt)

df <- read.table(con, sep = "|", header = TRUE)

df
