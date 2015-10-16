require("jsonlite")
require("RCurl")
require("dplyr")

salary <- data.frame(fromJSON(getURL(URLencode('129.152.144.84:5001/rest/native/?query="select * from SALARIES where yearID > 1985"'),httpheader=c(DB='jdbc:oracle:thin:@129.152.144.84:1521/PDBF15DV.usuniversi01134.oraclecloud.internal', USER='cs329e_alk2223', PASS='orcl_alk2223', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE), ))


batting <- data.frame(fromJSON(getURL(URLencode('129.152.144.84:5001/rest/native/?query="select * from BATTING where yearID > 1985"'),httpheader=c(DB='jdbc:oracle:thin:@129.152.144.84:1521/PDBF15DV.usuniversi01134.oraclecloud.internal', USER='cs329e_alk2223', PASS='orcl_alk2223', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE), ))


salbat <- dplyr::full_join(salary, batting, by="PLAYERID") 
dfb <- salbat %>% select(SALARY, HR, PLAYERID, YEARID.x) %>% filter(salbat$PLAYERID == "bondsba01" | salbat$PLAYERID == "mcgwima01" | salbat$PLAYERID == "sosasa01") 



require("jsonlite")
require("RCurl")

summary(dfb)
head(dfb)

require(ggplot2)
require(extrafont)
ggplot() + 
  coord_cartesian() + 
  scale_x_continuous() +
  scale_y_continuous() +
  #facet_grid(PCLASS~SURVIVED, labeller=label_both) +
  labs(title='Baseball') +
  labs(x="Salary", y=paste("HR")) +
  layer(data=dfb, 
        mapping=aes(x=as.numeric(as.character(SALARY)), y=as.numeric(as.character(HR)), color=as.character(PLAYERID), 
        stat="identity", 
        stat_params=list(), 
        geom="point",
        geom_params=list(), 
        #position=position_identity()
        position=position_jitter(width=0.3, height=0)
  )