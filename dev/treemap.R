
rm(list = ls())
library("dplyr")
library("treemap")

data(GNI2014)
head(GNI2014)

tm <- treemap(GNI2014,
        index=c("continent", "iso3"),
        vSize="population",
        vColor="GNI",
        type="value",
        palette = rev(viridis::viridis(5)))

tm <- treemap(df,
              index = c("manufacturer", "class", "model"),
              vSize="n",
              vColor="hwy",
              palette = rev(viridis::viridis(5)))


tmdata <- tbl_df(tm$tm)

tmdata
