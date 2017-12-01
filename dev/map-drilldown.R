#Highcharter Drill Down Example

##Load Data/Packages
#We are reading two files: 
#(1) State election outcomes for 2012 & 2016 Presidential elections, 
#(2) County outcomes for the same years. 

#Install pacman if needed
# install.packages("pacman")

#Load Packages
pacman::p_load(highcharter, htmltools, rio, stringr, DT,dplyr)

#Import state data
ed <- import("http://onsocialtrends.org/politics/state.Rds")

#Importing county data
ed.cn <- import("http://onsocialtrends.org/politics/county.Rds")

#Clean County fips so all have 5 digits
ed.cn$FIPS1 <- str_pad(ed.cn$FIPS1, 5, pad = "0")

#Add state code for drilldown
ed.cn$StFIPS <- as.numeric(str_sub(ed.cn$FIPS1, 1, 2))

data("usgeojson")
data("uscountygeojson")
#not needed
uscountygeojson$`hc-transform`$`us-all-all-hawaii` <- NULL
uscountygeojson$`hc-transform`$`us-all-all-alaska` <- NULL

##Create Data for Mapping & Tooltips


#create index vector to subset uscountygeojson by state code
cn_st_index <- unlist(lapply(uscountygeojson$features, function (x){
  if(is.null(x$id))
    NA
  else
    str_to_lower(x$properties$fips) %>% str_sub(1, 2) %>% as.numeric()
}))

#build drilldown series
build_series <- function(stateCode, year) {
  
  #subset uscountygeojson
  uscountygeojson.subset <- uscountygeojson
  uscountygeojson.subset$features <- uscountygeojson$features[which(cn_st_index == stateCode)]
  
  #subset county data
  ds.cn <- filter(ed.cn, StFIPS == stateCode & Year == year) %>% 
    transmute(value = party, code = FIPS1, Per_Dem= Per_Dem*100, per_rep = Per_Rep*100, cnlabel = CountyName, stlabel = State_Name) %>%
    list_parse()
  
  #build series
  list(
    id = stateCode,
    mapData = uscountygeojson.subset,
    data = ds.cn,
    joinBy = c('fips',"code"),
    dataLabels = list(enabled = TRUE, format = '{point.name}'),
    tooltip = list(
      useHTML = TRUE,
      headerFormat = "<p>",
      pointFormat = paste0("<b>{point.stlabel}, {point.cnlabel}</b><br>",
                           "<b style=\"color:#1874CD\">% Democrat:</b> {point.Per_Dem:.3f}<br>",
                           "<b style=\"color:red\">% Republican:</b> {point.per_rep:.3f}<br>"
      ),
      footerFormat = "</p>")
  )
}

##Make the graph

fig <- (lapply(split(ed, ed$year), function(ed) {
  
  #leave only necessary variables from state df
  dt.st <- ed %>% 
    transmute(value = party, code = `FIPS Code`, per_dem = per_dem*100, per_rep = per_rep*100, stlabel = State, drilldown = `FIPS Code`)
  ds.st <- list_parse(dt.st)
  
  #create drilldown series
  series.list <- lapply(as.numeric(dt.st$drilldown), build_series, year = unique(ed$year))
  
  #tooltim for state map has to be coded separately from tooltip for county
  highchart(type = 'map') %>%
    hc_add_series(
      mapData = usgeojson, data = ds.st, joinBy = c("statefips", "code"),
      borderWidth = 0.8, dataLabels = list(enabled = TRUE, format = '{point.properties.postalcode}'),
      tooltip = list( 
        useHTML = TRUE,
        headerFormat = "<p>",
        pointFormat = paste0("<b>{point.stlabel}</b><br>",
                             "<b style=\"color:#1874CD\">% Democrat:</b> {point.per_dem:.3f}<br>",
                             "<b style=\"color:red\">% Republican:</b> {point.per_rep:.3f}<br>"
        ),
        footerFormat = "</p>"
      )) %>%
    hc_title(text = unique(ed$title)) %>%
    hc_plotOptions(map = list(states = list(hover = list(color = '#FFFFFF')))) %>%
    hc_colorAxis(dataClasses = color_classes(c(seq(0, 1, by = 0.5), 1), colors = c("red", "#1874CD"))) %>%
    hc_legend(enabled = FALSE) %>%
    hc_exporting(enabled = TRUE)%>%
    hc_drilldown(
      series = series.list,
      activeDataLabelStyle = list(
        color =  '#FFFFFF',
        textDecoration = 'none'
      )
    ) %>%
    hc_add_theme(hc_theme_db())
}))

hw_grid(fig, rowheight = 500, ncol = 1) %>% browsable()
#hw_grid(fig, rowheight = 300, ncol = 2) %>% save_html(file = 'outputMap.html')

