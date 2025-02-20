require(tidyr)
require(dplyr)
require(ggplot2)

setwd("~/Desktop/CS/Data Visualization/DV_RProject3/01 Data/lahman-csv_2015-01-24 copy")

file_path <- "AllstarFull.csv"

batdf <- read.csv(file_path, stringsAsFactors = FALSE)

# Replace "." (i.e., period) with "_" in the column names.
names(batdf) <- gsub("\\.+", "_", names(batdf))

measures <- c("yearID","gameNum","GP")

for(n in names(batdf)) {
  batdf[n] <- data.frame(lapply(batdf[n], gsub, pattern="[^ -~]",replacement= ""))
}
library(lubridate)
dimensions <- setdiff(names(batdf), measures)

if( length(measures) > 1 || ! is.na(dimensions)) {
  for(d in dimensions) {
    # Get rid of " and ' in dimensions.
    batdf[d] <- data.frame(lapply(batdf[d], gsub, pattern="[\"']",replacement= ""))
    # Change & to and in dimensions.
    batdf[d] <- data.frame(lapply(batdf[d], gsub, pattern="&",replacement= " and "))
    # Change : to ; in dimensions.
    batdf[d] <- data.frame(lapply(batdf[d], gsub, pattern=":",replacement= ";"))
  }
}

# Get rid of all characters in measures except for numbers, the - sign, and period.dimensions
if( length(measures) > 1 || ! is.na(measures)) {
  for(m in measures) {
    batdf[m] <- data.frame(lapply(batdf[m], gsub, pattern="[^--.0-9]",replacement= ""))
  }
}

batdf <- batdf %>% filter(as.numeric(as.character(yearID)) > 1985)

write.csv(batdf, paste(gsub(".csv", "", file_path), ".reformatted.csv", sep=""), row.names=FALSE, na = "")

Bats <- gsub(" +", "_", gsub("[^A-z, 0-9, ]", "", gsub(".csv", "", file_path)))
sql <- paste("CREATE TABLE", Bats, "(") 
if( length(measures) > 1 || ! is.na(dimensions)) {
  for(d in dimensions) {
    sql <- paste(sql, paste(d, "varchar2(4000),\n"))
  }
}
if( length(measures) > 1 || ! is.na(measures)) {
  for(m in measures) {
    if(m != tail(measures, n=1)) sql <- paste(sql, paste(m, "number(38,4),\n"))
    else sql <- paste(sql, paste(m, "number(38,4)\n"))
  }
}
sql <- paste(sql, ");")
cat(sql)

