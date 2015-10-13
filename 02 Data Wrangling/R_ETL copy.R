require(tidyr)
require(dplyr)
require(ggplot2)

setwd("C:/Users/chase_000/Desktop/College/Fall 2015/Data Visualization/DV_RProject2/01 Data/lahman-csv_2015-01-24")

file_path <- "Batting.csv"

measures <- c("yearID","stint","G","AB","R","H","2B","3B","HR","RBI","SB","CS","BB","SO","IBB","HBP","SH","SF","GIDP")

df <- read.csv(file_path, stringsAsFactors = FALSE)

str(df)
View(df)
write.csv(df, paste(gsub(".csv", "", file_path), ".reformatted.csv", sep=""), row.names=FALSE, na = "")
tableName <- gsub(" +", "_", gsub("[^A-z, 0-9, ]", "", gsub(".csv", "", file_path)))
sql <- paste("CREATE TABLE", tableName)
sql <- paste(sql, ");")
cat(sql)
