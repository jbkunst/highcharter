---
title       : Testing htmlwidgets in slidify and revealjs 
author      : Joshua Kunst
job         : bugmaker
framework   : revealjs        # {io2012, html5Tests, shower, dzTests, ...}
highlighter : highlight.js  # {highlight.js, prettify, highlight}
hitheme     : tomorrow      # 
widgets     : []            # {mathjax, quiz, bootstrap}
mode        : selfcontained # {standalone, draft}
knit        : slidify::knit2Tests
---



## How works

This function for every htmlwidget save separately with a random
name and then put an iframe with the respective source file.


```r
knit_print.htmlwidget <- function(x, ..., options = NULL){
  
  options(pandoc.stack.size = "2048m")
  
  wdgtclass <- setdiff(class(x), "htmlwidget")[1]
  wdgtrndnm <- paste0(sample(letters, size = 7), collapse = "")
  wdgtfname <- sprintf("wdgt_%s_%s.html", wdgtclass, wdgtrndnm)
  
  htmlwidgets::saveWidget(x, file = wdgtfname, selfcontained = TRUE, background = "transparent")
  
  iframetxt <- sprintf("<iframe  frameBorder=\"0\" src=\"%s\" width=\"100%%\" height=\"600\"></iframe>", wdgtfname)
  
  knitr::asis_output(iframetxt)
}
```

---
## Test 1


<iframe  frameBorder="0" src="wdgt_highchart_cxfgnzq.html" width="100%" height="600"></iframe>

---
## Test 2


<iframe  frameBorder="0" src="wdgt_highchart_onijvay.html" width="100%" height="600"></iframe>

---
## Test 3

<iframe  frameBorder="0" src="wdgt_highchart_lhurkte.html" width="100%" height="600"></iframe>

---
## Test 3

<iframe  frameBorder="0" src="wdgt_highchart_hbmjaye.html" width="100%" height="600"></iframe>

---
## All htmlwidgets

<iframe  frameBorder="0" src="wdgt_d3heatmap_cyimbjw.html" width="100%" height="600"></iframe>


---
## All htmlwidgets

<iframe  frameBorder="0" src="wdgt_datatables_rsmdyqg.html" width="100%" height="600"></iframe>



